//
//  AppDelegate.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 1/31/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let api_token = helper.getApiToken() {
            print("api_token: \(api_token)")
            // skip auth screens
            // and go to main screen
            
            let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
            window?.rootViewController = tab
        }

        return true
    }


}

