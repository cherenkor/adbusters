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
    
    var imageIndex: Int?
    var deleteImageClb: ((Int) -> Void)?
    
    @IBAction func deleteAdImage(_ sender: Any) {
        deleteImageClb?(imageIndex!)
    }
}
