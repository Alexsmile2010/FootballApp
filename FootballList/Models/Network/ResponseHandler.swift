//
//  ResponseHandler.swift
//  Cravepal
//
//  Created by Alexey Zayakin on 26.04.16.
//  Copyright © 2016 Alexey Zayakin. All rights reserved.
//

enum ResponseError: Error
{
    case keyNotFond(String)
    case errorMessage(String)
    case fatalError
    
}

public enum ResponceErrorType
{
    case errorTypeNone
    case errorTypeMessage(String)
    case errorTypeInvalidAccessToken
    case errorTypeInvalidUser
}

import Foundation
import JSONJoy

open class ResponseHandler
{
    fileprivate(set) fileprivate var json: JSONDecoder!
    
    open var success : Bool = false
    open var response: Any?
    open var error: Error?
    open var statusCode: Int! = 0
    open var model: RequestModel!
    open var completionBlock:((_ response: ResponseHandler, _ error: Error?) -> Void)?
    
    open func decodeRequest()
    {
        do{
           try self.validateResponse()
        }
        catch ResponseError.fatalError
        {
            if self.completionBlock != nil
            {
                self.completionBlock!(self, ResponseError.fatalError)
            }
        }
        catch ResponseError.keyNotFond(let message)
        {
            if self.completionBlock != nil
            {
                self.completionBlock!(self, ResponseError.keyNotFond(message))
            }
        }
        catch ResponseError.errorMessage(let message)
        {
            if self.completionBlock != nil
            {
                self.completionBlock!(self, ResponseError.errorMessage(message))
            }
        }
        catch
        {
            print("Unknow Error")
        }
    }
    
    fileprivate func parseJSON(_ json: JSONDecoder) throws {}
}

//MARK: - Private

fileprivate extension ResponseHandler
{
    ///Func check response json and return type of action
    fileprivate func validateResponse() throws
    {
        switch self.statusCode
        {
        case 200...300:
            
            self.json = JSONDecoder(self.response!)
            
            do{
                try self.parseJSON(self.json)
                
                if self.completionBlock != nil
                {
                    self.completionBlock!(self, nil)
                }
            }
            catch ResponseError.keyNotFond(let message)
            {
                throw ResponseError.keyNotFond(message)
            }
            catch ResponseError.errorMessage(let message)
            {
                throw ResponseError.errorMessage(message)
            }
            catch
            {
                throw ResponseError.fatalError
            }
            
            break;
            
        case 400...404:
            
            self.json = JSONDecoder(self.response!)
            
            guard let message:String = try json["message"].get() , message.characters.count != 0 else
            {
                throw ResponseError.fatalError
            }
            
            throw ResponseError.errorMessage(message)
            
        case 500:
            
            throw ResponseError.fatalError
            
        default:
            
            throw ResponseError.fatalError
        }
    }
}

open class GetVideoHandler: ResponseHandler
{
    var videos:[VidmeVideoPost] = []
    
    public override init()
    {
        super.init()
    }
    
    open override func parseJSON(_ json: JSONDecoder) throws
    {
        do{
            let videosLimit:Int = try json["page"]["limit"].get()
            let videosTotal:Int = try json["page"]["total"].get()
            let videosCount = min(videosLimit, videosTotal)
            let offset = (self.model as! VideoRequestModel).offset
            if videosCount > 0 && offset! <= videosTotal
            {
                for i in 0..<videosCount
                {
                    let video = try VidmeVideoPost(json, i)
                    self.videos.append(video)
                }
            }
        }
        catch JSONError.wrongType
        {
            throw ResponseError.errorMessage("\(self): key STATUS contains FALSE")
        }
        catch
        {
            throw ResponseError.fatalError
        }
    }
}


