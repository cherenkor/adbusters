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

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TweePlaceholderTextField!
    @IBOutlet weak var passwordTextField: TweePlaceholderTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if (emailTextField.text == "admin" && passwordTextField.text == "admin") {
            isLogged = true
            currentUsername = "Iван Франко"
            currentUserGarlics = "18 часничкiв"
            currentUserImage = UIImage(named: "avatar")
            SVProgressHUD.showSuccess(withStatus: "Ласкаво просимо")
            SVProgressHUD.dismiss(withDelay: 1.0) {
                self.performSegue(withIdentifier: "goToMap", sender: self)
            }
        } else {
            SVProgressHUD.showError(withStatus: "Щось пiшло не так. Перевiрте введенi данi")
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func loginWithFacebook(_ sender: Any) {
        print("Login with facebook")
    }
}
