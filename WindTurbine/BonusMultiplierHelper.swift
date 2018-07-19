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
            return 3
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
            return 120
        case 5..<15:
            return 90
        case 15..<40:
            return 60
        case 40..<100:
            return 30
        default:
            print("Random value too big")
            return 0
        }
    }
    
}
