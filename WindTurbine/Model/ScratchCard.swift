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
            prizeValue = Double(pow(base, Double(level+3)))
            UserDefaults.standard.set(false, forKey: "firstTimeBonus")
            return
        }
        
        let random = Int(arc4random_uniform(100))
        
        switch random {
        case 0..<5:
            prizeValue = Double(pow(base, Double(level+3)))
        case 5..<15:
            prizeValue = Double(pow(base, Double(level+2)))
        case 15..<40:
            prizeValue = Double(pow(base, Double(level+1)))
        case 40..<100:
            prizeValue = Double(pow(base, Double(level)))
        default:
            print("Random value too big")
            prizeValue = 0
        }
    }
}
