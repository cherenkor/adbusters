//
//  Party.swift
//  Adbusters
//
import Foundation

struct Parties: Decodable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Party]
}

struct Politicians: Decodable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Politician]
}

struct Party: Decodable {
    var id: Int?
    var rating: Int?
    var name: String?
    var short_name: String?
}

struct Politician: Decodable {
    var external_id: Int
    var name: String
}
