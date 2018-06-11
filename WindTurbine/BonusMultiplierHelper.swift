//
//  BonusMultiplierHelper.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

struct BonusMultiplierHelper {
    
    static func getRandomMultiplier() -> (multiplier: Double, duration: TimeInterval) {
        let multiplier = randomMultiplier()
        let duration = randomDuration()
        return (multiplier, duration)
    }
    
    private static func randomMultiplier() -> Double {
        let random = Int(arc4random_uniform(100))
        switch random {
        case 0..<5:
            return 5
        case 5..<15:
            return 4
        case 15..<40:
            return 3
        case 40..<100:
            return 2
        default:
            print("Random value too big")
            return 1
        }
    }
    
    private static func randomDuration() -> TimeInterval {
        let random = Int(arc4random_uniform(100))
        switch random {
        case 0..<5:
            return 240
        case 5..<15:
            return 180
        case 15..<40:
            return 120
        case 40..<100:
            return 60
        default:
            print("Random value too big")
            return 0
        }
    }
    
}
