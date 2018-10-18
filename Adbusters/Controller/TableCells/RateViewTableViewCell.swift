//
//  RateViewTableViewCell.swift
//  Adbusters
//
//  Created by MacBookAir on 10/18/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class RateViewTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var garlics: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
