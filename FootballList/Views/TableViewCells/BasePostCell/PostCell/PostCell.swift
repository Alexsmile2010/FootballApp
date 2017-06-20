//
//  NewsFeedCell.swift
//  FootballList
//
//  Created by user on 03.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Nuke
import Async
import Firebase


class PostCell: BasePostCell
{
    //MARK: - IBO
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainImageViewHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeightConstrains: NSLayoutConstraint!
    
    
    //MARK: - VAR
    
    fileprivate var post: Post!
    var delegate: PostCellDelegate?
    var isReadMore:Bool!
    {
        if self.post.postType == .defaultType
        {
            return false
        }
        else
        {
            return true
        }
    }
    
   
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.readMoreLabel.setCornerRadius(radius: 3)
        self.mainImageView.setCornerRadius(radius: 3)
        self.setReadMoreLabelTextUnderLine()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

    open func setCell(post: Post)
    {
        self.post = post
        self.mainTitleLabel.text = post.title
        //self.dateLabel.text = post.timestamp
        self.votesCountLabel.text = "\(post.votes)"
        
        if AuthManager.shared.isLoginUser() == true
        {
            self.checkIsLikePost(post: self.post, button: self.voteButton)
        }
        
        self.mainImageView.image = nil
        
        Nuke.loadImage(with: post.imgUrl, into: self.mainImageView)
        
        if self.isReadMore == false
        {
            self.readMoreLabel.isHidden = true
        }
        else
        {
            self.readMoreLabel.isHidden = false
        }
    }
    
    open func setConstains(textH: CGFloat, imageH: CGFloat)
    {
        self.titleLabelHeightConstrains.constant = ceil(textH)
        self.mainImageViewHeightConstrains.constant = ceil(imageH)
        self.layoutIfNeeded()
    }
    
    func setReadMoreLabelTextUnderLine()
    {
        let textRange = NSMakeRange(0, (self.readMoreLabel.text?.characters.count)!)
        let attributedText = NSMutableAttributedString(string: readMoreLabel.text!)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        self.readMoreLabel.attributedText = attributedText
    }
    
    //MARK: - IBA
    
    @IBAction func voteButtonTapped(_ sender: Any)
    {
        if AuthManager.shared.isLoginUser() == true
        {
            let voteRef = Firebase.shared.getVoteRef(newsKey: self.post.key)
            
            voteRef.observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
                
                if (snapshot.value as? NSNull) != nil
                {
                    self?.setSelectLikeButton(button: (self?.voteButton)!)
                    self?.post.addSubtrackVote(addVote: true)
                    voteRef.setValue(true)
                    self?.votesCountLabel.text = "\((self?.post.votes)!)"
                }
                else
                {
                    self?.setEmptyLikeButton(button: (self?.voteButton)!)
                    self?.post.addSubtrackVote(addVote: false)
                    voteRef.removeValue()
                    self?.votesCountLabel.text = "\((self?.post.votes)!)"
                }
                
                self?.delegate?.voteButtonDidTap!(post: (self?.post)!)
            })
        }
        else
        {
            AuthManager.shared.showNonAuthAlert()
        }
    }
    
    @IBAction func addToFavoriteButtonTapped(_ sender: Any)
    {
        let result = RealmManager.shared.isFavoritePost(post: self.post)
        
        if result.isFavorite == false
        {
            RealmManager.shared.addPostToFavorite(post: self.post)
            //self.selectFavoriteButton(button: self.favoritebutton)
        }
        else
        {
           RealmManager.shared.removeFromFavorites(post: result.post!, favorite: result.favorite!)
         //   self.unSelecetFavoriteButton(button: self.favoritebutton)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any)
    {
        ShareManager.showShareViewController(post: self.post)
    }
    
}


