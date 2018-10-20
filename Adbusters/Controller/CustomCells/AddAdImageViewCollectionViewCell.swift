//
//  AddAdImageViewCollectionViewCell.swift
//  Adbusters
//
//  Created by MacBookAir on 10/19/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class AddAdImageViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet weak var deleteImageButton: UIButton!
    
//    @IBAction func deleteAdImage(_ sender: Any) {
//        let i : Int = (sender.layer.valueForKey("index")) as! Int
//        addingImages.removeAtIndex(i)
//        collectionView.reloadData()
//    }
}
