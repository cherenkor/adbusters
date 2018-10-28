//
//  WelcomeViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var textField: UITextView!
    
    @IBAction func closeInstructions(_ sender: Any) {
        instructionsView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.textAlignment = .natural
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
