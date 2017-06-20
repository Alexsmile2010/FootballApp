//
//  NewsFeedSwiperViewController.swift
//  FootballList
//
//  Created by user on 23.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import CarbonKit

class NewsFeedSwiperViewController: BaseViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let items = ["Новости", "Видео"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.setNormalColor(.white)
        carbonTabSwipeNavigation.setSelectedColor(.white)
        carbonTabSwipeNavigation.setIndicatorColor(.white)
        carbonTabSwipeNavigation.carbonTabSwipeScrollView.backgroundColor = COLORS.NAV_BAR_COLOR
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.w / 2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.w / 2, forSegmentAt: 1)
        if AuthManager.shared.isLoginUser() == true
        {
            AuthManager.shared.checkUserNameExistAndLaunch(completion: { (hasUserName) in
                
                if hasUserName == false
                {
                    Storyboard.showRootViewController(.UserNameViewController)
                }
            })
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any)
    {
        var userAction: UIAlertAction!
        
        if AuthManager.shared.isLoginUser() == true
        {
            userAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
                AuthManager.shared.logOut()
                Facebook.shared.logOut()
                Storyboard.showRootViewController(.LoginViewController)
            })
        }
        else
        {
            userAction = UIAlertAction(title: "Авторизация", style: .default, handler: { (_) in
                Storyboard.showRootViewController(.LoginViewController)
            })
        }
        
        let actionSheetViewController = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        actionSheetViewController.addAction(userAction)
        actionSheetViewController.addAction(cancelAction)
        
        self.presentVC(actionSheetViewController)
    }
}

//MARK: - CarbonTabSwipeNavigationDelegate

extension NewsFeedSwiperViewController: CarbonTabSwipeNavigationDelegate
{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController
    {
        switch index
        {
        case 0:
            
            let vc = Storyboard.viewControllerWithType(.NewsFeedViewController) as! NewsFeedViewController
            vc.makeClearPresentation()
            
            return vc
            
        case 1:
            
            let vc = Storyboard.viewControllerWithType(.VideoFeedViewController) as! VideoFeedViewController
            vc.makeClearPresentation()
            
            return vc
            
        default:
            return UIViewController()
        }
    }
}
