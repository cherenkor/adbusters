//
//  ViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

var currentUserId: Int?
var isAddAdsView = false
var currentAdsImages = [UIImage]()
var currentAdsImageUrls: [AdImage]?
var currentAdImage: UIImage?
var currentParty: String?
var currentType: String?
var currentDate: String?
var currentComment: String?
var currentLocation: String?
var currentUsername: String?
var currentUserGarlics: String?
var currentUserImage: UIImage?
var isLogged = true
var partiesList = [Party]()
var politiciansList = [Politician]()
var ads: [AdModel]?
var adsAll: [AdModel]?
let imageCache = NSCache<AnyObject, AnyObject>()
var loadedAds = false

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

