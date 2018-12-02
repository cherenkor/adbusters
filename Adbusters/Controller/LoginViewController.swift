//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TweePlaceholderTextField!
    @IBOutlet weak var passwordTextField: TweePlaceholderTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        if (email != "" && password != "" ) {
            if isValidEmail(testStr: email ?? "") {
                loginToServerEmail(email: email!, password: password!, completion: { self.performSegue(withIdentifier: "goToMap", sender: self) })
            } else {
                SVProgressHUD.showError(withStatus: "Перевірте email")
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        } else {
            SVProgressHUD.showError(withStatus: "Заповніть усі поля")
            SVProgressHUD.dismiss(withDelay: 1.5)
        }
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
                            let picture = responseDictionary["picture"] as! [String: Any]
                            let data = picture["data"] as! [String: Any]
                            let name = responseDictionary["name"] as! String
                            let email = responseDictionary["email"] as! String
                            let pictureUrl = data["url"] as! String
                            
                            loginToServerFB(token: token, email: email, name: name, pictureUrl: pictureUrl, completion: { self.performSegue(withIdentifier: "goToMap", sender: self) })
                        }
                    }
                }
            }
        }
    }
}
