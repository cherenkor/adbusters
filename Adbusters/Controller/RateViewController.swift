
import UIKit

class RateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    
    let users = [[ "username": "Владислав Пуришов", "garlics": 120, "avatar": "default" ],
                 [ "username": "Ігорь Лакринтиш", "garlics": 20, "avatar": "default" ],
                 [ "username": "Аліса Орхиповна Перекотиполе", "garlics": 10, "avatar": "default" ],
                 [ "username": "Катерина Інтерантович", "garlics": 110, "avatar": "default" ],
                 [ "username": "Олександр Дублін", "garlics": 13, "avatar": "default" ],
                 [ "username": "Пантелеймон Перефон", "garlics": 15, "avatar": "default" ],
                 [ "username": "Параска Кадров", "garlics": 99, "avatar": "default" ],
                 [ "username": "Григорій Вільсонови", "garlics": 999, "avatar": "default" ]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RateViewTableViewCell
        cell.userName.text = (users[indexPath.row]["username"] as! String)
        cell.garlics.text = String(users[indexPath.row]["garlics"] as! Int) + " часничів"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
}
