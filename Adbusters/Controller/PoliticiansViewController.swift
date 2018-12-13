import UIKit

protocol PoliticianDelegate {
    func havePolitician(politicianName: String)
}

class PoliticiansViewController: UIViewController {
    
    var delegate : PoliticianDelegate?
    var searchPoliticians = [Politician]()
    var searching = false
    var selectedPolitician: String?
    var page = 1
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        loadPoliticiansFromApi()
    }
    
    func loadPoliticiansFromApi () {
        if page == 0 { return }
        
        showIndicator(true, indicator: activityIndicator)
        
        getPoliticiansRequest(url: "http://www.chesno.org/politician/api?page=\(page)") { (json, error) in
            
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
            
            var tempPoliticianList = [Politician]()
            
            for politicianItem in json!.results {
                tempPoliticianList.append(politicianItem)
            }
            
//            tempPoliticianList = tempPoliticianList.sorted(by: { $0.first_name < $1.first_name })
            
            for politicianItem in tempPoliticianList {
                politiciansList.append(politicianItem)
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
    
    @IBAction func savePolitician(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
}

extension PoliticiansViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchPoliticians.count
        } else {
            return politiciansList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searching {
            cell?.textLabel?.text = getFullName(row: indexPath.row, list: searchPoliticians)
        } else {
            cell?.textLabel?.text = getFullName(row: indexPath.row, list: politiciansList)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            selectedPolitician = getFullName(row: indexPath.row, list: searchPoliticians)
            delegate?.havePolitician(politicianName: selectedPolitician!)
        } else {
            selectedPolitician = getFullName(row: indexPath.row, list: politiciansList)
            delegate?.havePolitician(politicianName: selectedPolitician!)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = politiciansList.count - 1
        
        if indexPath.row == lastItem {
            loadPoliticiansFromApi()
        }
    }
    
    func getFullName (row: Int, list: [Politician]) -> String {
        currentPoliticianId = list[row].id
        let firstName = list[row].first_name
        let lastName = list[row].last_name
        return "\(firstName) \(lastName)"
    }
}

extension PoliticiansViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPoliticians = politiciansList.filter({$0.first_name.prefix(searchText.count) == searchText})
//        searchPoliticians = searchPoliticians.sorted(by: { $0.first_name < $1.first_name })
        searching = true
        tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchParties = partiesList.filter({$0.title!.prefix(searchText.count) == searchText})
//        searchParties = searchParties.sorted(by: { $0.title! < $1.title! })
//        searching = true
//        tableView.reloadData()
//    }
}
