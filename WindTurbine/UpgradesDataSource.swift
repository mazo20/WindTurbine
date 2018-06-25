//
//  UpgradesDataSource.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 20.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit
import GoogleMobileAds

class UpgradesDataSource: NSObject, UITableViewDataSource {
    var model: Model?
    var segmentedControlIndex: Int?
    var cellDelegate: UpgradeCellDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case 0:
            return 1
        case 1, 2:
            return 2
        case 3:
            let canRestart = model?.shouldAvailableRestart() ?? false
            return canRestart ? 3 : 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        switch (tableView.tag, section) {
        case (0, _):
            let index = segmentedControlIndex ?? 0
            return model.upgradeStore.upgradesForIncome[index].count
        case (1, 0):
            if model.battery.chargePercentage == 0 { return 1 }
            if GADRewardBasedVideoAd.sharedInstance().isReady { return 3 }
            return 2
        case (1, 1), (2, 0):
            return 2
        case (2, 1):
            return model.upgradeStore.purchaseCards.count
        case (3, 0):
            return model.upgradeStore.menuUpgrades.count
        case (3, 1), (3, 2):
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        switch tableView.tag {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            let index = segmentedControlIndex ?? 0
            let type = [upgradeType.wind, upgradeType.power, upgradeType.price]
            let upgrade = model.upgradeStore.upgradesWithType(type[index])[indexPath.row]
            
            cell.delegate = cellDelegate
            cell.data = UpgradeCellData(upgrade: upgrade)
            cell.buyButton.backgroundColor = model.money > upgrade.cost ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
            return cell
        case 1:
            let battery = model.battery
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BatteryLevelCell", for: indexPath) as! BatteryLevelCell
                    cell.battery = battery
                    cell.powerPrice = sqrt(model.powerPrice)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                    //cell.button.addTarget(self, action: #selector(dischargeBatteryButton(sender:)), for: .touchUpInside)
                    cell.button.tag = indexPath.row
                    let maxAmount = battery.capacity * sqrt(model.powerPrice)
                    let currentAmount = Double(battery.chargePercentage)/100 * maxAmount
                    cell.currentAmount = currentAmount
                    return cell
                }
            } else {
                let upgrade = model.upgradeStore.upgradesForBattery[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
                cell.delegate = cellDelegate
                cell.data = UpgradeCellData(upgrade: upgrade)
                cell.buyButton.backgroundColor = model.money > upgrade.cost ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
                return cell
            }
        case 2:
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScratchCardsMenuCell", for: indexPath) as! ScratchCardsMenuCell
                    //cell.addTargets(self, action: #selector(changeScratchCard(sender:)), for: .touchUpInside)
                    cell.cardNumbers = model.cardStore.cards
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScratchCardCell", for: indexPath) as! ScratchCardCell
                //cell.delegate = cellDelegate
                //cell.currentCard = currentScratchCard
                cell.moneyPerSec = model.moneyPerSec
                //if cardStore.cards[currentScratchCard.level-1] == 0 {
                //    cell.scratchCardButton.setImage(#imageLiteral(resourceName: "ScratchCard0"), for: .normal)
                //}
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.data = UpgradeCellData(upgrade: model.upgradeStore.purchaseCards[indexPath.row])
            cell.buyButton.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
            cell.delegate = cellDelegate
            return cell
        case 3:
            switch (indexPath.section, indexPath.row, model.shouldAvailableRestart()) {
            case (0, _, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
                cell.data = UpgradeCellData(upgrade: model.upgradeStore.menuUpgrades[indexPath.row])
                cell.buyButton.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
                cell.delegate = cellDelegate
                return cell
            case (1, _, false), (2, _, true):
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.textLabel?.text = "Developed by Maciej Kowalski"
                cell.detailTextLabel?.text = "Contact at maciej.kowalski.developer@gmail.com"
                cell.selectionStyle = .none
                return cell
            case (1,_, true):
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.textLabel?.text = "Increase your income for free"
                cell.detailTextLabel?.text = "You have to sacrifice some things, however"
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        default:
            print("Table view tag not handled")
            return UITableViewCell()
        }
    }
    
}
