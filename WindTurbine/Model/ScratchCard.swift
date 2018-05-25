//
//  ScratchCard.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 05.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class ScratchCard {
    
    enum Prize {
        case money
        case powerPrice
    }
    
    var level: Int
    var isScratched: Bool
    var prizeType: Prize
    var prizeValue: Double
    
    var imageName: String {
        return "ScratchCard\(level)"
    }
    
    var backgroundImageName: String {
        return "CardBackground\(level)"
    }
    
    init(level: Int) {
        self.level = level
        self.isScratched = false
        
        prizeType = .money
        
        let base = 2.5
        if UserDefaults.standard.value(forKey: "firstTimeBonus") == nil && level == 3 {
            print("First time")
            prizeValue = Double(pow(base, Double(level+3)))
            UserDefaults.standard.set(false, forKey: "firstTimeBonus")
            return
        }
        
        let random = Int(arc4random_uniform(100))
        if random < 5 {
            prizeValue = Double(pow(base, Double(level+3)))
        } else if random < 15 {
            prizeValue = Double(pow(base, Double(level+2)))
        } else if random < 40 {
            prizeValue = Double(pow(base, Double(level+1)))
        } else {
            prizeValue = Double(pow(base, Double(level)))
        }
    }
}
