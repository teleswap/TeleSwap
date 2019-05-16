//
//  User.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/12/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


struct User: Codable {
    let id: Int
    var username: String
    var email: String
    var imageUrl: String
    var firstName: String
}

struct JWT: Codable {
    var jwt: String
    
    enum CodingKeys: String, CodingKey {
        case jwt
    }
}
