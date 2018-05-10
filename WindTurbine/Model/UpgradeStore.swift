//
//  UpgradeStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

struct UpgradeStore {
    
    var upgrades: [[Upgrade]]
    
    enum Key: String {
        case upgrades, emoji, imageName, name, baseCost, baseValue, costMult, valueMult
    }
    
    enum Filename: String {
        case WindUpgrades, PowerUpgrades, PriceUpgrades, BatteryUpgrades
    }
    
    
    init() {
        var upgradesTemp = [[Upgrade]]()
        let filenames = [Filename.WindUpgrades.rawValue, Filename.PowerUpgrades.rawValue, Filename.PriceUpgrades.rawValue]
        for name in filenames {
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: name),
                let upgrades = dictionary[Key.upgrades.rawValue] as? [Dictionary<String, Any>] {
                var upgradeCategory = [Upgrade]()
                for upgrade in upgrades {
                    if let emoji = upgrade[Key.emoji.rawValue] as? String,
                        let name = upgrade[Key.name.rawValue] as? String,
                        let baseCost = upgrade[Key.baseCost.rawValue] as? Double,
                        let baseValue = upgrade[Key.baseValue.rawValue] as? Double,
                        let costMult = upgrade[Key.costMult.rawValue] as? Double,
                        let valueMult = upgrade[Key.valueMult.rawValue] as? Double {
                        let u = Upgrade(emoji: emoji, name: name, baseCost: baseCost, baseValue: baseValue, costMult: costMult, valueMult: valueMult)
                        upgradeCategory.append(u)
                    }
                }
                upgradesTemp.append(upgradeCategory)
            }
        }
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: Filename.BatteryUpgrades.rawValue),
            let upgrades = dictionary[Key.upgrades.rawValue] as? [Dictionary<String, Any>] {
            var upgradeCategory = [Upgrade]()
            for upgrade in upgrades {
                if let imageName = upgrade[Key.imageName.rawValue] as? String,
                    let name = upgrade[Key.name.rawValue] as? String,
                    let baseCost = upgrade[Key.baseCost.rawValue] as? Double,
                    let baseValue = upgrade[Key.baseValue.rawValue] as? Double,
                    let costMult = upgrade[Key.costMult.rawValue] as? Double,
                    let valueMult = upgrade[Key.valueMult.rawValue] as? Double {
                    let u = Upgrade(imageName: imageName, name: name, baseCost: baseCost, baseValue: baseValue, costMult: costMult, valueMult: valueMult)
                    upgradeCategory.append(u)
                }
            }
            upgradesTemp.append(upgradeCategory)
        }
        
        upgrades = upgradesTemp
    }
    
}
