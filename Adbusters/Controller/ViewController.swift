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
var currentPartyId: Int?
var currentPolitician: String?
var currentPoliticianId: Int?
var currentType: String?
var currentDate: String?
var currentComment: String?
var currentLocation: String?
var currentLatitude: Double?
var currentLongitude: Double?

// User Data
var currentUserName: String?
var currentUserGarlics: Int?
var currentUserImage: UIImage?
var currentUserId: Int?
var isLogged = false
var isFacebook = false

var partiesList = [Party]()
var politiciansList = [Politician]()
var ads: [AdModel]?
var adsAll: [AdModel]?
let imageCache = NSCache<AnyObject, AnyObject>()
var loadedAds = false
let defaults = UserDefaults.standard

// Marker Data
var multipleMarkerDate = [AdModel]()

var singleMarkerParty = ""
var singleMarkerPolitician = ""
var singleMarkerDate = ""
var singleMarkerComment = ""
var singleMarkerType = ""
var singleMarkerAdImageArray = [AdImage]()
var singleMarkerImages = [UIImage]()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

