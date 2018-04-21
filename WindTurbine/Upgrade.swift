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
    var name: String
    var initialCost: Double
    var initialValue: Double
    var costMultiplier: Double
    var valueMultiplier: Double
    
    init(emoji: String, name: String, initialCost: Double, initialValue: Double, costMultiplier: Double, valueMultiplier: Double) {
        self.emoji = emoji
        self.name = name
        self.initialCost = initialCost
        self.initialValue = initialValue
        self.costMultiplier = costMultiplier
        self.valueMultiplier = valueMultiplier
    }
}
