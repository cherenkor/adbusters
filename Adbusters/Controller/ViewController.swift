//
//  ViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

var isAddAdsView = false
var currentAdsImages = [UIImage]()
var currentAdsImageUrls: [AdImage]?
var currentAdImage: UIImage?
var currentParty: String?
var currentType: String?
var currentDate: String?
var currentComment: String?
var currentLocation: String?

// User Data
var currentUserName: String?
var currentUserGarlics: Int?
var currentUserImage: UIImage?
var currentUserId: Int?
var userToken: String?
var isLogged = false

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

