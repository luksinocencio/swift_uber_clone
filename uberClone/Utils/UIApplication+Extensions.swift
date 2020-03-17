//
//  UIApplication+Extensions.swift
//  uberClone
//
//  Created by Lucas Inocencio on 23/02/20.
//  Copyright © 2020 Lucas Inocencio. All rights reserved.
//

import UIKit

extension UIApplication {

    /// The app's key window taking into consideration apps that support multiple scenes.
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }

}

