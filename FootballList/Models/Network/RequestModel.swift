//
//  RequestModel.swift
//  VARGapp
//
//  Created by VARG on 06.07.16.
//  Copyright © 2016 FacioMetrics LLC. All rights reserved.
//

import Foundation
import Alamofire


public enum REQUEST_METHOD: String
{
    case get, post
}


open class RequestModel
{
    //This is main url for request. It can be changed anywere at all sublass
    var mainURL =  "" {
        didSet {
            assert(!mainURL.contains("Optional"), "FOUND OPTIONAL in mainURL \(type(of: self)) ")
        }
    }
    
    var bodyData: [String : String] = [String : String]()
    
    var requestMethod: REQUEST_METHOD?
    
    //Bool instance for setting showing progress when request is run
    var showProgress: Bool = true
    
    //Base Init class
    init() {}
    
    //Overrife func for generete body for request
    open func finalizeParams(){}
}

open class VideoRequestModel : RequestModel
{
    fileprivate var limit:Int!
    var offset:Int!
    //Base Init class
    override init()
    {
        super.init()
    }
    
    convenience init(offset: Int, limit: Int)
    {
        self.init()
        self.requestMethod = REQUEST_METHOD.get
        self.limit = limit
        self.offset = offset
    }
    
    //Overrife func for generete body for request
    override open func finalizeParams()
    {
        self.mainURL = VIDME_API.VIDEOS + VIDME_API.OFFSET + "\(self.offset!)" + VIDME_API.LIMIT + "\(self.limit!)"
    }
}


