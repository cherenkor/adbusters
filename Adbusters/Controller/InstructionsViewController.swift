//
//  InstructionsViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/23/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.textAlignment = .natural
    }
}
