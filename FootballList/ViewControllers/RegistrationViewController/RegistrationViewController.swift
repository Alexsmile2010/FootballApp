//
//  RegistrationViewController.swift
//  FootballList
//
//  Created by user on 23.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RegistrationViewController: BaseViewController
{
    @IBOutlet weak var emeilTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registrationButton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 70
    }
    
    @IBAction func registrationButtonTapped(_ sender: Any)
    {
        if self.emeilTextField.text?.isEmail == true && (self.passwordTextField.text == self.confirmPasswordTextField.text)
        {
           AuthManager.shared.registerUserViaEmail(email: self.emeilTextField.text!, password: self.passwordTextField.text!, completion: { _ in
            
            Storyboard.showRootViewController(.UserNameViewController)
            
           })
        }
        else
        {
            AuthManager.shared.showRegistrFailedAlert()
        }
    }
}
