//
//  AdsModel.swift
//  Adbusters
//
//  Created by MacBookAir on 11/18/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import Foundation

struct AdsModel: Codable {
    var ads: [AdModel]?
}

struct AdModel: Codable {
    var id: Int?
    var images: [AdImage]?;
    var comment: String?
    var type: Int?
    var party: PersonParty?
    var person: PersonParty?
    var latitude: Double?
    var longitude: Double?
    var user: Int?
    var grouped: Bool?
    var created_date: String?
}

struct AdImage:Codable {
    var image: String?
}

struct PersonParty: Codable {
    var id: Int?
    var name: String?
}
