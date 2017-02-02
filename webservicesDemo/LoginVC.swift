//
//  ViewController.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 1/31/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty else { return }
        guard let password = passwordTF.text, !password.isEmpty else { return }
        
        API.login(email: email, password: password) { (error: Error?, success: Bool) in
            if success {
                // say welcome to user
            } else {
                // say sorry to user and try again
            }
        }
    }
}













