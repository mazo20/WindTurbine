//
//  ScratchCardStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class ScratchCardStore: NSObject, NSCoding {
    
    var cards: [Int]!
    var freeCardsDate: Date
    
    convenience override init() {
        self.init(cards: [10, 5, 3])
    }
    
    init(cards: [Int]) {
        self.cards = cards
        self.freeCardsDate = Date()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        cards = aDecoder.decodeObject(forKey: "cards") as? [Int] ?? [10, 5, 3]
        freeCardsDate = aDecoder.decodeObject(forKey: "date") as? Date ?? Date()
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cards, forKey: "cards")
        aCoder.encode(freeCardsDate, forKey: "date")
    }
    
    func addCards(_ n: Int) {
        for _ in 1...n {
            let random = Int(arc4random_uniform(10))
            if random < 5 {
                self.cards[0] += 1
            } else if random < 8 {
                self.cards[1] += 1
            } else {
                self.cards[2] += 1
            }
            
        }
    }
    
    
    
    
    
    
    
}
