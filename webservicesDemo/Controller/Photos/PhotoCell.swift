//
//  PhotoCell.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/5/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit
import Alamofire
// AlamofireImage
// Kingfisher


class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var iv: UIImageView!
    
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }

            self.iv.image = #imageLiteral(resourceName: "placehoder.jpg")
            
            // download image
            Alamofire.request(photo.url).response { response in
                if let data = response.data, let image = UIImage(data: data) {
                    self.iv.image = image
                }
            }
        }
    }
    
}
