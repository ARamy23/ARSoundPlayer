import Foundation

struct SearchResult: Codable {
    let resultCount: Int?
    let results: [Podcast]?
}

struct Podcast: Codable {
    
    static let supportsSecureCoding: Bool = true
    
    let wrapperType: String?
    let kind: String?
    let artistID, collectionID, trackID: Int?
    let artistName: String?
    let collectionName, trackName, collectionCensoredName, trackCensoredName: String?
    let artistViewURL, collectionViewURL, trackViewURL: String?
    let previewURL: String?
    let feedURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: String?
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case feedURL = "feedUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable
    }
    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
//        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
//        aCoder.encode(artworkUrl100 ?? "", forKey: "artworkUrl100Key")
//        aCoder.encode(trackID ?? 0, forKey: "trackIDKey")
//        aCoder.encode(feedURL ?? "", forKey: "feedURLKey")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.trackName = aDecoder.decodeObject(forKey: "trackNameKey") as? String
//        self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
//        self.artworkUrl100 = aDecoder.decodeObject(forKey: "artworkUrl100Key") as? String
//        self.trackID = aDecoder.decodeInteger(forKey: "trackIDKey")
//        self.feedURL = aDecoder.decodeObject(forKey: "feedURLKey") as? String
//    }
}
