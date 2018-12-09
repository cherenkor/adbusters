//
//  MyAdsViewTableViewCell.swift
//  Adbusters
//
//  Created by MacBookAir on 10/18/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

class MyAdsViewTableViewCell: UITableViewCell {
    

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet var politician: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //Do reset here
        title.text = ""
        type.text = ""
        politician.text = ""
        date.text = ""
        adImageView.image = UIImage(named: "logo_violet")
    }
}
