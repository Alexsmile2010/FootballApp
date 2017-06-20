//
//  SinglePostSwipeViewController.swift
//  FootballList
//
//  Created by user on 26.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import CarbonKit


class SinglePostSwipeViewController: BaseViewController
{
    
    
    //MARK: - VAR
    var postKey: String!
    fileprivate var commentsCount:String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.getCommentsCountAndSetupSwipe()
        
    }
    
    fileprivate func getCommentsCountAndSetupSwipe()
    {
        Utilities.showHUD()
        Firebase.shared.getPostCommentsRef(key: self.postKey).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            
            guard let value: Dict = snapshot.value as? Dict else
            {
                self?.setupCarbonSwipe()
                Utilities.hideHUD()
                return
            }
            
            self?.commentsCount = "\(value.keys.count)"
            self?.setupCarbonSwipe()
            Utilities.hideHUD()
            
        })
    }
    
    fileprivate func setupCarbonSwipe()
    {
        let commentImage:UIImage = UIImage.generateImageWithText(text: self.commentsCount, image: UIImage(named: IMAGES.COMMENTS)!)
        let items:[Any] = [UIImage.init(named: IMAGES.NEWS)!, commentImage]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.setNormalColor(.white)
        carbonTabSwipeNavigation.setSelectedColor(.white)
        carbonTabSwipeNavigation.setIndicatorColor(.white)
        carbonTabSwipeNavigation.carbonTabSwipeScrollView.backgroundColor = COLORS.NAV_BAR_COLOR
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.w / 2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.w / 2, forSegmentAt: 1)
    }
}

//MARK: - CarbonTabSwipeNavigationDelegate

extension SinglePostSwipeViewController: CarbonTabSwipeNavigationDelegate
{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController
    {
        switch index
        {
        case 0:
            
            let vc = Storyboard.viewControllerWithType(.SinglePostViewController) as! SinglePostViewController
            vc.postKey = self.postKey
            vc.makeClearPresentation()
            
            return vc
            
        case 1:
            
            let vc = Storyboard.viewControllerWithType(.CommentsViewController) as! CommentsViewController
            vc.postKey = self.postKey
            vc.makeClearPresentation()
            
            return vc

        default:
            return UIViewController()
        }
    }
}
