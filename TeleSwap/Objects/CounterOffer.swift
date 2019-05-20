//
//  CounterOffer.swift
//  TeleSwap
//
//  Created by Cameron Dunn on 5/20/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation

struct CounterOffer{
    var id: UUID
    var originalPostID: UUID
    var userID: UUID
    var phoneOffered: String
    var phoneColor: String
    var cashOnTop: Int
    init (originalPostID: UUID, userID: UUID, phoneOffered: String, phoneColor: String, cashOnTop: Int){
        self.originalPostID = originalPostID
        self.userID = userID
        self.phoneOffered = phoneOffered
        self.phoneColor = phoneColor
        self.cashOnTop = cashOnTop
        self.id = UUID()
    }
}
