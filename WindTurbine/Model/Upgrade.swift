//
//  Upgrade.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 19.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

struct Upgrade {
    var emoji: String
    var imageName: String
    var name: String
    var baseCost: Double
    var baseValue: Double
    var costMult: Double
    var valueMult: Double
    
    init(emoji: String = "", imageName: String = "", name: String, baseCost: Double, baseValue: Double, costMult: Double, valueMult: Double) {
        self.emoji = emoji
        self.imageName = imageName
        self.name = name
        self.baseCost = baseCost
        self.baseValue = baseValue
        self.costMult = costMult
        self.valueMult = valueMult
    }
}
