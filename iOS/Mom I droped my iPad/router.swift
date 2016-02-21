//
//  router.swift
//  Mom I droped my iPad
//
//  Created by Victor Gallego Betorz on 21/2/16.
//  Copyright © 2016 Victor Gallego Betorz. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://ec2-52-25-180-175.us-west-2.compute.amazonaws.com"
    static var OAuthToken: String? = ""

    // Game
    case Game([String: AnyObject])

    // Top
    case Top()

    var method: Alamofire.Method
    {
        switch self
        {
            // Game
            case .Game:
                return .POST
            
            // Top
            case .Top:
                return .GET
        }
    }
    
    var path: String
    {
        switch self
        {
            // Game
            case .Game:
                return "/game"
            
            // Top
            case .Top:
                return "/top"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
//        if let token = Router.OAuthToken {
//            mutableURLRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
//        }
        print(mutableURLRequest)
        switch self
        {
            // Game
        case .Game(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0

            // Default
        default:
            return mutableURLRequest
        }
    }
}