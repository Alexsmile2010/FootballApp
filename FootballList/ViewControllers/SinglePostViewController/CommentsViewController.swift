//
//  CommentsViewController.swift
//  FootballList
//
//  Created by user on 26.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class CommentsViewController: BaseViewController
{
    //MARK: - IBA
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView:UITextView!
    @IBOutlet weak var sendButton:UIButton!
    @IBOutlet weak var commentInfoLabel: UILabel!
    @IBOutlet weak var commentBarBottomConstraint:NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint:NSLayoutConstraint!
    
    //MARK: - VAR
    fileprivate var postRef: FIRDatabaseReference!
    fileprivate var comments: [Comment] = []
    fileprivate var isPreloadData:Bool = true
    
    
    override var estimateRowHeight: CGFloat
    {
        get{
            return 103
        }
    }
    
    var postKey: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.registerNib()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.postRef = Firebase.shared.getPostCommentsRef(key: self.postKey)
        self.loadData()
        
        IQKeyboardManager.sharedManager().enable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.commentBarBottomConstraint.constant = keyboardHeight
            self.tableViewBottomConstraint.constant = keyboardHeight + 50.0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
        self.commentBarBottomConstraint.constant = 0
         self.tableViewBottomConstraint.constant = 50.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.isPreloadData = false
        self.setupTextView()
    }
    
    fileprivate func loadData()
    {
        self.postRef.observe(.value, with: {[weak self] (snapshot) in
            
            guard let value: Dict = snapshot.value as? Dict else {return}
            
            self?.commentInfoLabel.isHidden = true
            
            for key in value.keys
            {
                let singlePost: Dict = value[key] as! Dict;
                let comment = Comment(value: singlePost)
            
                if self?.comments.contains(comment) == false
                {
                    self?.comments.append(comment)
                }
                else
                {
                    let index = self?.comments.index(of: comment)
                    self?.comments[index!] = comment
                }
            }
            self?.comments.sort{
                $0.timestamp < $1.timestamp
            }
            
            
            
            if self?.isPreloadData == false
            {
                let lastCell = IndexPath(row:(self?.comments.count)!-1, section:0)
                self?.tableView.insertRows(at: [lastCell], with: .none)
                self?.tableView.scrollToRow(at: lastCell, at: .top, animated: true)
            }
            else
            {
                self?.tableView.reloadData()
            }
            
        })
    }
    
    fileprivate func returnTapped()
    {
        if AuthManager.shared.isLoginUser() == true
        {
            let comment = self.commentTextView?.text
            if (comment?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true) || comment == STRINGS.COMMENT_PLACEHOLDER
            {
                let alert = UIAlertController(title: STRINGS.TITLES.ERROR, message: STRINGS.MESSAGES.COMMENT_EMPTY, preferredStyle: .alert)
                let authAction = UIAlertAction(title: STRINGS.TITLES.OK, style: .default, handler: { (_) in
                    
                })
                alert.addAction(authAction)
                Storyboard.getRootViewController().presentVC(alert)
                self.commentTextView.text = ""
            }
            else
            {
                Utilities.showHUD()
                let userID = FIRAuth.auth()?.currentUser?.uid
                Firebase.shared.getUserNameByIdRef(userId: userID!).observeSingleEvent(of: .value, with: {
                    snapshot in
                    
                                        guard let value: Dict = snapshot.value as? Dict else {return}
                    let username = value[FRBKEYS.USERNAME] as! String
                    
                    let timeInterval = Date().timeIntervalSince1970
                    let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
                    let commentKey = Int64(timeInterval * 1000)
                    let comment = [FRBKEYS.UID: userID!,
                                   FRBKEYS.AUTHOR: username,
                                   FRBKEYS.COMMENT: comment as Any,
                                   FRBKEYS.TIMESTAMP:timestamp] as [String : Any]
                    self.postRef.child("\(commentKey)").setValue(comment)
                    self.commentTextView?.text = ""
                    self.commentTextView?.resignFirstResponder()
                    Utilities.hideHUD()
                })
            }
        }
        else
        {
            AuthManager.shared.showNonAuthAlert()
        }
    }
    
    fileprivate func setupTextView()
    {
        self.commentTextView?.text = STRINGS.COMMENT_PLACEHOLDER
        self.commentTextView?.textColor = UIColor.lightGray
        self.commentTextView?.textAlignment = .center
        self.commentTextView?.isScrollEnabled = false
        self.commentTextView?.inputAccessoryView = UIView()
        self.commentTextView.addBorder(width: 1, color: .groupTableViewBackground)
        self.commentTextView.setCornerRadius(radius: 3)
    }
    
    @IBAction func writeComment(_ sender: Any)
    {
        self.returnTapped()
    }


}

//MAKR: - UITableViewDataSource

extension CommentsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: CommentCell = tableView.dequeueReusableCell(CommentCell.self, for: indexPath)
        cell.setCell(comment: self.comments[indexPath.row])
        return cell
    }
}

//MAKR: - UITableViewDelegate

extension CommentsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.estimateRowHeight
    }
}

//MARK: - UITextViewDelegate

extension CommentsViewController: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.textAlignment = .left
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = STRINGS.COMMENT_PLACEHOLDER
            textView.textAlignment = .center
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}

