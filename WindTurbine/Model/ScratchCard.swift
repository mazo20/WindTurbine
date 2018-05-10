//
//  ScratchCard.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 05.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

struct ScratchCard {
    
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
        let random = Int(arc4random_uniform(100))
        if random < 50 {
            prizeValue = 1
        } else if random < 60 {
            prizeValue = 100
        } else if random < 65 {
            prizeValue = 10
        } else {
            prizeValue = 100
        }
    }
}
