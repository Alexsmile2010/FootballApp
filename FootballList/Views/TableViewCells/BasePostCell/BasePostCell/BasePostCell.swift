//
//  BasePostCell.swift
//  FootballList
//
//  Created by user on 26.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import AvatarImageView
import Async
import Firebase

@objc protocol PostCellDelegate
{
    @objc optional func mainImageDidSet(cell: UITableViewCell)
    @objc optional func voteButtonDidTap(post: Post)
}

class BasePostCell: UITableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

extension BasePostCell
{
    func checkIsLikePost(post: Post, button: UIButton)
    {
        let voteRef = Firebase.shared.getVoteRef(newsKey: post.key)
        voteRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if (snapshot.value as? NSNull) != nil
            {
                self.setEmptyLikeButton(button: button)
            }
            else
            {
                self.setSelectLikeButton(button: button)
            }
        })
    }
    
    func checkIsLikePost(videoPost: VidmeVideoPost, button: UIButton)
    {
        let voteRef = Firebase.shared.getVoteRef(newsKey: videoPost.key)
        voteRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if (snapshot.value as? NSNull) != nil
            {
                self.setEmptyLikeButton(button: button)
            }
            else
            {
                self.setSelectLikeButton(button: button)
            }
        })
    }
    
    
    func chekIsFavoritePost(post: Post, button: UIButton)
    {
        let result = RealmManager.shared.isFavoritePost(post: post)
        
        if result.isFavorite == true
        {
            self.selectFavoriteButton(button: button)
        }
        else
        {
            self.unSelecetFavoriteButton(button: button)
        }
    }
    
    func setEmptyLikeButton(button: UIButton)
    {
        button.setImage(UIImage(named: "Like"), for: .normal)
    }
    
    func setSelectLikeButton(button: UIButton)
    {
        button.setImage(UIImage(named: "Like Filled"), for: .normal)
    }
    
    func selectFavoriteButton(button: UIButton)
    {
        button.setImage(UIImage(named: "InFavorite"), for: .normal)
    }
    
    func unSelecetFavoriteButton(button: UIButton)
    {
        button.setImage(UIImage(named: "AddFavotire"), for: .normal)
    }
}
