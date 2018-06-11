//
//  Battery.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class Battery: NSObject, NSCoding {
    
    enum Key: String {
        case charge, chargingPower, capacity, startTime
    }
    
    var charge: Double
    var chargingPower: Double
    var capacity: Double
    var startTime: Date
    
    var chargePercentage: Int {
        return charge/capacity*100 > 100 ? 100 : Int(charge/capacity*100)
    }
    
    init(charge: Double = 10, chargingPower: Double, capacity: Double) {
        self.charge = charge
        self.chargingPower = chargingPower
        self.capacity = capacity
        self.startTime = Date()
    }
    
    func addCharge(value: Double) {
        charge += value
        if charge > capacity {
            charge = capacity
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(charge, forKey: Key.charge.rawValue)
        aCoder.encode(chargingPower, forKey: Key.chargingPower.rawValue)
        aCoder.encode(capacity, forKey: Key.capacity.rawValue)
        aCoder.encode(startTime, forKey: Key.startTime.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        charge = aDecoder.decodeDouble(forKey: Key.charge.rawValue)
        chargingPower = aDecoder.decodeDouble(forKey: Key.chargingPower.rawValue)
        capacity = aDecoder.decodeDouble(forKey: Key.capacity.rawValue)
        startTime = aDecoder.decodeObject(forKey: Key.startTime.rawValue) as! Date
        
    }
}
