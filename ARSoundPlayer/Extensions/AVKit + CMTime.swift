//
//  AVKit + CMTime.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/24/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import AVKit

extension CMTime
{
    func toDisplayString() -> String
    {
        if CMTimeGetSeconds(self).isNaN { return "--:--"}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hours = totalSeconds / (60 * 60)
        
        return hours <= 0 ? String(format: "%02d:%02d", minutes, seconds) : String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
