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
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordRepeatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerTapped(_ sender: Any) {
        SVProgressHUD.show()
        let email = emailTextField.text
        let name = nameTextField.text
        let password = passwordTextField.text
        let passwordRepeat = passwordRepeatTextField.text
        let allFilled = email != "" && name != "" && password != "" && passwordRepeat != ""
        if allFilled {
            let equalPasswords = passwordTextField.text == passwordRepeatTextField.text
            
            if equalPasswords {
                let invalidEmail = isValidEmail(testStr: emailTextField.text ?? "")
                
                if invalidEmail {
                    registerNewUser(url: "https://adbusters.chesno.org/login/email/", email: email!, name: name!, password: password!) { (error) in
                        if error == nil {
                            print("registered")
                            loadUserData(token: "", isFacebookLogin: false, completion: { self.performSegue(withIdentifier: "goToMap", sender: self) } )
                        } else {
                            self.showError("Помилка реєстрації")
                        }
                    }
                } else {
                    showError("Перевірте email")
                }
            } else {
                showError("Паролі не співпадають")
            }
        } else {
            showError("Заповніть усі поля")
        }
    }
    
    func showError(_ errorText: String) {
        SVProgressHUD.showError(withStatus: errorText)
        SVProgressHUD.dismiss(withDelay: 1.5)
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
                print("Logged with FB")
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
                            let picture = responseDictionary["picture"] as! [String: Any]
                            let data = picture["data"] as! [String: Any]
                            let name = responseDictionary["name"] as! String
                            let email = responseDictionary["email"] as! String
                            let pictureUrl = data["url"] as! String
                            currentPictureUrl = pictureUrl
                            loginToServerFB(token: token, email: email, name: name, pictureUrl: pictureUrl, completion: { self.performSegue(withIdentifier: "goToMap", sender: self) })
                        }
                    }
                }
            }
        }
    }
}
