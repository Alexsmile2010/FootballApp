//
//  AuthManager.swift
//  FootballList
//
//  Created by Олексій on 24.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit


typealias CheckUserNameCompletion = (_ exist:Bool) -> Swift.Void
typealias LoginEmailCompletion = (_ error:Error?) -> Swift.Void
typealias LoginFacebookCompletion = (_ error:Error?) -> Swift.Void
typealias GetUsernameCompletion = (_ hasUserName: Bool) -> Swift.Void

class AuthManager
{
    static let shared : AuthManager = {
        let instance = AuthManager()
        return instance
    }()
    
    open func saveUser(username:String)
    {
        let userID = Firebase.shared.getUserUID()
        
        let usernameDict = [FRBKEYS.USERNAME: username] as [String : Any]
        let childUpdates = ["/usernames/\(userID)": usernameDict]
        
        let user = RealmManager.shared.getUser()
        
        RealmManager.shared.update {
            user?.username = username
        }
        
        Firebase.shared.mainRef.updateChildValues(childUpdates)
    }
    
    open func checkUserNameDuplicate(username: String, completion: @escaping CheckUserNameCompletion)
    {
        let usernamesRef = Firebase.shared.getUserNamesRef()
        usernamesRef.queryOrdered(byChild: FRBKEYS.USERNAME).queryEqual(toValue: username)
            .observe(.value, with: { snapshot in
                completion(snapshot.value is NSNull)
            })
    }
    
    func checkUserNameExistAndLaunch(completion: @escaping GetUsernameCompletion)
    {
        
        let userID = Firebase.shared.getUserUID()
        let usernamesRef = Firebase.shared.getUserNamesRef()
        usernamesRef.child(userID).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            
            if snapshot.hasChild(FRBKEYS.USERNAME) == true
            {
                let user = User()
                user.id = userID
                user.username = (snapshot.value as! Dict)[FRBKEYS.USERNAME] as! String
                RealmManager.shared.saveUser(user: user)
                
                completion(true)
            }
            else
            {
                completion(false)
            }
        })
    }
    
    open func checkUserLogedInAndLaunch()
    {
        if AuthManager.shared.isLoginUser() == true  //&& RealmManager.shared.getUser()?.username.length != 0
        {
            //Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
            self.checkUserNameExistAndLaunch(completion: { (hasUsername) in
                
                if hasUsername == true
                {
                    Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
                }
                else
                {
                    Storyboard.showRootViewController(.UserNameViewController)
                }
            })
        }
        else if AuthManager.shared.isLoginUser() != true || Facebook.shared.isLoginUser() != true
        {
            AuthManager.shared.logOut()
            Facebook.shared.logOut()
        }
        else if RealmManager.shared.getUser()?.username.length == 0
        {
            Storyboard.showRootViewController(.UserNameViewController)
        }
        else
        {
            Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
        }
    }
    
    //MARK: - AUTH
    
    open func loginViaFacebook(completion: @escaping LoginFacebookCompletion)
    {
        Utilities.showHUD()
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: {
            (firebaseUser, error) in
            
            Utilities.hideHUD()
            
            if error != nil
            {
                print("FirevaseAuth error: ", error ?? "")
                completion(error)
            }
            else
            {
                self.checkUserNameExistAndLaunch(completion: { (hasUsername) in
                    
                    if hasUsername == true
                    {
                        Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
                    }
                    else
                    {
                        Storyboard.showRootViewController(.UserNameViewController)
                    }
                })
            }
        })
    }

    
    open func loginViaEmail(email:String, password:String, completion: @escaping LoginEmailCompletion)
    {
        Utilities.showHUD()
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (firebaseUser, error) in
            
            Utilities.hideHUD()
            
            if error == nil
            {
                self.checkUserNameExistAndLaunch(completion: { (hasUsername) in
                    
                    if hasUsername == true
                    {
                        Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
                    }
                    else
                    {
                        Storyboard.showRootViewController(.UserNameViewController)
                    }
                })
            }
            else
            {
                completion(error)
                print("Erorr: ", error?.localizedDescription as Any)
            }
        }
    }
    
    open func registerUserViaEmail(email: String, password: String, completion: @escaping EmeilLoginCompletionBlock)
    {
        Utilities.showHUD()
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            Utilities.hideHUD()
            
            if error == nil
            {
                completion()
            }
        }
    }
    
    open func logOut()
    {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    open func isLoginUser() -> Bool
    {
        guard (FIRAuth.auth()?.currentUser) != nil else
        {
            return false
        }
        
        return true
    }
    
    open func showNonAuthAlert()
    {
        let alert = UIAlertController(title: STRINGS.TITLES.ATTENTION, message: STRINGS.WARNINGS.NON_AUTH_MESSAGE, preferredStyle: .alert)
        let authAction = UIAlertAction(title: STRINGS.TITLES.AUTH, style: .default, handler: { (_) in
            Storyboard.showRootViewController(.LoginViewController)
        })
        let cancelAction = UIAlertAction(title: STRINGS.TITLES.CANCEL_BUTTON, style: .destructive, handler: nil)
        alert.addAction(authAction)
        alert.addAction(cancelAction)
        Storyboard.getRootViewController().presentVC(alert)
    }
    
    open func showAuthErrorAlert()
    {
        let alert = UIAlertController(title: STRINGS.TITLES.ATTENTION, message: STRINGS.WARNINGS.AUTH_ERROR, preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(alerAction)
        Storyboard.getRootViewController().presentVC(alert)
    }
    
    open func showRegistrSuccessAlert()
    {
        let alert = UIAlertController(title: STRINGS.TITLES.REGISTR_SUCCESS, message: STRINGS.MESSAGES.USER_REGISTRED, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            Storyboard.showRootViewController(.UserNameViewController)
        })
        Utilities.hideHUD()
        alert.addAction(okAction)
        Storyboard.getRootViewController().presentVC(alert)
    }
    
    open func showRegistrFailedAlert()
    {
        let alert = UIAlertController(title: STRINGS.TITLES.ERROR, message: STRINGS.WARNINGS.WRONG_INPUT_DATA, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        Utilities.hideHUD()
        Storyboard.getRootViewController().presentVC(alert)
    }

}
