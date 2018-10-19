//
//  AddAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/18/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class AddAdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAd(_ sender: Any) {
    }
    
    // Adding image
    @IBAction func addAdImage(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.allowsEditing = true

        let actionSheet = UIAlertController(title: "Спосіб завантаження", message: "Виберіть спосіб завантаження", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (UIAlertAction) in
            imageController.sourceType = .camera
        }))

        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (UIAlertAction) in
            imageController.sourceType = .photoLibrary
            self.present(imageController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Відмінити", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        images.append(image)
        collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddAdImageViewCollectionViewCell
        cell.adImageView.image = images[indexPath.row]
        
        return cell
    }
}
