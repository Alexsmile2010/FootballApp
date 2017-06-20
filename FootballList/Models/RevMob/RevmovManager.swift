//
//  RevmovManager.swift
//  FootballList
//
//  Created by user on 04.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation

typealias bannerDidLoad = (_ banner: RevMobBannerView?) -> Swift.Void

class RevmobManager: NSObject
{
    static let shared : RevmobManager = {
        let instance = RevmobManager()
        return instance
    }()
    
    fileprivate let REVMOB_ID = "59086c07b558e81e6e2b3476";
    var isSesstionStart: Bool! = false
    
    open func startSession()
    {
        RevMobAds.startSession(withAppID: REVMOB_ID, andDelegate: self)
        let session = RevMobAds.startSession(withAppID: REVMOB_ID, andDelegate: self)//RevMobAds.session()
        
        session?.userAgeRangeMin = UInt(45)
        session?.userAgeRangeMax = 45
        session?.userAgeRangeMin = 18
        session?.userGender = RevMobUserGenderMale
        let user = RealmManager.shared.getUser()
        if Facebook.shared.isLoginUser() == true && user?.facebookID == ""
        {
            Facebook.shared.getFBUserId
                {
                    let user:User = RealmManager.shared.getUser()!
                    session?.userPage = FB.URL+"\(user.facebookID)"
                }
        }
        else if user?.facebookID != ""
        {
            session?.userPage = FB.URL+"\(user?.facebookID ?? "")"
        }
        
        
    }
    
    open func loadBanner(compleate: @escaping bannerDidLoad)
    {
        if self.isSesstionStart == true
        {
            let banner = RevMobAds.session().bannerView()
            let completionBlock: (RevMobBannerView!) -> Void = { bannerV in
                
                banner?.frame = CGRect(x: 0, y: 0, w: 320, h: 50)
                banner?.autoresizingMask = [.flexibleTopMargin, .flexibleWidth] //Optional Parameters to handle Rotation Events
                
                compleate(banner)
            }
            banner?.load(successHandler: completionBlock, andLoadFailHandler: nil, onClickHandler: nil)
        }
    }
}

//MARK: - RevMobAdsDelegate

extension RevmobManager: RevMobAdsDelegate
{
    func revmobSessionDidStart()
    {
        self.isSesstionStart = true
    }
    
    func revmobSessionDidNotStartWithError(_ error: Error!)
    {
        print("RevMobSession Failed to Start")
    }
}
