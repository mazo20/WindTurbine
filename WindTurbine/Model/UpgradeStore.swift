//
//  UpgradeStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class UpgradeStore: NSObject, NSCoding {
    
    enum Key: String {
        case upgrades, emoji, imageName, name, baseCost, baseValue, costMult, valueMult, buyCards, priceType, value, price, type
    }
    
    enum Filename: String {
        case WindUpgrades, PowerUpgrades, PriceUpgrades, BatteryUpgrades, BuyScratchCards
    }
    
    var income: Double? {
        didSet {
            extraUpgrades.forEach { $0.income = income }
        }
    }
    
    var upgrades = [Upgrade]()
    var upgradesHashDict = [Int: Upgrade]()
    var extraUpgrades = [ExtraUpgrade]()
    var extraUpgradesHashDict = [Int: ExtraUpgrade]()
    
    var upgradeLevels = [String: Int]()
    
    func upgradesWithType(_ type: upgradeType) -> [Upgrade] {
        return upgrades.filter({$0.type == type})
    }
    
    var upgradesForIncome: [[Upgrade]] {
        var u = [[Upgrade]]()
        let type = [upgradeType.wind, upgradeType.power, upgradeType.price]
        _ = type.map({ u.append(upgradesWithType($0)) })
        return u
    }
    
    var upgradesForBattery: [Upgrade] {
        return upgrades.filter({$0.type == upgradeType.charging || $0.type == upgradeType.capacity})
    }
    
    var purchaseCards: [ExtraUpgrade] {
        return extraUpgrades.filter({$0.rewardType == .card})
    }
    
    var menuUpgrades: [ExtraUpgrade] {
        return extraUpgrades.filter({$0.rewardType == .income || $0.rewardType == .balance})
    }
    
    func areUpgradesUnlocked() -> Bool {
        return upgradeLevels.reduce(true, {$0 && $1.value > 1})
    }
    
    
    
    override init() {
        super.init()
        loadUpgrades()
        
    }
    
    func loadUpgrades() {
        let filenames = [Filename.WindUpgrades.rawValue, Filename.PowerUpgrades.rawValue, Filename.PriceUpgrades.rawValue, Filename.BatteryUpgrades.rawValue]
        
        //TODO: change json files to contain types of upgrades and parse it correctly
        
        for name in filenames {
            let gameLevelMult = GameLevel.planetMult
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: name),
                let upgrades = dictionary[Key.upgrades.rawValue] as? [Dictionary<String, Any>] {
                for (j, upgrade) in upgrades.enumerated() {
                    if let emoji = upgrade[Key.emoji.rawValue] as? String,
                        let name = upgrade[Key.name.rawValue] as? String,
                        let baseCost = upgrade[Key.baseCost.rawValue] as? Double,
                        let baseValue = upgrade[Key.baseValue.rawValue] as? Double,
                        let costMult = upgrade[Key.costMult.rawValue] as? Double,
                        let valueMult = upgrade[Key.valueMult.rawValue] as? Double,
                        let type = upgrade[Key.type.rawValue] as? String,
                        let upgradeType = upgradeType(rawValue: type){
                        
                        let u = Upgrade(emoji: emoji, name: name, baseCost: baseCost*gameLevelMult, baseValue: baseValue*gameLevelMult, costMult: costMult, valueMult: valueMult, type: upgradeType, level: upgradeLevels["\(type)\(j)"] ?? 1)
                        u.delegate = self
                        self.upgrades.append(u)
                    }
                    if let imageName = upgrade[Key.imageName.rawValue] as? String,
                        let name = upgrade[Key.name.rawValue] as? String,
                        let baseCost = upgrade[Key.baseCost.rawValue] as? Double,
                        let baseValue = upgrade[Key.baseValue.rawValue] as? Double,
                        let costMult = upgrade[Key.costMult.rawValue] as? Double,
                        let valueMult = upgrade[Key.valueMult.rawValue] as? Double,
                        let type = upgrade[Key.type.rawValue] as? String,
                        let upgradeType = upgradeType(rawValue: type){
                        let u = Upgrade(imageName: imageName, name: name, baseCost: baseCost*gameLevelMult, baseValue: baseValue*gameLevelMult, costMult: costMult, valueMult: valueMult, type: upgradeType, level: upgradeLevels["\(type)\(0)"] ?? 1)
                        u.delegate = self
                        self.upgrades.append(u)
                    }
                }
            }
        }
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: "ExtraUpgrades") {
            if let extraUpgrades = dictionary["extraUpgrades"] as? [Dictionary<String, Any>] {
                for extra in extraUpgrades {
                    guard let priceTypeString = extra["priceType"] as? String,
                        let priceType = UpgradePriceType(rawValue: priceTypeString),
                        let rewardTypeString = extra["rewardType"] as? String,
                        let rewardType = RewardType(rawValue: rewardTypeString),
                        let value = extra["value"] as? Int,
                        let price = extra["price"] as? Int else { continue }
                    let emoji = extra[Key.emoji.rawValue] as? String
                    let imageName = extra[Key.imageName.rawValue] as? String
                    let extraUpgrade = ExtraUpgrade(rewardType: rewardType, value: value, priceType: priceType, price: price, emoji: emoji, imageName: imageName)
                    self.extraUpgrades.append(extraUpgrade)
                }
            }
        }
        
        for upgrade in upgrades {
            upgradesHashDict[upgrade.hashValue] = upgrade
        }
        for extraUpgrade in extraUpgrades {
            extraUpgradesHashDict[extraUpgrade.hashValue] = extraUpgrade
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(upgradeLevels, forKey: "upgradeLevels")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        upgradeLevels = aDecoder.decodeObject(forKey: "upgradeLevels") as! [String: Int]
        loadUpgrades()
    }
}

extension UpgradeStore: UpgradeDelegate {
    func didSetLevel(upgrade: Upgrade) {
        let type = upgrade.type
        let i = upgradesWithType(type).index(of: upgrade)!
        let level = upgradeLevels["\(type.rawValue)\(i)"] ?? 1
        upgradeLevels["\(type.rawValue)\(i)"] = level+1
    }
}
