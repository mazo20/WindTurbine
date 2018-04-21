//
//  Model.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class Model: NSObject, NSCoding {
    
    
    
    var windSpeed: Double
    var nominalWindSpeed: Double
    var windMultiplier: Double
    var turbineRPM: Double
    var money: Double
    var moneyPerSec: Double
    var powerConversion: Double
    var powerOutput: Double
    var powerPrice: Double
    var level: Int
    var levels: [Double] = [1000, 10000, 100000]
    var levelProgress: Double
    var levelGoal: Double
    
    var upgradeLevels = [[Int]]()
    
    
    override init() {
        windSpeed = 0.1
        nominalWindSpeed = 0.1
        windMultiplier = 1
        turbineRPM = 1
        money = 0
        moneyPerSec = 0.01
        powerConversion = 0.1
        powerPrice = 1
        powerOutput = 1
        level = 1
        levelProgress = 0
        levelGoal = levels[0]
        
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
        windMultiplier = 1
        windSpeed = nominalWindSpeed * windMultiplier
        turbineRPM = windSpeed
        powerOutput = turbineRPM * powerConversion
        moneyPerSec = powerOutput * powerPrice
        levelGoal = levels[level-1]
        
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
    }
    
    
    func update() {
        windSpeed = nominalWindSpeed * windMultiplier
        decayWindSpeed()
        turbineRPM = windSpeed
        powerOutput = turbineRPM * powerConversion
        moneyPerSec = powerOutput * powerPrice
        money += moneyPerSec/10
        levelProgress += moneyPerSec/10
        levelGoal = levels[level-1]
    }
    
    func decayWindSpeed() {
        windMultiplier -= windMultiplier/30
        if windMultiplier < 1 {
            windMultiplier = 1
        }
    }
    
    func tapped() {
        windMultiplier += 0.5
    }
    
}
