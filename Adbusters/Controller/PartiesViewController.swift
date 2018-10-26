import UIKit
import SVProgressHUD

protocol PartyDelegate {
    func haveParty(partyName: String)
}

class PartiesViewController: UIViewController {
    
    var delegate: PartyDelegate?
    
    var parties = ["Партія Регіонів", "Всеукраїнське об'єднання Батьківщина", "Фронт Змін", "УДАР", "Комуністична партія України", "Всеукраїнське об'єднання Свобода", "Народна партія України", "Соціалістична партія України", "Україна - Вперед!", "Громадянська позиція", "Партія Зелених України", "Наша Україна"]
    var searchParties = [String]()
    var searching = false
    var selectedParty: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parties = parties.sorted(by: { $0 < $1 })
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveParty(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        if selectedParty != nil {
//            performSegue(withIdentifier: "goToAddAds", sender: nil)
//        } else {
//            SVProgressHUD.showError(withStatus: "Виберіть політика")
//            SVProgressHUD.dismiss(withDelay: 1.0)
//        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let addAdsViewController = segue.destination as! AddAdsViewController
//        addAdsViewController.party = selectedParty!
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
}

extension PartiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchParties.count
        } else {
            return parties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searching {
            cell?.textLabel?.text = searchParties[indexPath.row]
        } else {
            cell?.textLabel?.text = parties[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            selectedParty = searchParties[indexPath.row]
            delegate?.haveParty(partyName: selectedParty!)
        } else {
            selectedParty = parties[indexPath.row]
            delegate?.haveParty(partyName: selectedParty!)
        }
    }
}

extension PartiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchParties = parties.filter({$0.prefix(searchText.count) == searchText})
        searchParties = searchParties.sorted(by: { $0 < $1 })
        searching = true
        tableView.reloadData()
    }
}
