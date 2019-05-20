//
//  CounterOffer.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/20/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


struct CounterOffer: Codable {
    var id: Int
    var title: String
    var year: Int?
    var color : String
    var imageData: Data?
    var offerOnTop : Int
    var imageUrl: String?
}
