//
//  TableViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 23.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit
import Firebase


extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 || tableView.tag == 3 { return 1 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return model.upgradeStore.upgradesForIncome()[segmentedUpgradeControl.selectedSegmentIndex].count
        case 1:
            if section == 0 && battery.chargePercentage == 0 { return 1 }
            if section == 0 && GADRewardBasedVideoAd.sharedInstance().isReady { return 3 }
            return 2
        case 2:
            let rows = [2, cardStore.buyScratchCards.count]
            return rows[section]
        default:
            return model.level > model.numberOfRestarts + 2 ? 2 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            return setupBatteryTableView(indexPath: indexPath)
        } else if tableView.tag == 2 {
            return setupScratchCardTableView(indexPath: indexPath)
        } else if tableView.tag == 3 {
            return setupSettingsView(indexPath: indexPath)
        } else {
            return setupUpgradesTableView(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 3 && indexPath.row == 1 {
            //Start playing from the start
            showRestartGameView()
        }
    }
    
    func setupUpgradesTableView(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
        let tag = segmentedUpgradeControl.selectedSegmentIndex
        let type = [upgradeType.wind, upgradeType.power, upgradeType.price]
        let upgrade = model.upgradeStore.upgradesWithType(type[tag])[indexPath.row]
        
        cell.delegate = self
        cell.upgrade = upgrade
        cell.buyScratchCard = nil
        cell.buyButton.tag = indexPath.row
        cell.buyButton.backgroundColor = model.money > upgrade.cost ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        return cell
    }
    
    func setupBatteryTableView(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BatteryLevelCell", for: indexPath) as! BatteryLevelCell
                cell.battery = battery
                cell.powerPrice = sqrt(model.powerPrice)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.button.addTarget(self, action: #selector(dischargeBatteryButton(sender:)), for: .touchUpInside)
                cell.button.tag = indexPath.row
                let maxAmount = battery.capacity * sqrt(model.powerPrice)
                let currentAmount = Double(battery.chargePercentage)/100 * maxAmount
                cell.currentAmount = currentAmount
                return cell
            }
        } else {
            let upgrade = model.upgradeStore.upgradesForBattery()[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.delegate = self
            cell.upgrade = upgrade
            cell.buyScratchCard = nil
            cell.buyButton.tag = indexPath.row
            cell.buyButton.backgroundColor = model.money > upgrade.cost ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
            return cell
        }
    }
    
    func setupScratchCardTableView(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScratchCardsMenuCell", for: indexPath) as! ScratchCardsMenuCell
                cell.addTargets(self, action: #selector(changeScratchCard(sender:)), for: .touchUpInside)
                cell.cardNumbers = cardStore.cards
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScratchCardCell", for: indexPath) as! ScratchCardCell
            cell.delegate = self
            cell.currentCard = currentScratchCard
            cell.moneyPerSec = model.moneyPerSec
            if cardStore.cards[currentScratchCard.level-1] == 0 {
                cell.scratchCardButton.setImage(#imageLiteral(resourceName: "ScratchCard0"), for: .normal)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
        cell.upgrade = nil
        cell.buyScratchCard = cardStore.buyScratchCards[indexPath.row]
        cell.buyButton.tag = indexPath.row
        cell.buyButton.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        cell.delegate = self
        return cell
    }
    
    func setupSettingsView(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        if indexPath.row == 1 {
            cell.textLabel?.text = "Start from beggining"
            cell.detailTextLabel?.text = "Get a bonus"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.text = "Created by"
            cell.detailTextLabel?.text = "Maciej Kowalski"
        }
        return cell
    }
    
    @objc func dischargeBatteryButton(sender: UIButton) {
        if sender.tag == 2 {
            presentRewardVideoAd(for: .battery)
        } else {
            dischargeBattery(withMultiplier: 1)
        }
    }
    
    @objc func changeScratchCard(sender: UIButton) {
        currentScratchCard.level = sender.tag
        currentScratchCard = ScratchCard(level: sender.tag)
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeightFor(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeightFor(tableView, indexPath: indexPath)
    }
    
    func rowHeightFor(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        switch (tableView.tag, indexPath.section, indexPath.row) {
        case (1, 0, 0):
            height = 170
        case (1, 0, _):
            height = 50
        case (2, 0, 0):
            height = 145
        case (2, 0, 1):
            height = 180
        default:
            height = 80
        }
        return UIDevice.current.userInterfaceIdiom == .pad ? height * 1.3 : height
    }
}

extension GameViewController: UpgradeViewCellDelegate {
    func buyButtonPressed(cell: UpgradeViewCell) {
        StoreReviewHelper.checkAndAskForReview()
        if let upgrade = cell.upgrade, upgrade.cost < model.money {
            model.subtractMoney(amount: upgrade.cost)
            switch upgrade.type {
            case .wind:
                model.nominalWindSpeed += upgrade.value
            case .power:
                model.powerConversion += upgrade.value
            case .price:
                model.powerPrice += upgrade.value
            case .charging:
                battery.chargingPower += upgrade.value
            case .capacity:
                battery.capacity += upgrade.value * 3600
            }
            upgrade.level += 1
        } else if let purchase = cell.buyScratchCard {
            switch purchase.type {
            case .lightning:
                if purchase.price > model.lightnings {
                    showStoreView()
                } else {
                    model.lightnings -= purchase.price
                    cardStore.addCards(purchase.value)
                }
            case .date:
                guard let date = purchase.date, date.timeIntervalSinceNow < 0 else {
                    cell.buyButton.shake()
                    return }
                purchase.date = Date(timeIntervalSinceNow: 3605)
                cardStore.freeCardsDate = Date(timeIntervalSinceNow: 3605)
                cardStore.addCards(purchase.value)
            case .ad:
                if isRewardVideoAdReady() {
                    presentRewardVideoAd(for: .addCards)
                } else {
                    cell.buyButton.shake()
                }
            }
        } else {
            cell.buyButton.shake()
        }
        tableView.reloadData()
    }
}

extension GameViewController: ScratchCardCellDelegate {
    func cardScratched(cell: ScratchCardCell) {
        guard cardStore.cards[currentScratchCard.level-1] > 0 else {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
            return
        }
        cardStore.cards[currentScratchCard.level-1] -= 1
        currentScratchCard.isScratched = true
        cell.scratchCardButton.hide()
        tableView.reloadSections([0], with: .none)
        if currentScratchCard.prizeType == .money {
            model.addMoney(amount: cell.currentCard!.prizeValue * cell.moneyPerSec!)
        }
    }
    
    func showNewCard(cell: ScratchCardCell) {
        currentScratchCard = ScratchCard(level: currentScratchCard.level)
        cell.scratchCardButton.show()
        tableView.reloadSections([0], with: .none)
    }
}


