//
//  Bool+Extension.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/2/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import Foundation

extension Bool {
    var toInt: Int {
        return NSNumber(booleanLiteral: self).intValue
    }
}
