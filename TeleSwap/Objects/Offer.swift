//
//  Offer.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/18/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


struct Offer: Codable {
    var id: UUID
    var title: String
    var year: Int?
    var color : String
    var imageData: Data?
    var offerOnTop : Int
    var imageUrl: String?
    init(title: String, color: String, offerOnTop: Int){
        self.id = UUID()
        self.title = title
        self.color = color
        self.offerOnTop = offerOnTop
    }
}