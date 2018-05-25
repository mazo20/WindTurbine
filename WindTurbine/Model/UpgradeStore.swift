//
//  UpgradeStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class UpgradeStore: NSObject, NSCoding {
    
    var upgrades = [[Upgrade]]() {
        didSet {
            for i in 0..<upgradeLevels.count {
                for j in 0..<upgradeLevels[i].count {
                    upgradeLevels[i][j] = upgrades[i][j].level
                }
            }
        }
    }
    var upgradeLevels = [[Int]]() {
        didSet {
            for i in 0..<upgradeLevels.count {
                for j in 0..<upgradeLevels[i].count {
                    upgrades[i][j].level = upgradeLevels[i][j]
                }
            }
        }
    }
    
    enum Key: String {
        case upgrades, emoji, imageName, name, baseCost, baseValue, costMult, valueMult, buyCards, priceType, value, price
    }
    
    enum Filename: String {
        case WindUpgrades, PowerUpgrades, PriceUpgrades, BatteryUpgrades, BuyScratchCards
    }
    
    
    override init() {
        super.init()
        loadUpgrades()
        initUpgradeLevels()
    }
    
    func loadUpgrades() {
        var upgradesTemp = [[Upgrade]]()
        let filenames = [Filename.WindUpgrades.rawValue, Filename.PowerUpgrades.rawValue, Filename.PriceUpgrades.rawValue]
        var types = [formatterType.wind, formatterType.powerPerKm, formatterType.pricePerW]
        
        //TODO: change json files to contain types of upgrades and parse it correctly
        
        for name in filenames {
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: name),
                let upgrades = dictionary[Key.upgrades.rawValue] as? [Dictionary<String, Any>] {
                var upgradeCategory = [Upgrade]()
                let type = types.removeFirst()
                for upgrade in upgrades {
                    if let emoji = upgrade[Key.emoji.rawValue] as? String,
                        let name = upgrade[Key.name.rawValue] as? String,
                        let baseCost = upgrade[Key.baseCost.rawValue] as? Double,
                        let baseValue = upgrade[Key.baseValue.rawValue] as? Double,
                        let costMult = upgrade[Key.costMult.rawValue] as? Double,
                        let valueMult = upgrade[Key.valueMult.rawValue] as? Double {
                        let u = Upgrade(emoji: emoji, name: name, baseCost: baseCost, baseValue: baseValue, costMult: costMult, valueMult: valueMult, type: type)
                        upgradeCategory.append(u)
                    }
                }
                upgradesTemp.append(upgradeCategory)
            }
        }
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: Filename.BatteryUpgrades.rawValue),
            let upgrades = dictionary[Key.upgrades.rawValue] as? [Dictionary<String, Any>] {
            var upgradeCategory = [Upgrade]()
            var type = [formatterType.power, formatterType.capacity]
            for upgrade in upgrades {
                if let imageName = upgrade[Key.imageName.rawValue] as? String,
                    let name = upgrade[Key.name.rawValue] as? String,
                    let baseCost = upgrade[Key.baseCost.rawValue] as? Double,
                    let baseValue = upgrade[Key.baseValue.rawValue] as? Double,
                    let costMult = upgrade[Key.costMult.rawValue] as? Double,
                    let valueMult = upgrade[Key.valueMult.rawValue] as? Double {
                    let u = Upgrade(imageName: imageName, name: name, baseCost: baseCost, baseValue: baseValue, costMult: costMult, valueMult: valueMult, type: type.removeFirst())
                    upgradeCategory.append(u)
                }
            }
            upgradesTemp.append(upgradeCategory)
        }
        upgrades = upgradesTemp
    }
    
    func initUpgradeLevels() {
        for i in 0..<4 {
            let array = [Int](repeating: 1, count: upgrades[i].count)
            upgradeLevels.append(array)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(upgradeLevels, forKey: "upgradeLevels")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        loadUpgrades()
        
        defer {
            //Makes sure didSet is called
            upgradeLevels = aDecoder.decodeObject(forKey: "upgradeLevels") as! [[Int]]
        }
    }
    
}
