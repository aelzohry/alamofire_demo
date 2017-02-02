//
//  API.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 1/31/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class API: NSObject {

    class func login(email: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let url = URLs.login
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                    
                case .success(let value):
                    let json = JSON(value)
                    
                    if let api_token = json["user"]["api_token"].string {
                        print("api_token: \(api_token)")
                        
                        // save api token to UserDefaults
                        helper.saveApiToken(token: api_token)
                        
                        completion(nil, true)
                    }
                }
                
        }
    }
    
    class func register(name: String, email: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let url = URLs.register
        
        let parameters = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                    
                case .success(let value):
                    let json = JSON(value)
                    
                    if let api_token = json["user"]["api_token"].string {
                        print("api_token: \(api_token)")
                        
                        // save api token to UserDefaults
                        helper.saveApiToken(token: api_token)
                        
                        completion(nil, true)
                    }
                }
                
        }
    }
    
    
}
