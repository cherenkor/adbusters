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
    
    func loadPoliticiansFromApi (_ searchText:String = "") {
        if page == 0 { return }
        
        showIndicator(true, indicator: activityIndicator)
        var params = ""
        if searchText.count >= 1 {
            params = "&query=\(searchText)".addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        }
        
        getPoliticiansRequest(url: "https://adbusters.chesno.org/persons?page=\(page)\(params)") { (json, error) in
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
            
            if json!.next == nil {
                self.page = 0;
            }
            
            for politicianItem in json!.results {
                politiciansList.append(politicianItem)
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

extension PoliticiansViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return politiciansList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = politiciansList[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPoliticianId = politiciansList[indexPath.row].external_id
        delegate?.havePolitician(politicianName: politiciansList[indexPath.row].name)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = politiciansList.count - 1
        
        if indexPath.row == lastItem {
            loadPoliticiansFromApi()
        }
    }
}

extension PoliticiansViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        page = 1
        politiciansList = [Politician]()
        loadPoliticiansFromApi(searchText)
    }
}
