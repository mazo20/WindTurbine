//
//  ScratchCardStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

enum priceType: String {
    case ad, lightning
}

struct BuyScratchCard {
    
    var type: priceType
    var value: Int
    var price: Int
    
    init(type: priceType, value: Int, price: Int) {
        self.type = type
        self.value = value
        self.price = price
    }
}

class ScratchCardStore: NSObject, NSCoding {
    
    var cards: [Int]!
    var buyScratchCards = [BuyScratchCard]()
    
    convenience override init() {
        self.init(cards: [10, 5, 3])
    }
    
    init(cards: [Int]) {
        super.init()
        self.cards = cards
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let cards = aDecoder.decodeObject(forKey: "cards") as? [Int] {
            self.cards = cards
        } else {
            self.cards = [10, 5, 3]
        }
        commonInit()
    }
    
    func commonInit() {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: "BuyScratchCards") {
            if let buyCards = dictionary["buyCards"] as? [Dictionary<String, Any>] {
                for card in buyCards {
                    if let type = card["priceType"] as? String,
                        let value = card["value"] as? Int,
                        let price = card["price"] as? Int {
                        let buyScratchCard = BuyScratchCard(type: priceType(rawValue: type)!, value: value, price: price)
                        buyScratchCards.append(buyScratchCard)
                    }
                }
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cards, forKey: "cards")
    }
    
    func addCards(_ n: Int) {
        for _ in 1...n {
            let random = Int(arc4random_uniform(6))
            if random < 3 {
                self.cards[0] += 1
            } else if random < 5 {
                self.cards[1] += 1
            } else {
                self.cards[2] += 1
            }
            
        }
    }
    
    
    
    
    
    
    
}
