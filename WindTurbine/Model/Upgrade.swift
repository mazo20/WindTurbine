//
//  Upgrade.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 19.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

protocol UpgradeDelegate {
    func didSetLevel(upgrade: Upgrade)
}

enum upgradeType: String {
    case wind, power, price, charging, capacity
}

class Upgrade: NSObject {
    
    var delegate: UpgradeDelegate?
    
    var emoji: String
    var imageName: String?
    var name: String
    var baseCost: Double
    var baseValue: Double
    var costMult: Double
    var valueMult: Double
    var type: upgradeType
    var level: Int {
        didSet {
            delegate?.didSetLevel(upgrade: self)
        }
    }
    
    var cost: Double {
        return baseCost * pow(costMult, Double(level-1))
    }
    
    var value: Double {
        if type == .capacity || type == .charging {
            return baseValue * pow(valueMult, Double(level-1))
        }
        return baseValue * pow(valueMult, Double(level/15))
    }
    
    
    init(emoji: String = "",
         imageName: String? = nil,
         name: String,
         baseCost: Double,
         baseValue: Double,
         costMult: Double,
         valueMult: Double,
         type: upgradeType,
         level: Int) {
        self.emoji = emoji
        self.imageName = imageName
        self.name = name
        self.baseCost = baseCost
        self.baseValue = baseValue
        self.costMult = costMult
        self.valueMult = valueMult
        self.type = type
        self.level = level
    }
    
}
