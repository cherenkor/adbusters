//
//  ViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 10/15/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

let API_URL = "https://adbusters.chesno.org"
var isAddAdsView = false
var currentAdId: Int?
var currentAdsImages = [UIImage]()
var currentAdsImageUrls: [AdImage]?
var currentAdImage: UIImage?
var currentParty: String?
var currentPartyId: Int?
var currentPolitician: String?
var currentPoliticianId: Int?
var currentPictureUrl: String?
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

var reloadMultiples = false
var multiples = [MyAnnotation]()
var reloadClusters = false
var reloadSingleCluster = false
var singleId = 0
var singleUser = 0
var singleMarkerParty = ""
var singleMarkerPolitician = ""
var singleMarkerDate = ""
var singleMarkerComment = ""
var singleMarkerType = ""
var singleMarkerAdImageArray = [AdImage]()
var singleMarkerImages = [UIImage]()

// Rating
var topUsers: [RatingUser]?

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

