//
//  Utilities.swift
//  FootballList
//
//  Created by Олексій on 25.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import MBProgressHUD
import Async

class Utilities {
    static let shared = Utilities()
    
    private init() {}
    
    // MARK: - variables
    
    lazy var rootWindow = UIApplication.shared.windows.last
    var hud = MBProgressHUD()
    {
        didSet
        {
            hud.backgroundView.style = .solidColor
            hud.backgroundView.color = UIColor(white: 0, alpha: 0.1)
        }
    }
    
    // MARK: - HUDs
    
    class func showHUD()
    {
        Async.main {
            
            if let app = UIApplication.shared.delegate , let window = app.window
            {
                MBProgressHUD.showAdded(to: window!, animated: true)
            }
        }
    }
    
    class func hideHUD()
    {
        Async.main {
            if let app = UIApplication.shared.delegate, let window = app.window
            {
                MBProgressHUD.hide(for: window!, animated: true)
            }
        }
    }
    
    func showHUDWithProgress(message: String, progress: Float)
    {
        Async.main {
            self.hud.hide(animated: true)
            
            self.hud = MBProgressHUD.showAdded(to: self.rootWindow!, animated: true)
            self.hud.mode = .determinateHorizontalBar
            self.hud.label.text = message
            
            guard progress < 1.0 else
            {
                self.hud.hide(animated: true)
                return
            }
            
            self.hud.progress = progress
        }
    }
    
}
