//
//  AddAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/18/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class AddAdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let images = [UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo"), UIImage(named: "logo")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAd(_ sender: Any) {
    }
    
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
