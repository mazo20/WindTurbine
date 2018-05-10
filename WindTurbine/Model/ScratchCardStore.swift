//
//  ScratchCardStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class ScratchCardStore: NSObject, NSCoding {
    
    var cards: [Int]
    
    convenience override init() {
        self.init(cards: [10, 5, 3])
    }
    
    init(cards: [Int]) {
        self.cards = cards
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cards, forKey: "cards")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let cards = aDecoder.decodeObject(forKey: "cards") as? [Int] {
            self.cards = cards
        } else {
            self.cards = [10, 5, 3]
        }
    }
    
    func addCards(_ n: Int) {
        for _ in 1...n {
            let random = Int(arc4random_uniform(3))
            self.cards[random] += 1
        }
    }
    
    
    
}
