//
//  ExtraUpgrade.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 12.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

enum UpgradePriceType: String {
    case ad, lightning, date, unknown
}

enum RewardType: String {
    case card, income, wind, balance
}

class ExtraUpgrade: NSObject {
    
    var priceType: UpgradePriceType
    var rewardType: RewardType
    var rewardValue: Int
    var price: Int
    var imageName: String?
    var emoji: String?
    var date: Date?
    var income: Double?
    
    init(rewardType: RewardType, value: Int, priceType: UpgradePriceType, price: Int, emoji: String? = nil, imageName: String? = nil) {
        self.rewardType = rewardType
        self.priceType = priceType
        self.rewardValue = value
        self.price = price
        self.imageName = imageName
        self.emoji = emoji
    }
}
