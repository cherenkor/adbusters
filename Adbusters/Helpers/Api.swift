import Foundation
import Alamofire

var getAdstask: URLSessionDataTask?

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
    let urlObject = URL(string: "http://adbusters.chesno.org/logout")
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

func uplaodImages(completion: @escaping (Bool) -> ()){
    
    let url = "http://adbusters.chesno.org/ads_write/"
    var parameters = [String : Any]()
    
    if let lat = currentLatitude {
        parameters["latitude"] = lat
    }
    if let lon = currentLongitude {
        parameters["longitude"] = lon
    }
    
    parameters["type"] = getTypeInt(currentType ?? "")
    
    if true {
        parameters["person_id"] = 1 as Int
    }
    
    if true {
        parameters["party_id"] = 1 as Int
    }
    
    if true {
        parameters["comment"] = "My comment" as String
    }
    
    
    let cookies = HTTPCookieStorage.shared.cookies
    
    if let cookies = cookies {
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    let headers: HTTPHeaders = [
        /* "Authorization": "your_access_token",  in case you need authorization header */
        "Content-type": "multipart/form-data"
    ]
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.httpCookieStorage = HTTPCookieStorage.shared
    manager.session.configuration.timeoutIntervalForRequest = 30
    
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
                print("Succesfully uploaded", response)
                if let err = response.error{
                    print("Some errors", err)
                    completion(false)
                    return
                }
                completion(true)
            }
        case .failure(let error):
            print("Error in upload: \(error.localizedDescription)")
        }
    }
}

//func uplaodImages(completion: @escaping () -> ()) {
//    let headers = [String:String]()
//    let imageDataArray = currentAdsImages
//
//    Alamofire.upload(multipartFormData: { multipartFormData in
//
//        var params = [String:AnyObject]()
//        params["latitude"] = currentLatitude as AnyObject
//        params["longitude"] = currentLongitude as AnyObject
//        params["type"] = currentType as AnyObject
//        params["person_id"] = 1 as AnyObject
//        params["party_id"] = 1 as AnyObject
//        params["comment"] = "My comment" as AnyObject
//
//        for (key, value) in params {
//            if let data = value.data(using: String.Encoding.utf8.rawValue) {
//                multipartFormData.append(data, withName: key)
//
//            }
//        }
//
//
//                for i in 0..<imageDataArray.count {
//                    let imageData1 = imageDataArray[i].jpegData(compressionQuality: 0.5)!
//                    multipartFormData.append(imageData1, withName: "image"+String(format:"%d",i), fileName: "image.jpg", mimeType: "image/jpeg")
//                    print("success");
//                }
//
//            },
//     to: "http://127.0.0.1:8000/ads_write/",method:HTTPMethod.post,
//     headers: headers, encodingCompletion: { encodingResult in
//        switch encodingResult {
//        case .success(let upload, _, _):
//            upload
//                .validate()
//                .responseJSON { response in
//                    switch response.result {
//                    case .success(let value):
//                        print("responseObject: \(value)")
//                    case .failure(let responseError):
//                        print("responseError: \(responseError)")
//                    }
//            }
//        case .failure(let encodingError):
//            print("encodingError: \(encodingError)")
//        }
//        completion()
//    })
//
//
//
//
//}

