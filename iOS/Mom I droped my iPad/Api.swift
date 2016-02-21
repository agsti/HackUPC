//
//  Top.swift
//  Mom I droped my iPad
//
//  Created by Victor Gallego Betorz on 21/2/16.
//  Copyright © 2016 Victor Gallego Betorz. All rights reserved.
//


import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class Api {
    
    // Methods
    static func top()
    {
        Alamofire.request(Router.Top())
            .responseJSON { response in
                print(response.result.value)
                if (response.result.value != nil)
                {
                    let swiftyJson = JSON(response.result.value!)
                    print(swiftyJson)
                }
                else
                {
                    print("ERROR Json is nil")
                }
        }
    }
    
    static func game(params: [String:String])
    {
        Alamofire.request(Router.Game(params))
            .responseJSON { response in
                print(response.result.value)
        }
    }
}