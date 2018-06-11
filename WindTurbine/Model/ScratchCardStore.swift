//
//  ScratchCardStore.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 10.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

enum priceType: String {
    case ad, lightning, date
}

class BuyScratchCard {
    
    var type: priceType
    var value: Int
    var price: Int
    var date: Date?
    
    init(type: priceType, value: Int, price: Int, date: Date? = nil) {
        self.type = type
        self.value = value
        self.price = price
        self.date = date
    }
}

class ScratchCardStore: NSObject, NSCoding {
    
    var cards: [Int]!
    var freeCardsDate: Date
    var buyScratchCards = [BuyScratchCard]()
    
    convenience override init() {
        self.init(cards: [10, 5, 3])
    }
    
    init(cards: [Int]) {
        self.cards = cards
        self.freeCardsDate = Date()
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        cards = aDecoder.decodeObject(forKey: "cards") as? [Int] ?? [10, 5, 3]
        freeCardsDate = aDecoder.decodeObject(forKey: "date") as? Date ?? Date()
        super.init()
        commonInit()
    }
    
    func commonInit() {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: "BuyScratchCards") {
            if let buyCards = dictionary["buyCards"] as? [Dictionary<String, Any>] {
                for card in buyCards {
                    guard let typeString = card["priceType"] as? String,
                        let type = priceType(rawValue: typeString),
                        let value = card["value"] as? Int,
                        let price = card["price"] as? Int else { continue }
                    if type == .date {
                        let buyScratchCard = BuyScratchCard(type: type, value: value, price: price, date: freeCardsDate)
                        buyScratchCards.append(buyScratchCard)
                    } else {
                        let buyScratchCard = BuyScratchCard(type: type, value: value, price: price)
                        buyScratchCards.append(buyScratchCard)
                    }
                }
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cards, forKey: "cards")
        aCoder.encode(freeCardsDate, forKey: "date")
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
