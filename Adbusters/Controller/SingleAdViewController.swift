//
//  SingleAdViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/25/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit
import Kingfisher

class SingleAdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var currentPartyLbl: UILabel!
    
    @IBOutlet weak var currentTypeLbl: UILabel!
    
    @IBOutlet weak var currentDateLbl: UILabel!
    
    @IBOutlet var currentCommentLbl: UITextView!
    
    @IBOutlet var currentPoliticianLbl: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isAddAdsView {
            currentAdsImages = [UIImage]()
        }
        
        currentPartyLbl.text = currentParty
        currentPoliticianLbl.text = currentPolitician
        currentTypeLbl.text = currentType
        currentCommentLbl.text = currentComment
        currentDateLbl.text = convertDate(dateStr: currentDate ?? "")
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! SingleAdCollectionViewCell
        
        currentAdImage = currentCell.imageView.image
        performSegue(withIdentifier: "goToSingleAdImage", sender: nil)
    }
}
