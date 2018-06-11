//
//  Model.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class Model: NSObject, NSCoding {
    
    enum Key: String {
        case nominalWindSpeed, money, powerPrice, powerConversion, level, levelProgress, lightnings, incomeMult, numberOfRestarts, maxLevel, battery, cardStore, upgradeStore, totalMoney
    }
    
    var nominalWindSpeed: Double
    var money: Double
    var powerPrice: Double
    
    var levelProgress: Double
    var powerConversion: Double
    var lightnings: Int
    var battery: Battery
    var cardStore: ScratchCardStore
    var windMultiplier: Double = 1
    var upgradeStore: UpgradeStore
    var incomeMult: Double
    var numberOfRestarts: Int
    var maxLevel: Int
    var totalMoney: Double
    var bonusIncomeMultiplier: Double = 1
    
    var windSpeed: Double {
        return nominalWindSpeed * windMultiplier
    }
    
    var turbineRPM: Double {
        return pow(windSpeed, 1/4) * windMultiplier
    }
    
    var moneyPerSec: Double {
        return pow(powerOutput * powerPrice, 1/3) * incomeMult * bonusIncomeMultiplier
    }
    
    var powerOutput: Double {
        return windSpeed * powerConversion * windMultiplier
    }
    
    var levelGoal: Double {
        return 5 * pow(8, Double(level-1))
    }
    
    var level: Int {
        didSet {
            if level > maxLevel { maxLevel = level }
        }
    }
    
    func addMoney(amount: Double) {
        money += amount
        totalMoney += amount
    }
    
    func subtractMoney(amount: Double) {
        money -= amount
    }
    
    func multiplyIncome(by multiplier: Double, duration: TimeInterval) {
        bonusIncomeMultiplier *= multiplier
        _ = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.bonusIncomeMultiplier /= multiplier
        }
    }
    
    
    
    
    override init() {
        nominalWindSpeed = 0.1
        money = 0
        powerConversion = 0.1
        powerPrice = 0.1
        level = 1
        levelProgress = 0
        lightnings = 1
        incomeMult = 1
        numberOfRestarts = 0
        maxLevel = 1
        totalMoney = 0
        battery = Battery(chargingPower: 0.01, capacity: 216)
        cardStore = ScratchCardStore(cards: [3, 2, 1])
        upgradeStore = UpgradeStore()
    }
    
    func reset() {
        nominalWindSpeed = 0.1
        money = 0
        powerConversion = 0.1
        powerPrice = 0.1
        level = 1
        levelProgress = 0
        battery = Battery(chargingPower: 0.01, capacity: 216)
        upgradeStore = UpgradeStore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        nominalWindSpeed = aDecoder.decodeDouble(forKey: Key.nominalWindSpeed.rawValue)
        money = aDecoder.decodeDouble(forKey: Key.money.rawValue)
        powerPrice = aDecoder.decodeDouble(forKey: Key.powerPrice.rawValue)
        powerConversion = aDecoder.decodeDouble(forKey: Key.powerConversion.rawValue)
        level = aDecoder.decodeInteger(forKey: Key.level.rawValue)
        levelProgress = aDecoder.decodeDouble(forKey: Key.levelProgress.rawValue)
        lightnings = aDecoder.decodeInteger(forKey: Key.lightnings.rawValue)
        incomeMult = aDecoder.containsValue(forKey: Key.incomeMult.rawValue) ? aDecoder.decodeDouble(forKey: Key.incomeMult.rawValue) : 1
        numberOfRestarts = aDecoder.containsValue(forKey: Key.numberOfRestarts.rawValue) ? aDecoder.decodeInteger(forKey: Key.numberOfRestarts.rawValue) : 0
        maxLevel = aDecoder.containsValue(forKey: Key.maxLevel.rawValue) ? aDecoder.decodeInteger(forKey: Key.maxLevel.rawValue) : 1
        totalMoney = aDecoder.containsValue(forKey: Key.totalMoney.rawValue) ? aDecoder.decodeDouble(forKey: Key.totalMoney.rawValue) : 0
        battery = aDecoder.decodeObject(forKey: Key.battery.rawValue) as! Battery
        cardStore = aDecoder.decodeObject(forKey: Key.cardStore.rawValue) as! ScratchCardStore
        upgradeStore = aDecoder.decodeObject(forKey: Key.upgradeStore.rawValue) as? UpgradeStore ?? UpgradeStore()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nominalWindSpeed, forKey: Key.nominalWindSpeed.rawValue)
        aCoder.encode(money, forKey: Key.money.rawValue)
        aCoder.encode(powerConversion, forKey: Key.powerConversion.rawValue)
        aCoder.encode(powerPrice, forKey: Key.powerPrice.rawValue)
        aCoder.encode(level, forKey: Key.level.rawValue)
        aCoder.encode(levelProgress, forKey: Key.levelProgress.rawValue)
        aCoder.encode(battery, forKey: Key.battery.rawValue)
        aCoder.encode(cardStore, forKey: Key.cardStore.rawValue)
        aCoder.encode(lightnings, forKey: Key.lightnings.rawValue)
        aCoder.encode(incomeMult, forKey: Key.incomeMult.rawValue)
        aCoder.encode(numberOfRestarts, forKey: Key.numberOfRestarts.rawValue)
        aCoder.encode(maxLevel, forKey: Key.maxLevel.rawValue)
        aCoder.encode(totalMoney, forKey: Key.totalMoney.rawValue)
        aCoder.encode(upgradeStore, forKey: Key.upgradeStore.rawValue)
    }
    
    
    func update() {
        decayWindSpeed()
        addMoney(amount: moneyPerSec/10)
        levelProgress += moneyPerSec/10
        
        let time = Date().timeIntervalSince(battery.startTime)
        battery.startTime = Date()
        battery.addCharge(value: battery.chargingPower*time)
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
