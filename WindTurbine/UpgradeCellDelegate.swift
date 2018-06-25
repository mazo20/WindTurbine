//
//  UpgradeCellDelegate.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 22.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol LightningStorePresenter {
    func present()
}

protocol RewardVideoAdPresenter {
    func present(for: RewardAd)
}


class UpgradeCellDelegate: NSObject, UpgradeViewCellDelegate {
    var model: Model?
    var storePresenter: LightningStorePresenter?
    var rewardAdPresenter: RewardVideoAdPresenter?
    
    func buyButtonPressed(cell: UpgradeViewCell) {
        guard let model = model else { return }
        StoreReviewHelper.checkAndAskForReview()
        if let data = cell.data, let upgrade = model.upgradeStore.upgradesHashDict[data.hashValue],
            upgrade.cost < model.money {
            model.subtractMoney(amount: upgrade.cost)
            switch upgrade.type {
            case .wind:
                model.nominalWindSpeed += upgrade.value
            case .power:
                model.powerConversion += upgrade.value
            case .price:
                model.powerPrice += upgrade.value
            case .charging:
                model.battery.chargingPower += upgrade.value
            case .capacity:
                model.battery.capacity += upgrade.value * 3600
            }
            upgrade.level += 1
        } else if let data = cell.data, let purchase = model.upgradeStore.extraUpgradesHashDict[data.hashValue]{
            switch (purchase.priceType, purchase.rewardType) {
            case (.lightning, _):
                guard purchase.price < model.lightnings else {
                    storePresenter?.present()
                    break
                }
                model.lightnings -= purchase.price
                switch purchase.rewardType {
                case .card:
                    model.cardStore.addCards(purchase.rewardValue)
                case .balance:
                    let income = purchase.income ?? 1
                    model.addMoney(amount: Double(purchase.rewardValue) * income)
                case .income:
                    model.incomeMult *= Double(purchase.rewardValue)
                default:
                    print("Reward type: \(purchase.rewardType) not handled")
                }
            case (.date, .card):
                let date = UserDefaults.standard.value(forKey: "freeCardsDate") as? Date ?? Date()
                let time = date.timeIntervalSinceNow
                if time < 0 {
                    UserDefaults.standard.set(Date(timeIntervalSinceNow: 3605), forKey: "freeCardsDate")
                    model.cardStore.addCards(purchase.rewardValue)
                } else {
                    cell.buyButton.shake()
                }
            case (.ad, .card):
                rewardAdPresenter?.present(for: .addCards)
                //if rewardAdDelegate.isRewardVideoAdReady() {
                //    presentRewardVideoAd(for: .addCards)
                //} else {
                //    cell.buyButton.shake()
                //}
            default:
                print("Unknown purchase")
            }
        } else {
            cell.buyButton.shake()
        }
        //tableView.reloadData()
    }
    
}
