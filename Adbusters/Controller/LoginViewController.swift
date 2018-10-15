//
//  LoginViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit
import TweeTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TweePlaceholderTextField!
    @IBOutlet weak var passwordTextField: TweePlaceholderTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if (emailTextField.text == "me@me.com" && passwordTextField.text == "admin") {
        performSegue(withIdentifier: "goToMap", sender: self)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
