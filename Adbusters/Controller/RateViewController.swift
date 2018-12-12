
import UIKit
import Kingfisher

class RateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        loadTopUsersFromApi()
    }
    
    func loadTopUsersFromApi () {
        DispatchQueue.main.async {
            showIndicator(true, indicator: self.loader)
        }
        
        getRating(completion: { (json, error) in
            
            if let error = error {
                showIndicator(false, indicator: self.loader)
                error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                return
            }
            
            if let users = json {
                topUsers = users.top
                DispatchQueue.main.async {
                    showIndicator(false, indicator: self.loader)
                    self.tableView.reloadData()
                }
            } else {
                showIndicator(false, indicator: self.loader)
                Toast().alert(with: self, title: "Помилка завантаження", message: "Пошкодженi данi")
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RateViewTableViewCell
        cell.userName.text = topUsers![indexPath.row].name
        cell.garlics.text = "\(String(describing: topUsers![indexPath.row].rating ?? 0)) часничків"
        if let imageUrl = topUsers![indexPath.row].picture {
            cell.avatar.kf.indicatorType = .activity
            cell.avatar.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "icon_profile"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
}
