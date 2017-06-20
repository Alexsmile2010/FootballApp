//
//  ProfileViewController.swift
//  FootballList
//
//  Created by user on 25.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController
{
    //MARL: - IBO
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var appVersionAndBuildLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var offerPostButton: UIButton!
    @IBOutlet weak var mainContainerView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setUpSideMenuGesture()
        self.createGradientLayer()
        
        self.offerPostButton.setCornerRadius(radius: 5)
        self.logOutButton.setCornerRadius(radius: 5)
        self.mainContainerView.setCornerRadius(radius: 5)
        self.setUpUserName()
        self.setUpAppVersionAndBuild()
    }
    
    fileprivate func setUpUserName()
    {
        let userId = Firebase.shared.getUserUID()
        Firebase.shared.getUserNameByIdRef(userId: userId).observeSingleEvent(of: .value, with: {
            snapshot in
            guard let value: Dict = snapshot.value as? Dict else {return}
            let username = value["username"] as! String
            self.userNameLabel.text = self.userNameLabel.text! + username
            })
    }
    
    fileprivate func setUpAppVersionAndBuild()
    {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "0"
        self.appVersionAndBuildLabel.text = "Версия продукта: \(appVersion) (\(appBuild))"
    }
    
    
    @IBAction func menuButtonTapped(_ sender: Any)
    {
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func offerNewsButtonTapped(_ sender: Any)
    {
        
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any)
    {
        
    }
}
