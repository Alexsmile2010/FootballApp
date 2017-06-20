//
//  Facebook.swift
//  FootballList
//
//  Created by Олексій on 16.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import FBSDKLoginKit

typealias FacebookUserIDCompletion = () -> Swift.Void

class Facebook
{
    static let shared : Facebook = {
        let instance = Facebook()
        return instance
    }()
    
    fileprivate var user: User?

    open func getFBUserId(completion: @escaping FacebookUserIDCompletion)
    {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, picture.type(large)"]).start {
            (connection, result, error) in
            
            if error != nil
            {
                print("Failed to start Graph request: \(String(describing: error?.localizedDescription))")
                return
            }
            else
            {   let userData = result as! Dict
                let userId:String = userData["id"]! as! String
                let user = RealmManager.shared.getUser()
                RealmManager.shared.update
                {
                    user?.facebookID = userId
                }
            }
        }
    }
    
    open func getUser() -> User
    {
        return self.user!
    }
    
    open func isLoginUser() -> Bool
    {
        if (FBSDKAccessToken.current() != nil)
        {
            return true
        }
        
        return false
    }
    
    open func logOut()
    {
        FBSDKLoginManager().logOut()
    }
}
