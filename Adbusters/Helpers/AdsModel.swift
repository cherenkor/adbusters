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
    
    init (id: Int, user: Int = 0, images: [AdImage] = [AdImage](), comment: String = "", type: Int = 7, party: String = "", politician: String = "", date: String = "") {
        self.id = id
        self.user = user
        self.images = images
        self.comment = comment
        self.type = type
        self.party = PersonParty(id: 0, name: party)
        self.person = PersonParty(id: 0, name: politician)
        self.created_date = date
    }
}

struct AdImage: Codable {
    var image: String?
}

struct PersonParty: Codable {
    var id: Int?
    var name: String?
}

struct RatingTop: Codable {
    var top: [RatingUser]?
}

struct RatingUser: Codable {
    var email: String?
    var rating: Int?
    var name: String?
    var picture: String?
}
