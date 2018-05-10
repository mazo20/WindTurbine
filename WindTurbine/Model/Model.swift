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
    var battery: Battery
    var cardStore: ScratchCardStore
    
    var levels: [Double] = [10, 100, 1000, 10000, 100000]
    var windMultiplier: Double = 1
    var upgradeLevels = [[Int]]()
    
    var windSpeed: Double {
        return nominalWindSpeed * windMultiplier
    }
    
    var turbineRPM: Double {
        return pow(windSpeed,1/4) * windMultiplier
    }
    
    var moneyPerSec: Double {
        return powerOutput * powerPrice
    }
    
    var powerOutput: Double {
        return windSpeed * powerConversion
    }
    
    var levelGoal: Double {
        return levels[level-1]
    }
    
    
    
    
    override init() {
        nominalWindSpeed = 0.1
        money = 0
        powerConversion = 1
        powerPrice = 0.1
        level = 1
        levelProgress = 0
        battery = Battery(chargingPower: 0.05, capacity: 36)
        cardStore = ScratchCardStore()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        nominalWindSpeed = aDecoder.decodeDouble(forKey: "nominalWindSpeed")
        money = aDecoder.decodeDouble(forKey: "money")
        powerPrice = aDecoder.decodeDouble(forKey: "powerPrice")
        powerConversion = aDecoder.decodeDouble(forKey: "powerConversion")
        level = aDecoder.decodeInteger(forKey: "level")
        levelProgress = aDecoder.decodeDouble(forKey: "levelProgress")
        levels = aDecoder.decodeObject(forKey: "levels") as! [Double]
        upgradeLevels = aDecoder.decodeObject(forKey: "upgradeLevels") as! [[Int]]
        if let battery = aDecoder.decodeObject(forKey: "battery") as? Battery {
           self.battery = battery
        } else {
            self.battery = Battery(chargingPower: 0.05, capacity: 36)
        }
        if let cardStore = aDecoder.decodeObject(forKey: "cardStore") as? ScratchCardStore {
            self.cardStore = cardStore
        } else {
            self.cardStore = ScratchCardStore()
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nominalWindSpeed, forKey: "nominalWindSpeed")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(powerConversion, forKey: "powerConversion")
        aCoder.encode(powerPrice, forKey: "powerPrice")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(levelProgress, forKey: "levelProgress")
        aCoder.encode(levels, forKey: "levels")
        aCoder.encode(upgradeLevels, forKey: "upgradeLevels")
        aCoder.encode(battery, forKey: "battery")
        aCoder.encode(cardStore, forKey: "cardStore")
    }
    
    
    func update() {
        decayWindSpeed()
        money += moneyPerSec/10
        levelProgress += moneyPerSec/10
    }
    
    func decayWindSpeed() {
        windMultiplier -= windMultiplier/10
        if windMultiplier < 1 {
            windMultiplier = 1
        }
    }
    
    func tapped() {
        windMultiplier += 1
    }
    
}
