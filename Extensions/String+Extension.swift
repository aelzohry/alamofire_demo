//
//  String+Extension.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 1/31/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import Foundation


extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
