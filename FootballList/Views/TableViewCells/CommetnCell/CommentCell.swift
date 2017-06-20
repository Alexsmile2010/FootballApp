//
//  CommentCell.swift
//  FootballList
//
//  Created by user on 01.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell
{

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        self.commentTextView.setCornerRadius(radius: 3)
    }
    
    func setCell(comment: Comment)
    {
        self.userNameLabel.text = comment.author
        self.dateLabel.text = Date(timeIntervalSince1970: TimeInterval(comment.timestamp / 1000)).toString(format: "dd-MMMM HH:mm")
        self.commentTextView.text = comment.comment
    }
}

