//
//  Extensions.swift
//  FootballList
//
//  Created by user on 03.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import UIKit
import EZSwiftExtensions

extension UITableView
{
    func dequeueReusableCell<T: UITableViewCell>(_ withClass: T.Type, for indexPath: IndexPath) -> T
    {
        return self.dequeueReusableCell(withIdentifier: String(describing: withClass), for: indexPath) as! T
    }
    
    func registerNib()
    {
        self.register(UINib(nibName: SinglePostCell.className, bundle: nil), forCellReuseIdentifier:SinglePostCell.className)
        self.register(UINib(nibName: PostCell.className, bundle: nil), forCellReuseIdentifier:PostCell.className)
        self.register(UINib(nibName: MenuCell.className, bundle: nil), forCellReuseIdentifier:MenuCell.className)
        self.register(UINib(nibName: CommentCell.className, bundle: nil), forCellReuseIdentifier:CommentCell.className)
        self.register(UINib(nibName: VideoPostCell.className, bundle: nil), forCellReuseIdentifier:VideoPostCell.className)
        self.register(UINib(nibName: MenuHeaderCell.className, bundle: nil), forCellReuseIdentifier:MenuHeaderCell.className)
    }
}

extension Double
{
    public mutating func getLong() -> Int64
    {
        return Int64(Darwin.ceil(sqrt(Double(self))))
    }
}

extension String
{
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension UIImage
{
    class func generateImageWithText(text: String,image:UIImage) -> UIImage
    {
        
        let imageView:UIImageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x:0, y:0, w:image.size.width, h:image.size.height)
        
        var label:UILabel = UILabel(frame: CGRect(x:0, y:0, w:imageView.frame.width * 2, h:imageView.frame.height ))
        
        switch(text.characters.count)
        {
        case 0:
            // huh, what impossible
            label = UILabel(frame: CGRect(x:0, y:0, w:imageView.frame.width, h:imageView.frame.height ))
            
            break
        case 1:
            label = UILabel(frame: CGRect(x:0, y:0, w:imageView.frame.width * 1.6, h:imageView.frame.height ))
            break
        case 2:
            label = UILabel(frame: CGRect(x:0, y:0, w:imageView.frame.width * 2, h:imageView.frame.height ))
            break
        case 3:
            label = UILabel(frame: CGRect(x:0, y:0, w:imageView.frame.width * 2.5, h:imageView.frame.height ))
            break
        default:
            label = UILabel(frame: CGRect(x:0, y:0, w:imageView.frame.width * 2, h:imageView.frame.height ))
            break
        }
        
        label.backgroundColor = UIColor.clear
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.text = text
        
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return imageWithText
    }
}



