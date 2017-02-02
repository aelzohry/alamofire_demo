//
//  Config.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 1/31/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import Foundation


struct URLs {
    
//    static let main = "http://127.0.0.1:8000/api/v1/"
    static let main = "http://elzohrytech.com/alamofire_demo/api/v1/"
    
    /// POST {email, password}
    static let login = main + "login"
    
    /// POST {name, email, password, password_confirmation}
    static let register = main + "register"
    
    /// GET {api_token, page, per_page}
    static let tasks = main + "tasks"
    
    /// POST {api_token, task}
    static let new_task = main + "task/create"
    
    /// POST {api_token, task_id, task(optional), completed(optional)}
    static let edit_task = main + "task/edit"
    
    /// POST {api_token, task_id}
    static let delete_task = main + "task/delete"
    
}
