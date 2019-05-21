//
//  Offer.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/18/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation


<<<<<<< HEAD:TeleSwap/Objects/Offer.swift
struct Offer: Codable {
    var id: UUID
=======
struct AcceptableOffer: Codable {
    var id: Int?
>>>>>>> master:TeleSwap/Objects/AcceptableOffer.swift
    var title: String
    var year: Int?
    var color : String
    var imageData: Data?
    var cashOnTop : Float?
    var imageUrl: String?
<<<<<<< HEAD:TeleSwap/Objects/Offer.swift
    init(title: String, color: String, offerOnTop: Int){
        self.id = UUID()
=======
    init(title: String, color: String, cashOnTop: Float){
>>>>>>> master:TeleSwap/Objects/AcceptableOffer.swift
        self.title = title
        self.color = color
        self.cashOnTop = cashOnTop
    }
}
