import Foundation
import UIKit

// MARK: WORK WITH APU
func getPartiesRequest(url: String, completion: @escaping (_ json: Parties?, _ error: Error?)->()) {
    let urlObject = URL(string: url)
    let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        do {
            let result = try JSONDecoder().decode(Parties.self, from: data!)
            completion(result, error)
        } catch let error {
            completion(nil, error)
        }
    }
    task.resume()
}

func getPoliticiansRequest(url: String, completion: @escaping (_ json: Politicians?, _ error: Error?)->()) {
    let urlObject = URL(string: url)
    let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        do {
            let result = try JSONDecoder().decode(Politicians.self, from: data!)
            completion(result, error)
        } catch let error {
            completion(nil, error)
        }
    }
    task.resume()
}

func getAds(url: String, completion: @escaping (_ json: Array<AdModel>?, _ error: Error?)->()) {
    let urlObject = URL(string: url)
    let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        if let data = data {
            do {
                let result = try JSONDecoder().decode(Array<AdModel>.self, from: data)
                completion(result, error)
            } catch let error {
                completion(nil, error)
            }
        }
    }
    task.resume()
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

