//
//  JSON+Extension.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/2/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import Foundation
import SwiftyJSON


extension JSON {
    
    var toBool: Bool? {
        if let bool = self.bool { return bool }
        if let int = self.toInt {
            if int == 0 {
                return false
            } else if int == 1 {
                return true
            }
        }
        
        return nil
    }
    
    var toInt: Int? {
        if let int = self.int { return int }
        if let string = self.string, let int = Int(string) {
            return int
        }
        
        return nil
    }
    
    var toImagePath: String? {
        guard let string = self.string, !string.isEmpty else { return nil }
        
        return URLs.file_root + string
    }
    
}












