import UIKit
import SVProgressHUD

protocol politicianDelegate {
    func havePolitician(politicianName: String)
}

class PoliticiansViewController: UIViewController {
    
    var delegate : politicianDelegate?
    
    var politicians = ["Антон Яценко","Володимир Бідьовка","Владислав Лук’янов","Артем Щербань","Микола Дмитрук","Вадим Колесніченко","Нестор Шуфрич","Юрій Самойленко","Анатолій Гончаров","Інна Богословська","Яків Безбах","Василь Поляков","Артем Семенюк","Сергій Дунаєв","Геннадій Федоряк","Андрій Пінчук","Володимир Кацуба","Ігор Молоток","Михайло Чечетов","Анатолій Кінах","Сергій Брайко","Володимир Сальдо","Володимир Мисик","Сергій Буряк","Юрій Боярський","Олександр Єгоров","Олександр Єдін","Микола Жук","Михайло Ланьо","Іван Бушко","Олег Царьов","Василь Ковач","Олег Парасків","Микола Сорока"]
    var searchPoliticians = [String]()
    var searching = false
    var selectedPolitician: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        politicians = politicians.sorted(by: { $0 < $1 })
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red:0.31, green:0.13, blue:0.47, alpha:1.0)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    @IBAction func savePolitician(_ sender: Any) {
        if selectedPolitician != nil {
            performSegue(withIdentifier: "goToAddAds", sender: nil)
        } else {
            SVProgressHUD.showError(withStatus: "Виберіть політика")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addAdsViewController = segue.destination as! AddAdsViewController
        addAdsViewController.politician = selectedPolitician!
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
            return politicians.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searching {
            cell?.textLabel?.text = searchPoliticians[indexPath.row]
        } else {
            cell?.textLabel?.text = politicians[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            selectedPolitician = searchPoliticians[indexPath.row]
        } else {
            selectedPolitician = politicians[indexPath.row]
        }
    }
}

extension PoliticiansViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPoliticians = politicians.filter({$0.prefix(searchText.count) == searchText})
        searchPoliticians = searchPoliticians.sorted(by: { $0 < $1 })
        searching = true
        tableView.reloadData()
    }
}
