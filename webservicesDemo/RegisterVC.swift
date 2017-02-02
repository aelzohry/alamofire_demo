//
//  RegisterVC.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 1/31/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordAgainTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func registerPressed(_ sender: UIButton) {
        guard let name = nameTF.text?.trimmed, !name.isEmpty, let email = emailTF.text?.trimmed, !email.isEmpty, let password = passwordTF.text, !password.isEmpty, let passwordAgain = passwordAgainTF.text, !passwordAgain.isEmpty else { return }
        
        guard password == passwordAgain else { return }
        
        
        API.register(name: name, email: email, password: password) { (error: Error?, success: Bool) in
            if success {
                print("Reigster succeed !! welcome to our small app :)")
            }
        }
    }
    
}








