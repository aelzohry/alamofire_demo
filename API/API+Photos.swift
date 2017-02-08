//
//  API+Photos.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/8/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


extension API {
    
    class func createPhoto(photo: UIImage, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        guard let api_token = helper.getApiToken() else {
            completion(nil, false)
            return
        }
        
        let url = URLs.create_photo+"?api_token=\(api_token)"

        Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
            
            if let data = UIImageJPEGRepresentation(photo, 0.5) {
                form.append(data, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil) { (result: SessionManager.MultipartFormDataEncodingResult) in
            
            switch result {
            case .failure(let error):
                print(error)
                completion(error, false)
                
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                
                upload.uploadProgress(closure: { (progress: Progress) in
                    print(progress)
                })
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    
                    switch response.result
                    {
                    case .failure(let error):
                        print(error)
                        completion(error, false)
                        
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        
                        if let status = json["status"].toInt, status == 1 {
                            // success
                            print("Upload Succeed")
                            completion(nil, true)
                        } else {
                            print("Upload Failed")
                            completion(nil, false)
                        }
                    }
                    
                })
            }
            
        }
        
    }
    
}






