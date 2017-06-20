//
//  SinglePostCell.swift
//  FootballList
//
//  Created by user on 26.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Nuke
import Async
import Firebase
import SKPhotoBrowser

class SinglePostCell: BasePostCell
{

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var bannerContainerView: UIView!
    
    @IBOutlet weak var titleHeightConstarains: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextConstrains: NSLayoutConstraint!
    
    fileprivate var postRef: FIRDatabaseReference!
    fileprivate var post: Post!
    var delegate: PostCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.mainImageView.setCornerRadius(radius: 3)
        
        self.mainImageView.addTapGesture { (gesture) in
            
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImageURL(self.post.url)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            Storyboard.getRootViewController().presentVC(browser)
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    open func setCell(post: Post)
    {
        
        self.post = post
        self.mainTitleLabel.text = post.title
       // self.dateLabel.text = post.timestamp
        self.votesCountLabel.text = "\(post.votes)"
        self.descriptionTextView.text = post.desc
        
        let request = Request(url: post.imgUrl)
        
        if AuthManager.shared.isLoginUser() == true
        {
            self.checkIsLikePost(post: self.post, button: self.voteButton)
        }
        
        guard var image = Cache.shared[request] else
        {
            Nuke.loadImage(with: post.imgUrl, into: self.mainImageView){ [weak mainImageView] response, _ in
                
                var image: UIImage?
                
                Async.background({
                    image = response.value?.resizeWithWidth(self.mainImageView.w)
                    Cache.shared[request] = image
                }).main({
                    mainImageView?.image = image
                    self.delegate?.mainImageDidSet!(cell: self)
                })
            }
            return
        }
        
        if image.size.width > self.mainImageView.w
        {
            image = image.resizeWithWidth(self.mainImageView.w)
        }
    
        self.mainImageView.image = image
        self.delegate?.mainImageDidSet!(cell: self)
    }
    
    open func setConstains(textH: CGFloat, imageH: CGFloat, desсH: CGFloat)
    {
        self.titleHeightConstarains.constant = ceil(textH)
        self.imageHeightConstrains.constant = ceil(imageH)
        self.descriptionTextConstrains.constant = ceil(desсH)
        self.layoutIfNeeded()
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
                    self?.setEmptyLikeButton(button: (self?.voteButton)!)
                    self?.post.addSubtrackVote(addVote: true)
                    voteRef.setValue(true)
                    self?.votesCountLabel.text = "\((self?.post.votes)!)"
                }
                else
                {
                    self?.setSelectLikeButton(button: (self?.voteButton)!)
                    self?.post.addSubtrackVote(addVote: false)
                    voteRef.removeValue()
                    self?.votesCountLabel.text = "\((self?.post.votes)!)"
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("SinglePostDidLike"), object: self?.post)
            })
        }
        else
        {
            AuthManager.shared.showNonAuthAlert()
        }
    }
    
//    @IBAction func addToFavoriteButtonTapped(_ sender: Any)
//    {
//        let result = RealmManager.shared.isFavoritePost(post: self.post)
//        
//        if result.isFavorite == false
//        {
//            RealmManager.shared.addPostToFavorite(post: self.post)
//            self.selectFavoriteButton(button: self.favoriteButton)
//        }
//        else
//        {
//            RealmManager.shared.removeFromFavorites(post: result.post!, favorite: result.favorite!)
//            self.unSelecetFavoriteButton(button: self.favoriteButton)
//        }
//        self.chekIsFavoritePost(post: self.post, button: self.favoriteButton)
//
//    }

    @IBAction func shareButtonTapped(_ sender: Any)
    {
        ShareManager.showShareViewController(post: self.post)
    }
    
}
