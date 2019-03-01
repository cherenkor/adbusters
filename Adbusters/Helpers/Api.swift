import Foundation
import Alamofire

var getAdstask: URLSessionDataTask?
var getGarlicsTask: URLSessionDataTask?

func getGarlics(completion: @escaping ()-> ()) {
    print("Inside GETGARLICS ")
    Alamofire.request(API_URL + "/profile/").responseJSON { response in
        
        if let json = response.result.value as? [String:AnyObject] {
            print("JSON: \(json)") // serialized json response
            if let garlics = json["rating"] {
                print("Have garlics", garlics)
                currentUserGarlics = (garlics as! Int)
                saveUserGarlicsToStorage()
                completion()
            }
        }
    }
}

func getRating (completion: @escaping (_ json: RatingTop?, _ error: Error?)->()) {
    let urlObject = URL(string: API_URL + "/rating/")
    let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        do {
            let result = try JSONDecoder().decode(RatingTop.self, from: data!)
            completion(result, error)
        } catch let error {
            completion(nil, error)
        }
    }
    task.resume()
}

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
    print("url - \(url)")
    let urlObject = URL(string: url)
    let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        if let data = data {
            do {
                let result = try JSONDecoder().decode(Politicians.self, from: data)
                completion(result, error)
            } catch let error {
                completion(nil, error)
            }
        } else {
            completion(nil, error)
        }
       
    }
    task.resume()
}

func getAds(url: String, completion: @escaping (_ json: Array<AdModel>?, _ error: Error?)->()) {
    let urlObject = URL(string: url)
    
    if getAdstask != nil {
        getAdstask!.cancel()
    }
    getAdstask = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        if let data = data {
            do {
                let result = try JSONDecoder().decode(Array<AdModel>.self, from: data)
                completion(result, error)
            } catch let error {
                completion(nil, error)
            }
        } else {
            completion(nil, error)
        }
    }
    getAdstask!.resume()
}

func getUserData(url: String, token: String, completion: @escaping (_ json: UserData?, _ error: Error?)->()) {
    let urlLink = URL(string: url)!
    var request = URLRequest(url: urlLink)
    request.httpMethod = "GET"
    request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        if let data = data {
            do {
                let result = try JSONDecoder().decode(UserData.self, from: data)
                completion(result, error)
            } catch let error {
                completion(nil, error)
            }
        }
    }
    task.resume()
}

func loginUserEmail(url: String, email: String, password: String, completion: @escaping (_ error: Error?)->()) {
    let urlLink = URL(string: url)!
    var request = URLRequest(url: urlLink)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let postString = "email=\(email)&password=\(password)"
    request.httpBody = postString.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        if data != nil {
            print("Logged in successfully")
            completion(nil)
        } else {
            print("Can't log in current user")
            completion(error)
        }
    }
    task.resume()
}

func loginUserFB(url: String, token: String, email: String, name: String, pictureUrl: String, completion: @escaping (_ result: Any?, _ error: Error?)->()) {
    let urlLink = URL(string: url)!
    var request = URLRequest(url: urlLink)
    
    var dict = Dictionary<String, Any>()
    
    dict["access_token"] = token
    dict["name"] = name
    dict["email"] = email
    dict["picture"] = pictureUrl
    
    do {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    } catch let error {
        print("Error", error)
    }
}


func logoutRequest (completion: @escaping (_ error: Error?)->()) {
    let urlObject = URL(string: API_URL + "/logout")
    let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
        if data != nil {
            cleanCookies()
            print("Logged out successfully")
            completion(nil)
        } else {
            print("Can't logout current user")
            completion(error)
        }
    }
    task.resume()
}


func registerNewUser(url: String, email: String, name: String, password: String, completion: @escaping (_ error: Error?)->()) {
    let urlLink = URL(string: url)!
    var request = URLRequest(url: urlLink)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let postString = "register=true&email=\(email)&name=\(name)&password=\(password)"
    request.httpBody = postString.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        if data != nil {
            print("Registered in successfully")
            completion(nil)
        } else {
            print("Can't register in current user")
            completion(error)
        }
    }
    task.resume()
}

func cleanCookies () {
    let cookieJar = HTTPCookieStorage.shared
    for cookie in cookieJar.cookies! {
        cookieJar.deleteCookie(cookie)
    }
}

func uploadImages(completion: @escaping (Bool) -> ()){
    let url = API_URL + "/ads_write/"
    var parameters = [String : Any]()
    
    if let lat = currentLatitude {
        parameters["latitude"] = lat
    }
    if let lon = currentLongitude {
        parameters["longitude"] = lon
    }
    
    parameters["type"] = getTypeInt(currentType ?? "")
    
    if let policitianId = currentPoliticianId {
        parameters["person_id"] = policitianId as Int
    }
    
    if let partyId = currentPartyId {
        parameters["party_id"] = partyId as Int
    }
    
    if let comment = currentComment {
        parameters["comment"] = comment as String
    }
    
    
    let cookies = HTTPCookieStorage.shared.cookies
    
    if let cookies = cookies {
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    let headers: HTTPHeaders = [
        "Content-type": "multipart/form-data"
    ]
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.httpCookieStorage = HTTPCookieStorage.shared
    manager.session.configuration.timeoutIntervalForRequest = 30
    print("Trying to send", parameters)
    manager.upload(multipartFormData: { (multipartFormData) in
        for (key, value) in parameters {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
        }

        for (i, ads) in currentAdsImages.enumerated() {
            let data = ads.jpegData(compressionQuality: 0.5)!
            multipartFormData.append(data, withName: "image\(i)", fileName: "jpg", mimeType: "image/jpg")
        }

    }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
        print("Response", result)
        switch result{
        case .success(let upload, _, _):
            upload.responseJSON { response in
                print("Added successfully", response)
                if let err = response.error{
                    print("Some errors", err)
                    completion(false)
                    return
                }
                if let data = response.result.value as? [String:Any] {
                    currentAdId = data["id"] as? Int
                }
                completion(true)
            }
        case .failure(let error):
            print("Error in upload: \(error.localizedDescription)")
        }
    }
}

func deleteAd(completion: @escaping (_ error: Error?)->()) {
    if let id = currentAdId {
        let urlLink = URL(string: API_URL + "/ads_write/\(id)/")!
        print(urlLink)
        var request = URLRequest(url: urlLink)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completion(error)
                print("Error", error)
                return
            }
            
            print("Add successfully deleted")
            completion(nil)
        }
        task.resume()
    }
}
