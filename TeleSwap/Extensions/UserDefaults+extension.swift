//
//  UserDefaults+extension.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/15/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    var userId: Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    var token: String? {
        return string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    var longitude: String? {
        return string(forKey: UserDefaultsKeys.longitude.rawValue)
    }
    
    var latitude: String? {
        return string(forKey: UserDefaultsKeys.latitude.rawValue)
    }
}
