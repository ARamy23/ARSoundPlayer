//
//  Track.swift
//  ARSoundPlayer
//
//  Created by Ahmed Ramy on 12/3/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import Foundation

public struct Track: Codable {
    
    let title: String?
    
    /// Artwork URL
    let imageURL: URL?
    
    let artistName: String?
    
    /// URL to play the track online
    let streamURL: URL?
    
    /// URL to play the track offline
    var fileURL: URL?
    
    public init(title: String, imageURL: URL? = nil, artistName: String, streamURL: URL, fileURL: URL? = nil) {
        self.title = title
        self.imageURL = imageURL
        self.artistName = artistName
        self.streamURL = streamURL
        self.fileURL = fileURL
    }
}
