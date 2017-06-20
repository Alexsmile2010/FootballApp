//
//  ShareManager.swift
//  FootballList
//
//  Created by user on 01.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import Nuke

class ShareManager
{
    
    class func showShareViewController(post: Post)
    {
        let appUrl = URL(string: APP.URL)
        var items: Array<Any> = Array<Any>()
        let request = Request(url: post.imgUrl)
        
        if let image = Cache.shared[request]
        {
            items = [post.title, image, appUrl!]
        }
        else
        {
            items = [post.title, post.imgUrl, appUrl!]
        }
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (type, finished, items, error) in
            Storyboard.getRootViewController().popVC()
        }
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            controller.popoverPresentationController?.sourceView = Storyboard.getRootViewController().view
        }
        
        Storyboard.presentViewController(controller)
    }
    
    class func showShareViewController(videoPost: VidmeVideoPost)
    {
        let appUrl = URL(string: APP.URL)
        var items: Array<Any> = Array<Any>()
        items = [videoPost.title, videoPost.thumbnailUrl, appUrl!]
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (type, finished, items, error) in
            Storyboard.getRootViewController().popVC()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            controller.popoverPresentationController?.sourceView = Storyboard.getRootViewController().view
        }
        Storyboard.presentViewController(controller)
    }

}
