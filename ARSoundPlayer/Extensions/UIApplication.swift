//
//  UIApplication.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/26/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

extension UIApplication
{
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
