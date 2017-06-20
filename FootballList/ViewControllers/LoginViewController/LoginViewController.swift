//
//  LoginViewController.swift
//  FootballList
//
//  Created by user on 03.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import IQKeyboardManagerSwift

class LoginViewController: BaseViewController
{
    //MARK: - IBO
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emeilTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUpFaceBookLoginButton()
        self.setUpButtons()
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 70
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if AuthManager.shared.isLoginUser() == true
        {
            Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
        }
    }
    
    private func setUpFaceBookLoginButton()
    {
        self.loginButton.delegate = self
        self.loginButton.readPermissions = FB.LOGIN_PERMISSION_SCOPE
        self.logInButton.setCornerRadius(radius: 2)
    }
    
    private func setUpButtons()
    {
        self.continueButton.setCornerRadius(radius: 2)
        self.registrationButton.setCornerRadius(radius: 2)
    }
    
    //MARK: - IBActions
    @IBAction func logInButtonTapped(_ sender: Any)
    {
        if (self.emeilTextField.text?.isEmail)! == true && (self.passwordTextField.text?.length)! >= 4
        {
            AuthManager.shared.loginViaEmail(email: self.emeilTextField.text!, password: self.passwordTextField.text!, completion:
                { (error) in
                
                if error != nil
                {
                    AuthManager.shared.showAuthErrorAlert()
                }
            })
       
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any)
    {
        Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
    }
}

//MARK: - FBSDKLoginButtonDelegate

extension LoginViewController:  FBSDKLoginButtonDelegate
{

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        AuthManager.shared.logOut()
    }

    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil
        {
            print("FBLogin Error: ", error.localizedDescription)
            return
        }
        
        AuthManager.shared.loginViaFacebook { (error) in
            if error != nil
            {
                AuthManager.shared.showAuthErrorAlert()
            }
        }
    }
}
