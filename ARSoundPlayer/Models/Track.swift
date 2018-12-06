//
//  Track.swift
//  ARSoundPlayer
//
//  Created by Ahmed Ramy on 12/3/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

struct Track: Codable {
    
    let title: String?
    
    /// Artwork URL
    let imageURL: URL?
    
    let artistName: String?
    
    /// URL to play the track online
    let streamURL: URL?
    
    /// URL to play the track offline
    var fileURL: URL?
}
