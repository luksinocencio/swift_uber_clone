//
//  UIWindow+Extensions.swift
//  uberClone
//
//  Created by Lucas Inocencio on 12/06/21.
//  Copyright © 2021 Lucas Inocencio. All rights reserved.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
