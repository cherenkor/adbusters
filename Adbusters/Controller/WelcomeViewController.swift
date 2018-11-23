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
    var defaults = UserDefaults.standard
    
    @IBAction func closeInstructions(_ sender: Any) {
        instructionsView.isHidden = true
        defaults.set(true, forKey: "showInstructions")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.textAlignment = .natural
        currentUserId = 21
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let showInstructions = defaults.bool(forKey: "showInstructions")
        instructionsView.isHidden = showInstructions
    }
}
