//
//  MenuHeaderCell.swift
//  FootballList
//
//  Created by Олексій on 16.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Nuke
import Async


class MenuHeaderCell: UITableViewCell
{
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var username: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.profilePictureImageView.setCornerRadius(radius: 50)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    open func setCell(user: User)
    {
        self.username?.text = user.username
        if user.profilePictureUrl != ""
        {
            let imgUrl:URL = URL(string: user.profilePictureUrl)!
            let request = Request(url: imgUrl)
            
            guard let image = Cache.shared[request] else
            {
                Nuke.loadImage(with: imgUrl, into: self.profilePictureImageView){ [weak profilePictureImageView] response, _ in
                    
                    Async.background({
                        let image = response.value
                        Cache.shared[request] = image
                    }).main({
                        profilePictureImageView?.image = response.value
                    })
                }
                return
            }
            
            self.profilePictureImageView?.image = image
        }
        
    }
    
}
