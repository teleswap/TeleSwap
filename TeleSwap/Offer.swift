//
//  Offer.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/18/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


struct Offer: Codable {
    var id: String
    var title: String
    var year: Int?
    var description: String?
    var color : String
    var offerOnTop : Int
    var imageUrl: String?
    init(title: String, color: String, offerOnTop: Int){
        self.id = UUID().uuidString
        self.title = title
        self.color = color
        self.offerOnTop = offerOnTop
    }
}
