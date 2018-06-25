//
//  UpgradeCellData.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 12.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

struct UpgradeCellData {
    var titleText: String?
    var detailText: String?
    var emoji: String?
    var level: String?
    var buttonImage: UIImage?
    var buttonTitle: String?
    var buttonColor: UIColor?
    var iconImage: UIImage?
    var hashValue: Int
    
    init(upgrade: Upgrade) {
        hashValue = upgrade.hashValue
        titleText = upgrade.name
        detailText = "+" + upgrade.value.valueFormatter(ofType: formatterType(rawValue: upgrade.type.rawValue)!)
        emoji = upgrade.emoji
        level = "\(upgrade.level)"
        buttonImage = nil
        buttonColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        buttonTitle = upgrade.cost.valueFormatter(ofType: .cost)
        if let imageName = upgrade.imageName {
            iconImage = UIImage(imageLiteralResourceName: imageName)
        } else {
            iconImage = nil
        }
    }
    
    init(upgrade: ExtraUpgrade) {
        hashValue = upgrade.hashValue
        buttonColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        emoji = upgrade.emoji
        
        switch upgrade.priceType {
        case .ad:
            buttonImage = #imageLiteral(resourceName: "AdIcon")
            buttonTitle = "\(upgrade.price)"
        case .lightning:
            buttonImage = #imageLiteral(resourceName: "Lightning")
            buttonTitle = "\(upgrade.price)"
        case .date:
            let date = UserDefaults.standard.value(forKey: "freeCardsDate") as? Date ?? Date(timeIntervalSinceNow: -1)
            let time = date.timeIntervalSinceNow
            buttonTitle = time < 0 ? "Collect" : "\(Int(time/60))min"
        default:
            print("Price type: \(upgrade.priceType) not handled")
        }
        
        switch upgrade.rewardType {
        case .card:
            titleText = "\(upgrade.rewardValue) cards"
            iconImage = #imageLiteral(resourceName: "ScratchCardRandom")
        case .income:
            titleText = "\(upgrade.rewardValue)x income increase"
            emoji = upgrade.emoji
        case .balance:
            let income = upgrade.income ?? 1.0
            titleText = "\((Double(upgrade.rewardValue) * income).valueFormatter(ofType: .income)) instantly"
        default:
            print("Reward type: \(upgrade.rewardValue) not handled")
        }
        
        
        
    }
}
