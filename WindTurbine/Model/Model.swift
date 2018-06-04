//
//  Model.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class Model: NSObject, NSCoding {
    
    var nominalWindSpeed: Double
    var money: Double
    var powerPrice: Double
    var level: Int
    var levelProgress: Double
    var powerConversion: Double
    var lightnings: Int
    var battery: Battery
    var cardStore: ScratchCardStore
    var windMultiplier: Double = 1
    var upgradeStore: UpgradeStore
    
    var windSpeed: Double {
        return nominalWindSpeed * windMultiplier
    }
    
    var turbineRPM: Double {
        return pow(windSpeed, 1/3) * windMultiplier
    }
    
    var moneyPerSec: Double {
        return pow(powerOutput * powerPrice, 1/3)
    }
    
    var powerOutput: Double {
        return windSpeed * powerConversion * windMultiplier
    }
    
    var levelGoal: Double {
        return 5 * pow(10.0, Double(level-1))
    }
    
    var upgrades: [[Upgrade]] {
        return upgradeStore.upgrades
    }
    
    
    
    
    override init() {
        nominalWindSpeed = 0.1
        money = 0
        powerConversion = 0.01
        powerPrice = 0.01
        level = 1
        levelProgress = 0
        lightnings = 1
        battery = Battery(chargingPower: 0.01, capacity: 36)
        cardStore = ScratchCardStore(cards: [3, 2, 1])
        upgradeStore = UpgradeStore()
    }
    
    func reset() {
        nominalWindSpeed = 0.1
        money = 0
        powerConversion = 0.01
        powerPrice = 0.01
        level = 1
        levelProgress = 0
        lightnings = 1
        battery = Battery(chargingPower: 0.01, capacity: 36)
        cardStore = ScratchCardStore(cards: [3, 2, 1])
        upgradeStore = UpgradeStore()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        nominalWindSpeed = aDecoder.decodeDouble(forKey: "nominalWindSpeed")
        money = aDecoder.decodeDouble(forKey: "money")
        powerPrice = aDecoder.decodeDouble(forKey: "powerPrice")
        powerConversion = aDecoder.decodeDouble(forKey: "powerConversion")
        level = aDecoder.decodeInteger(forKey: "level")
        levelProgress = aDecoder.decodeDouble(forKey: "levelProgress")
        lightnings = aDecoder.decodeInteger(forKey: "lightnings")
        battery = aDecoder.decodeObject(forKey: "battery") as! Battery
        cardStore = aDecoder.decodeObject(forKey: "cardStore") as! ScratchCardStore
        if let upgradeStore = aDecoder.decodeObject(forKey: "upgradeStore") as? UpgradeStore {
            self.upgradeStore = upgradeStore
        } else {
            self.upgradeStore = UpgradeStore()
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nominalWindSpeed, forKey: "nominalWindSpeed")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(powerConversion, forKey: "powerConversion")
        aCoder.encode(powerPrice, forKey: "powerPrice")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(levelProgress, forKey: "levelProgress")
        aCoder.encode(battery, forKey: "battery")
        aCoder.encode(cardStore, forKey: "cardStore")
        aCoder.encode(lightnings, forKey: "lightnings")
        aCoder.encode(upgradeStore, forKey: "upgradeStore")
    }
    
    
    func update() {
        decayWindSpeed()
        money += moneyPerSec/10
        levelProgress += moneyPerSec/10
        
        let time = Date().timeIntervalSince(battery.startTime)
        battery.startTime = Date()
        battery.charge += battery.chargingPower*time
    }
    
    func decayWindSpeed() {
        windMultiplier -= windMultiplier/20
        if windMultiplier < 1 {
            windMultiplier = 1
        }
    }
    
    func tapped() {
        windMultiplier += 1
    }
    
}
