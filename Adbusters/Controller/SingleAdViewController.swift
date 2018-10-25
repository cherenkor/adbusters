//
//  SingleAdViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/25/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class SingleAdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var currentPartyLbl: UILabel!
    
    @IBOutlet weak var currentTypeLbl: UILabel!
    
    @IBOutlet weak var currentDateLbl: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPartyLbl.text = currentParty
        currentTypeLbl.text = currentType
        currentDateLbl.text = currentDate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAdsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleAdCollectionViewCell
        cell.imageView.image = currentAdsImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentAdImage = currentAdsImages[indexPath.row]
        performSegue(withIdentifier: "goToSingleAdImage", sender: nil)
    }
}
