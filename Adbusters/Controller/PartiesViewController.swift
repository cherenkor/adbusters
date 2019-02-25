import UIKit
import SVProgressHUD

protocol PartyDelegate {
    func haveParty(partyName: String)
}

class PartiesViewController: UIViewController {
    
    var delegate: PartyDelegate?
    
    var searchParties = [Party]()
    var searching = false
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
    
    func loadPartiesFromApi (_ searchText:String = "") {
        if page == 0 { return }
        
        showIndicator(true, indicator: activityIndicator)
        var params = ""
        if searchText.count >= 1 {
            params = "&query=\(searchText)".addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        }
        
        getPartiesRequest(url: "https://adbusters.chesno.org/parties?page=\(page)\(params)") { (json, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    showIndicator(false, indicator: self.activityIndicator)
                }
                let lastPageError = "The data couldn’t be read because it is missing."
                if error.localizedDescription == lastPageError {
                    self.page = 0
                } else {
                    error.alert(with: self, title: "Помилка завантаження", message: "Проблеми з сервером або iнтернетом")
                }
                print("ERROR WAR", error.localizedDescription)
                return
            }
            
            for partyItem in json!.results {
                partiesList.append(partyItem)
            }
            
            if json!.next == nil {
                self.page = 0;
            }
            
            DispatchQueue.main.async {
                showIndicator(false, indicator: self.activityIndicator)
                self.tableView.reloadData()
                self.page += self.page
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
}

extension PartiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return partiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = getPartyName(partiesList[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPartyId = partiesList[indexPath.row].id
        delegate?.haveParty(partyName: getPartyName(partiesList[indexPath.row]))
        partiesList = [Party]()
         self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = partiesList.count - 1
        
        if indexPath.row == lastItem {
            loadPartiesFromApi()
        }
    }
    
    func getPartyName(_ party: Party) -> String {
        let name = party.name ?? ""
        return name
    }
}

extension PartiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        page = 1
        partiesList = [Party]()
        loadPartiesFromApi(searchText)
    }
}
