//
//  MyAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/17/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit
import Kingfisher

class MyAdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageUrlString: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
        currentAdsImageUrls = [AdImage]()
        // Do any additional setup after loading the view.
        if getAdstask != nil {
            getAdstask!.cancel()
        }
        loadAds()
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        ads = nil
        if getAdstask != nil {
            getAdstask!.cancel()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func loadAds() {
        if ads != nil {
            return
        }
        
        getAds(url: "http://adbusters.chesno.org/ads/") { (json, error) in
            
            if let error = error {
                print("ERROR WAR", error)
                error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                return
            }
            
            if let jsonData = json {
                ads = jsonData.filter({ $0.user == 167})
                loadedAds = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                error?.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAdsViewTableViewCell
        cell.selectionStyle = .none
        cell.title.text = ads?[indexPath.row].party?.name ?? ""
        cell.type.text = getTypeText(ads![indexPath.row].type!)
        cell.politician.text = ads?[indexPath.row].person?.name ?? ""
        cell.date.text = convertDate(dateStr: ads![indexPath.row].created_date!)
        let images = ads![indexPath.row].images!
        
        if (images.count > 0) {
            let urlString = images[0].image!
                if let url = URL(string: urlString) {
                    cell.adImageView.kf.indicatorType = .activity
                    cell.adImageView.kf.setImage(with: url)
                }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
//        selectedCell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        setCurrent(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func setCurrent(index: Int) {
        isAddAdsView = false
        currentAdsImageUrls = ads?[index].images!
        currentParty = ads?[index].party?.name ?? ""
        currentPolitician = ""
        currentType = getTypeText(ads![index].type!)
        currentComment = ""
        currentDate = convertDate(dateStr: ads![index].created_date!)
        performSegue(withIdentifier: "goToSingleAd", sender: nil)
    }
}
