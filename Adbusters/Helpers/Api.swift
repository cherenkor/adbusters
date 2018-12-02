import Foundation

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
