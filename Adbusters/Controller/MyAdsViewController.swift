//
//  MyAdsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/17/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class MyAdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ads = [
        ["photo": "default", "title": "Опозиційний блок", "type": "Бігборд", "date": "Жов 7, 2018"],
        ["photo": "default", "title": "Народний блок", "type": "Газета", "date": "Лип 11, 2018"],
        ["photo": "default", "title": "Блок Юлії Тимошенко", "type": "Бумажна листівка", "date": "Бер 9, 2018"],
        ["photo": "default", "title": "Блок Петра Порошенка", "type": "Транспорт", "date": "Січ 5, 2018"],
        ["photo": "default", "title": "Партія Олександра Соломанського", "type": "Інше", "date": "Лис 2, 2018"],
        ["photo": "default", "title": "Коаліційний блок", "type": "Палатка", "date": "Сер 22, 2018"],
        ["photo": "default", "title": "Антикорумційний блок", "type": "Світлина", "date": "Гру 17, 2018"],
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAdsViewTableViewCell
        cell.title.text = ads[indexPath.row]["title"]
        cell.type.text = ads[indexPath.row]["type"]
        cell.date.text = ads[indexPath.row]["date"]
        
        return cell
    }
}
