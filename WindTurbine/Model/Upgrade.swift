//
//  Upgrade.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 19.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class Upgrade {
    
    var emoji: String
    var imageName: String?
    var name: String
    var baseCost: Double
    var baseValue: Double
    var costMult: Double
    var valueMult: Double
    var type: formatterType
    var level = 1
    
    var cost: Double {
        return baseCost * pow(costMult, Double(level-1))
    }
    
    var value: Double {
        return baseValue * pow(valueMult, Double(level/5))
    }
    
    
    init(emoji: String = "", imageName: String? = nil, name: String, baseCost: Double, baseValue: Double, costMult: Double, valueMult: Double, type: formatterType) {
        self.emoji = emoji
        self.imageName = imageName
        self.name = name
        self.baseCost = baseCost
        self.baseValue = baseValue
        self.costMult = costMult
        self.valueMult = valueMult
        self.type = type
    }
    
}
