//
//  Episode.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/23/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let title: String?
    let pubDate: Date?
    let description: String?
    let imageURL: URL?
    let author: String?
    let duration: String?
    let streamURL: URL?
    var fileURL: URL?
}
