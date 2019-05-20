//
//  Listing.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/18/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


struct Listing: Codable {
    var id: Int
    var title: String?
    var body: String?
    var imageUrl: String?
    var zipCode: Int?
    var city: String?
    var longitude: Double?
    var latitude: Double?
}
