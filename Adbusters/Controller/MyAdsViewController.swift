//
//  MyAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/17/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class MyAdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageUrlString: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
        // Do any additional setup after loading the view.
        
        loadAds()
    }
    
    func loadAds() {
        getAds(url: "http://adbusters.chesno.org/ads/") { (json, error) in
            
            if let error = error {
                print("ERROR WAR", error)
                return
            }
            
            ads = json!
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAdsViewTableViewCell
        cell.title.text = ads?[indexPath.row].party?.name
        cell.type.text = "\(ads![indexPath.row].type!)"
        cell.date.text = convertDate(dateStr: ads![indexPath.row].created_date!)
        let images = ads![indexPath.row].images!
        
        if (images.count > 0) {
            let urlString = images[0].image!
            imageUrlString = urlString
            
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                cell.adImageView.image = imageFromCache
            } else {
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                        guard let data = data, error == nil else {
                            print("\nerror on download \(error ?? "" as! Error)")
                            return
                        }
                        DispatchQueue.main.async(execute: {
                            let imageToCache = UIImage(data: data)
                            
                            if self.imageUrlString == urlString {
                                cell.adImageView.image = imageToCache
                            }
                            
                            imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                        })
                    }).resume()
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        setCurrent(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func setCurrent(index: Int) {
        
        currentAdsImageUrls = ads?[index].images!
        currentParty = ads?[index].party?.name
        currentType = "\(ads![index].type!)"
        currentDate = convertDate(dateStr: ads![index].created_date!)
        performSegue(withIdentifier: "goToSingleAd", sender: nil)
    }
}
