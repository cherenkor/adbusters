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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
