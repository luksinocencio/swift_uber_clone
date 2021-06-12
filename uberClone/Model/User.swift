//
//  User.swift
//  uberClone
//
//  Created by Lucas Inocencio on 12/06/21.
//  Copyright © 2021 Lucas Inocencio. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let fullname: String
    let email: String
    let accountType: Int
    
    init(dictionary: [String: Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}

