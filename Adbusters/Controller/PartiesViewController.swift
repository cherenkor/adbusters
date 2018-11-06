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
    var page = 1
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        
        loadPartiesFromApi()
    }
    
    func loadPartiesFromApi () {
        if page == 0 { return }
        
        showIndicator(true, indicator: activityIndicator)
        
        getRequest(url: "http://www.chesno.org/party/api?page=\(page)") { (json, error) in
            
            if let error = error {
                showIndicator(false, indicator: self.activityIndicator)
                let lastPageError = "The data couldn’t be read because it is missing."
                if error.localizedDescription == lastPageError {
                    self.page = 0
                } else {
                    error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                }
                print("ERROR WAR", error.localizedDescription)
                return
            }
            
            var tempPartyList = [Party]()
            
            for partyItem in json!.results {
                tempPartyList.append(partyItem)
            }
            
            tempPartyList = tempPartyList.sorted(by: { $0.title! < $1.title! })
            
            for partyItem in tempPartyList {
                partiesList.append(partyItem)
            }
            
            showIndicator(false, indicator: self.activityIndicator)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.page += self.page
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveParty(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
}

extension PartiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchParties.count
        } else {
            return partiesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searching {
            cell?.textLabel?.text = searchParties[indexPath.row].title!
        } else {
            cell?.textLabel?.text = partiesList[indexPath.row].title!
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            selectedParty = searchParties[indexPath.row].title!
            delegate?.haveParty(partyName: selectedParty!)
        } else {
            selectedParty = partiesList[indexPath.row].title!
            delegate?.haveParty(partyName: selectedParty!)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = partiesList.count - 1
        
        if indexPath.row == lastItem {
            print("Load MORE needed")
            loadPartiesFromApi()
        }
    }
}

extension PartiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchParties = partiesList.filter({$0.title!.prefix(searchText.count) == searchText})
        searchParties = searchParties.sorted(by: { $0.title! < $1.title! })
        searching = true
        tableView.reloadData()
    }
}
