//
//  PhotosVC.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/5/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit

class PhotosVC: UIViewController {

    fileprivate let cellIdentifier = "PhotoCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        return button
    }()
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = Array.init(repeating: #imageLiteral(resourceName: "placehoder.jpg"), count: 5)
        
        navigationItem.rightBarButtonItem = addButton
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    var picker_image: UIImage? {
        didSet {
            // execute some code
            guard let image = picker_image else { return }
            
            // add temorarily to array of images
            self.images.append(image)
            self.collectionView.reloadData()
            
            // send to server
            API.createPhoto(photo: image) { (error: Error?, success: Bool) in
                if success {
                    // update collection view
                    
                }
            }
        }
    }

    @objc private func handleAdd() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
}

extension PhotosVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.picker_image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.picker_image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension PhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        cell.iv.image = images[indexPath.row]
        
        return cell
    }
    
}


extension PhotosVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        var width = (screenWidth-30)/2
        
        width = width > 200 ? 200 : width
        
        return CGSize.init(width: width, height: width)
    }
    
}











