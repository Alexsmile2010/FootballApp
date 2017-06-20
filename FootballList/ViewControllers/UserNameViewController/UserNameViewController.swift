//
//  UserNameViewController.swift
//  FootballList
//
//  Created by Олексій on 01.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class UserNameViewController: BaseViewController
{
    
    @IBOutlet weak var userNameTextField:UITextField?
    @IBOutlet weak var warningLabel:UILabel?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.userNameTextField?.becomeFirstResponder()
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
  
    fileprivate func showWarning(text: String)
    {
        self.warningLabel?.text = text
        self.warningLabel?.isHidden = false
    }
    
    fileprivate func writeUserNameAndLaunch()
    {
        let username = self.userNameTextField?.text
        AuthManager.shared.saveUser(username: username!)
        Storyboard.showRootViewController(.NewsFeedSwiperNavigationViewController)
    }
    
    @IBAction func nextTaped()
    {
        let username = self.userNameTextField?.text
        
        if username?.isEmpty == true
        {
            let alert = UIAlertController(title: "Ой! Что-то не так!", message: "Так нельзя! Мы хотим чтобы вы были личностью в нашем приложении", preferredStyle: .alert)
            let action = UIAlertAction(title: "Попробовать снова", style: .default, handler: nil)
            alert.addAction(action)
            self.presentVC(alert)
        }
        else
        {
            AuthManager.shared.checkUserNameDuplicate(username: username!) { (exist) in
                
                if exist == true
                {
                    self.writeUserNameAndLaunch()
                }
                else
                {
                    self.showWarning(text: STRINGS.WARNINGS.NAME_EXIST)
                }
            }
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: AnyObject)
    {
        self.nextTaped()
    }
    
    @IBAction func textFieldDidChanged()
    {
        self.warningLabel?.isHidden = true
        
        if((self.userNameTextField?.text?.length)! > 4)
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    } 
}

//MARK: UITextFieldDelegate

extension UserNameViewController: UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if((self.userNameTextField?.text?.length)! > 4)
        {
            self.nextTaped()
        }
        else
        {
            self.showWarning(text: STRINGS.WARNINGS.NAME_TOO_SHORT)
        }
        
        return true
    }
}

