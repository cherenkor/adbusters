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
        
        if !isAddAdsView {
            currentAdsImages = [UIImage]()
        }
        
        currentPartyLbl.text = currentParty
        currentTypeLbl.text = currentType
        currentDateLbl.text = currentDate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isAddAdsView {
            return currentAdsImages.count
        } else {
            return currentAdsImageUrls!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SingleAdCollectionViewCell
        if isAddAdsView {
            cell.imageView.image = currentAdsImages[indexPath.row]
            return cell
        }
        
        let urlString = currentAdsImageUrls![indexPath.row].image!
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    print("\nerror on download \(error ?? "" as! Error)")
                    return
                }
                DispatchQueue.main.async(execute: {
                    let currentImage = UIImage(data: data)!
                    cell.imageView.image = currentImage
                    currentAdsImages.append(currentImage)
                    self.collectionView.reloadData()
                })
            }).resume()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentAdsImages.count == 0 { return }
        currentAdImage = currentAdsImages[indexPath.row]
        performSegue(withIdentifier: "goToSingleAdImage", sender: nil)
    }
}
