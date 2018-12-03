//
//  Episode.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/23/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String?
    let pubDate: Date?
    let description: String?
    let imageURL: URL?
    let author: String?
    let duration: String?
    let streamURL: URL?
    var fileURL: URL?
    
    init(feedItem: RSSFeedItem)
    {
        self.title = feedItem.title
        self.author = feedItem.iTunes?.iTunesAuthor
        self.duration = feedItem.iTunes?.iTunesDuration?.string
        self.pubDate = feedItem.pubDate
        self.description = feedItem.description
        self.imageURL = feedItem.iTunes?.iTunesImage?.attributes?.href?.url
        self.streamURL = feedItem.enclosure?.attributes?.url?.url
    }
}
