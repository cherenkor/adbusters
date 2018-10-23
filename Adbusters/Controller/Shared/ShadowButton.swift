//
//  ShadowButton.swift
//  Adbusters
//
//  Created by MacBookAir on 10/23/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.cornerRadius = 35
        layer.masksToBounds = false
    }

}
