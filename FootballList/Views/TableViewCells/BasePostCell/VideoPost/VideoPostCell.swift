//
//  VideoPostCell.swift
//  FootballList
//
//  Created by Олексій on 03.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Nuke
import Async
import Firebase


class VideoPostCell: BasePostCell
{
    
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    fileprivate var post: VidmeVideoPost!
    var delegate: PostCellDelegate?
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    open func setCell(post: VidmeVideoPost)
    {
        self.post = post
        self.mainTitleLabel.text = post.title
    
        self.dateLabel.text = post.date_published
        
        Nuke.loadImage(with: post.thumbnailUrl, into: self.mainImageView)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any)
    {
        ShareManager.showShareViewController(videoPost: self.post)
    }
    
}
