//
//  Reachability.swift
//  VARGapp
//
//  Created by Vladimir777 on 07.09.16.
//  Copyright © 2016 FacioMetrics LLC. All rights reserved.
//

import UIKit
import SystemConfiguration

class Reachability: NSObject
{
    class func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func showOfflineAlert()
    {
        let alertController = UIAlertController(title: "Error", message: "Connect internet connection", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true, completion: nil)
    }
}
