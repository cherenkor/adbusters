import Foundation
import UIKit
import MapKit
import SVProgressHUD
import ClusterKit

// USER

func setCurrentUser (token: String, email: String, name: String, pictureUrl: String, garlics: Int) {
    currentUserName = name
    currentUserGarlics = garlics
    
    if let url = NSURL(string: pictureUrl) {
        if let data = NSData(contentsOf: url as URL){
            currentUserImage = UIImage(data: data as Data)
            print("has photo", data)
        } else {
            currentUserImage = UIImage(named: "icon_profile")!
        }
    }
}

// UI

// Spinner, native

func showIndicator (_ show: Bool, indicator: UIActivityIndicatorView) {
    DispatchQueue.main.async {
        indicator.isHidden = !show
        
        if show {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}

/// Extending error to make it alertable
extension Error {
    
    /// displays alert from source controller
    func alert(with controller: UIViewController, title: String = "Помилка завантаження", message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            controller.present(alertController, animated: true, completion: nil)
        }
    }
}

// JSON settings
func getTypeText (_ typeInt: Int) -> String {
    if typeInt == 1 {
        return "Бігборд"
    } else if typeInt == 2 {
        return "Сітілайт"
    } else if typeInt == 3 {
        return "Газета"
    } else if typeInt == 4 {
        return "Листівка"
    } else if typeInt == 5 {
        return "Намет"
    } else if typeInt == 6 {
        return "Транспорт"
    } else {
        return "Інше"
    }
}

// Date

func convertDate (dateStr : String) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    if let date = formatter.date(from: dateStr) {
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "MMM d, HH:mm"
        let string = formatter.string(from: date)
        return string.capitalized
    } else {
        return dateStr
    }
}

func getDateNow () -> String {
    let format = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = Date()
    return dateFormatter.string(from: date)
}


// MAP
class MyAnnotation: NSObject, MKAnnotation {
    weak public var cluster: CKCluster?
    let title: String?
    let subtitle: String?
    let party: String?
//    let politician: String?
//    let date: String?
//    let comment: String?
    let coordinate: CLLocationCoordinate2D
    var image: UIImage? = nil
    var id: Int? = nil
//    var grouped: Bool? = nil

    init(id: Int, coordinate: CLLocationCoordinate2D, party: String) {
        self.title = "\(id)"
        self.subtitle = ""
        self.id = id
        self.coordinate = coordinate
        self.party = party
//        super.init()
    }
}

// VALIADATION
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

// SAVE USER
func saveUserToStorage () {
    let defaults = UserDefaults.standard
    defaults.set(isLogged, forKey: "isLogged")
    defaults.set(isFacebook, forKey: "isFacebook")
    defaults.set(currentUserName, forKey: "name")
    defaults.set(currentUserGarlics, forKey: "garlics")
    defaults.set(currentUserImage?.jpegData(compressionQuality: 1.0), forKey: "image")
}

func setCurrentUserData () {
    currentUserName = defaults.string(forKey: "name")
    currentUserGarlics = defaults.integer(forKey: "garlics")
    let userImage = defaults.object(forKey: "image")
    if let image = userImage as? Data {
        currentUserImage = UIImage(data: image)
    } else {
        currentUserImage = UIImage(named: "icon_profile")!
    }
    isFacebook = defaults.bool(forKey: "isFacebook")
    isLogged = defaults.bool(forKey: "isLogged")
}


// LOGINIZATION
func loginToServerEmail(email: String, password: String, completion: @escaping (()->())) {
    loginUserEmail(url: "http://adbusters.chesno.org/login/email/", email: email, password: password) { (error) in
        if error == nil {
            loadUserData(token: "", isFacebookLogin: false, completion: { completion()} )
        } else {
            SVProgressHUD.showError(withStatus: "Помилка завантаження")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
    }
}

func loginToServerFB(token: String, email: String, name: String, pictureUrl: String, completion: @escaping (()->())) {
    loginUserFB(url: "http://adbusters.chesno.org/login/facebook/", token: token, email: email, name: name, pictureUrl: pictureUrl) { (data, error) in
        if let error = error {
            print("ERROR WAR", error)
            SVProgressHUD.showError(withStatus: "Помилка завантаження")
            SVProgressHUD.dismiss(withDelay: 1.5)
            return
        }
        
        loadUserData(token: token, isFacebookLogin: true, completion: { completion() })
    }
}

func loadUserData (token: String, isFacebookLogin: Bool, completion: @escaping (()->())) {
    getUserData(url: "http://adbusters.chesno.org/profile/", token: token) { (json, error) in
        SVProgressHUD.dismiss()
        if let error = error {
            print("ERROR WAR", error)
            SVProgressHUD.showError(withStatus: "Помилка завантаження")
            SVProgressHUD.dismiss(withDelay: 1.5)
            return
        }
        print("HAVE DATA", json!)
        if let jsonData = json {
            if let email = jsonData.email {
                setCurrentUser(token: token, email: email, name: jsonData.name!, pictureUrl: jsonData.picture ?? "", garlics: jsonData.rating!)
                isFacebook = isFacebookLogin
                loggedSuccessfully(completion:  { completion() })
            } else {
                SVProgressHUD.showError(withStatus: "Перевірте ваші дані")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
}

func loggedSuccessfully (completion: @escaping (() -> ())) {
    isLogged = true
    saveUserToStorage ()
    SVProgressHUD.showSuccess(withStatus: "Ласкаво просимо")
    SVProgressHUD.dismiss(withDelay: 1.0) { completion() }
}

// Additional Types
struct UserData: Decodable {
    var email: String?
    var rating: Int?
    var name: String?
    var picture: String?
}


// MARKERS
func getResizedMarker (_ image: UIImage) -> UIImage {
    var resizedImage = image
    resizedImage = image.resize(toWidth: 40.0)!
    resizedImage = image.resize(toHeight: 40.0)!
    return resizedImage
}
