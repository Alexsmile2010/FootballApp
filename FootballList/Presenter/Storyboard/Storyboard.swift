//
//  Storyboard.swift
//  Drool
//
//  Created by user on 15.11.16.
//  Copyright © 2016 Lucerotech LLC. All rights reserved.
//

import Foundation
import UIKit

enum StoryboardType: String
{
    case Auth
    case Main
    case SinglePost
    case Profile
}

enum ViewControlledType: String
{
    case LoginViewController
    case SWRevealViewController
    case VideoFeedViewController
    case NewsFeedViewController
    case ProfileViewController
    case SinglePostViewController
    case SinglePostSwipeViewController
    case CommentsViewController
    case WriteCommentViewController
    case UserNameViewController
    case NewsFeedSwiperViewController
    case NewsFeedSwiperNavigationViewController
}

class Storyboard
{
    class func viewControllerWithType(_ type: ViewControlledType) -> UIViewController
    {
        let name = self.storyboardNameForControllerType(type)
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
        let storyboardId = type.rawValue
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
        return viewController
    }
    
    class func showRootViewController(_ type: ViewControlledType)
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let newRootViewController = self.viewControllerWithType(type)
        appDelegate?.window?.rootViewController = newRootViewController
    }
    
    class func presentViewController(_ viewController: UIViewController)
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController?.presentVC(viewController)
    }
    
    class func getRootViewController() -> UIViewController
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return (appDelegate?.window?.rootViewController)!
    }
    
    //MARL: - Private
    
    fileprivate class func storyboardNameForControllerType(_ type: ViewControlledType) -> StoryboardType
    {
        switch type
        {
        case .SinglePostSwipeViewController: return .SinglePost
        case .SinglePostViewController: return .SinglePost
        case .CommentsViewController: return .SinglePost
        case .WriteCommentViewController: return .SinglePost
        case .ProfileViewController: return .Profile
        case .LoginViewController: return .Auth
        case .UserNameViewController: return .Auth
            
        default:
            return .Main
        }
    }
}
