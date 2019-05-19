//
//  Model.swift
//  TeleSwap
//
//  Created by Cameron Dunn on 5/18/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation

class Model{
    static let shared = Model()
    private init(){}
    var offers : [Offer] = []
}
