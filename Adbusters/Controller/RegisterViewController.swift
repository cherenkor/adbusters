//
//  RegisterViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit
import TweeTextField
import SVProgressHUD
import FacebookCore
import FacebookLogin

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        SVProgressHUD.show()
        
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.email], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                SVProgressHUD.dismiss()
            case .cancelled:
                print("User cancelled login")
                SVProgressHUD.dismiss()
            case .success(_, _, let accessToken):
                let params = ["fields" : "email, name, picture.type(large)"]
                let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                graphRequest.start {
                    (urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let responseDictionary = graphResponse.dictionaryValue {
                            let token = accessToken.authenticationToken
                            //                            let id = responseDictionary["id"] as! String
                            let picture = responseDictionary["picture"] as! [String: Any]
                            let data = picture["data"] as! [String: Any]
                            let name = responseDictionary["name"] as! String
                            let email = responseDictionary["email"] as! String
                            let pictureUrl = data["url"] as! String
                            
                            self.loginToServer(token: token, email: email, name: name, pictureUrl: pictureUrl)
                        }
                    }
                }
            }
        }
    }
    
    func loginToServer(token: String, email: String, name: String, pictureUrl: String) {
        loginUserFB(url: "http://adbusters.chesno.org/login/facebook/", token: token, email: email, name: name, pictureUrl: pictureUrl) { (data, error) in
            if let error = error {
                print("ERROR WAR", error)
                SVProgressHUD.showError(withStatus: "Помилка завантаження")
                SVProgressHUD.dismiss(withDelay: 2.0)
                return
            }
            
            self.loadUserData(token: token)
        }
    }
    
    func loadUserData (token: String) {
        getUserData(url: "http://adbusters.chesno.org/profile", token: token) { (json, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print("ERROR WAR", error)
                SVProgressHUD.showError(withStatus: "Помилка завантаження")
                SVProgressHUD.dismiss(withDelay: 2.0)
                return
            }
            print("HAVE DATA", json!)
            if let jsonData = json {
                setCurrentUser(token: token, email: jsonData.email!, name: jsonData.name!, pictureUrl: jsonData.picture!, garlics: jsonData.rating!)
                self.loggedSuccessfully()
            }
        }
    }
    
    func loggedSuccessfully () {
        isLogged = true
        SVProgressHUD.showSuccess(withStatus: "Ласкаво просимо")
        SVProgressHUD.dismiss(withDelay: 1.0) {
            self.performSegue(withIdentifier: "goToMap", sender: self)
        }
    }
}
