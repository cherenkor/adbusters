//
//  MyAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/17/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class MyAdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    let ads = [
//        ["photo": "default", "party": "Опозиційний блок", "type": "Бігборд", "date": "Жов 7, 2018"],
//        ["photo": "default", "party": "Народний блок", "type": "Газета", "date": "Лип 11, 2018"],
//        ["photo": "default", "party": "Блок Юлії Тимошенко", "type": "Бумажна листівка", "date": "Бер 9, 2018"],
//        ["photo": "default", "party": "Блок Петра Порошенка", "type": "Транспорт", "date": "Січ 5, 2018"],
//        ["photo": "default", "party": "Партія Олександра Соломанського", "type": "Інше", "date": "Лис 2, 2018"],
//        ["photo": "default", "party": "Коаліційний блок", "type": "Палатка", "date": "Сер 22, 2018"],
//        ["photo": "default", "party": "Антикорумційний блок", "type": "Світлина", "date": "Гру 17, 2018"],
//    ]
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        setCurrent(index: indexPath.row)
    }
    
    func setCurrent(index: Int) {
        if index == 0 {
            currentAdsImages = [UIImage(named: "logo")]  as! [UIImage]
        } else {
            currentAdsImages = [UIImage(named: "logo"), UIImage(named: "logo_large"), UIImage(named: "logo"), UIImage(named: "logo_white"), UIImage(named: "logo"), UIImage(named: "logo")] as! [UIImage]
        }
        currentParty = ads?[index].party?.name
        currentType = "\(ads![index].type!)"
        currentDate = convertDate(dateStr: ads![index].created_date!)
        performSegue(withIdentifier: "goToSingleAd", sender: nil)
    }
}
