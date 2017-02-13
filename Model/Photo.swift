//
//  Photo.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/13/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 {
     "id": 12,
     "user_id": "1",
     "photo": "uploads\/photos\/148652543229083.jpg",
     "created_at": "2017-02-08 03:43:52",
     "updated_at": "2017-02-08 03:43:52"
 }
 */
class Photo: NSObject {
    var id: Int
    var url: String
    
    init?(dict: [String: JSON]) {
        guard let id = dict["id"]?.toInt, let photo = dict["photo"]?.toImagePath, !photo.isEmpty else { return nil }
        
        self.id = id
        self.url = photo
    }
}
