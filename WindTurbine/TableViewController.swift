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
        switch tableView.tag {
        case 0: return 1
        case 1, 2: return 2
        case 3: return 3
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return model.upgradeStore.upgradesForIncome[segmentedUpgradeControl.selectedSegmentIndex].count
        case 1:
            if section == 0 && battery.chargePercentage == 0 { return 1 }
            if section == 0 && GADRewardBasedVideoAd.sharedInstance().isReady { return 3 }
            return 2
        case 2:
            let rows = [2, model.upgradeStore.purchaseCards.count]
            return rows[section]
        default:
            if section == 0 { return model.upgradeStore.menuUpgrades.count }
            else if section == 1 {
                var rows = 0
                if model.shouldAvailableRestart() { rows += 1}
                if GameLevel.canMoveToNewPlanet() { rows += 1}
                return rows
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard tableView.tag == 2 && section == 1 else { return nil }
        return "Chance to get a card:\nLvl1: 50%, lvl2: 30%, lvl3: 20%\nPrize is income multiplied by:\nLvl1: 60% - 3x, 25% - 9x, 10% - 27x, 5% - 81x\nLvl2: 60% - 9x, 25% - 27x, 10% - 81x, 5% - 243x\nLvl3: 60% - 27x, 25% - 81x, 10% - 243x, 5% - 729x"
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
        if model.shouldAvailableRestart() && tableView.tag == 3 && indexPath.section == 1 && indexPath.row == 1 {
            showRestartGameView()
        }
        if model.shouldAvailableRestart() && tableView.tag == 3 && indexPath.section == 1 && indexPath.row == 0 && !GameLevel.canMoveToNewPlanet() {
            showRestartGameView()
        }
    }
    
    func setupUpgradesTableView(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
        let tag = segmentedUpgradeControl.selectedSegmentIndex
        let type = [upgradeType.wind, upgradeType.power, upgradeType.price]
        let upgrade = model.upgradeStore.upgradesWithType(type[tag])[indexPath.row]
        
        cell.delegate = self
        cell.data = UpgradeCellData(upgrade: upgrade)
        if indexPath.row > 0 {
            let previousUpgrade = model.upgradeStore.upgradesWithType(type[tag])[indexPath.row-1]
            if previousUpgrade.level == 1 {
                cell.data = UpgradeCellData()
            }
        }
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
            let upgrade = model.upgradeStore.upgradesForBattery[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.delegate = self
            cell.data = UpgradeCellData(upgrade: upgrade)
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
        cell.data = UpgradeCellData(upgrade: model.upgradeStore.purchaseCards[indexPath.row])
        cell.buyButton.tag = indexPath.row
        cell.buyButton.backgroundColor = ColorScheme.menuColor
        cell.delegate = self
        return cell
    }
    
    func setupSettingsView(indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.data = UpgradeCellData(upgrade: model.upgradeStore.menuUpgrades[indexPath.row])
            cell.selectionStyle = .none
            cell.buyButton.backgroundColor = ColorScheme.menuColor
            cell.delegate = self
            return cell
        case (1, 0):
            if !GameLevel.canMoveToNewPlanet() { fallthrough }
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.selectionStyle = .none
            let upgrades = model.upgradeStore.extraUpgrades.filter {$0.rewardType == .restart}
            let upgrade = upgrades[GameLevel.getPlanet().rawValue]
            cell.data = UpgradeCellData(upgrade: upgrade)
            cell.buyButton.backgroundColor = ColorScheme.menuColor
            cell.delegate = self
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "Increase your income for free"
            cell.detailTextLabel?.text = "You have to sacrifice some things, however"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        case (2, 0):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "Developed by Maciej Kowalski"
            cell.detailTextLabel?.text = "Contact at maciej.kowalski.developer@gmail.com"
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
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
        if let data = cell.data, let hashValue = data.hashValue, let upgrade = model.upgradeStore.upgradesHashDict[hashValue],
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
                battery.chargingPower += upgrade.value
            case .capacity:
                battery.capacity += upgrade.value * 3600
            }
            upgrade.level += 1
        } else if let data = cell.data, let hashValue = data.hashValue, let purchase = model.upgradeStore.extraUpgradesHashDict[hashValue]{
            switch (purchase.priceType, purchase.rewardType) {
            case (.lightning, .card):
                guard purchase.price < model.lightnings else { showStoreView(); break }
                model.spendLightnings(amount: purchase.price)
                cardStore.addCards(purchase.rewardValue)
            case (.lightning, .balance):
                guard purchase.price < model.lightnings else { showStoreView(); break }
                model.spendLightnings(amount: purchase.price)
                let income = purchase.income ?? 1
                model.addMoney(amount: Double(purchase.rewardValue) * income)
            case (.lightning, .income):
                guard purchase.price < model.lightnings else { showStoreView(); break }
                model.spendLightnings(amount: purchase.price)
                model.incomeMult *= Double(purchase.rewardValue)
            case (.date, .card):
                let date = UserDefaults.standard.value(forKey: "freeCardsDate") as? Date ?? Date()
                let time = date.timeIntervalSinceNow
                if time < 0 {
                    UserDefaults.standard.set(Date(timeIntervalSinceNow: 3605), forKey: "freeCardsDate")
                    cardStore.addCards(purchase.rewardValue)
                } else {
                    cell.buyButton.shake()
                }
            case (.ad, .card):
                if isRewardVideoAdReady() {
                    presentRewardVideoAd(for: .addCards)
                } else {
                    cell.buyButton.shake()
                }
            case (.balance, .restart):
                guard Double(purchase.price) < model.money else { cell.buyButton.shake() ; return }
                model.subtractMoney(amount: Double(purchase.price))
                if GameLevel.moveToNewPlanet() {
                    model.newPlanet()
                    setUpViewsColor()
                    closeUpgradeView(cell.buyButton)
                }
            default:
                print("Unknown purchase")
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


