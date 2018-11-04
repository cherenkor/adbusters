//
//  Party.swift
//  Adbusters
//
//  Created by MacBookAir on 11/4/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import Foundation

struct Parties: Decodable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Party]
}

struct Party: Decodable {
    var id: Int?
    var title: String?
    var short_name: String?
}

struct Politician: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var second_name: String
}
