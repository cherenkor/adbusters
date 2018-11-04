import UIKit
import SVProgressHUD

protocol PartyDelegate {
    func haveParty(partyName: String)
}

class PartiesViewController: UIViewController {
    
    var delegate: PartyDelegate?
    
    
    var searchParties = [Party]()
    var searching = false
    var selectedParty: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        
        getPartiesRequest(url: "http://www.chesno.org/party/api", controller: self) { (json, error) in
            partiesList = json!.results.sorted(by: { $0.title! < $1.title! })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
            return partiesList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searching {
            cell?.textLabel?.text = searchParties[indexPath.row].title!
        } else {
            cell?.textLabel?.text = partiesList![indexPath.row].title!
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            selectedParty = searchParties[indexPath.row].title!
            delegate?.haveParty(partyName: selectedParty!)
        } else {
            selectedParty = partiesList![indexPath.row].title!
            delegate?.haveParty(partyName: selectedParty!)
        }
    }
}

extension PartiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchParties = partiesList!.filter({$0.title!.prefix(searchText.count) == searchText})
        searchParties = searchParties.sorted(by: { $0.title! < $1.title! })
        searching = true
        tableView.reloadData()
    }
}
