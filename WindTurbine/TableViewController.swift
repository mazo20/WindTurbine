//
//  TableViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 23.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 || tableView.tag == 3 { return 1 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return upgrades[segmentedUpgradeControl.selectedSegmentIndex].count
        case 1:
            let rows = [3, 2]
            return rows[section]
        case 2:
            let rows = [2, cardStore.buyScratchCards.count]
            return rows[section]
        default:
            return 2
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
        if tableView.tag == 3 && indexPath.row == 0 {
            //Start playing from the start
            model.reset()
            tableView.reloadData()
        }
    }
    
    func setupUpgradesTableView(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
        let tag = segmentedUpgradeControl.selectedSegmentIndex
        let upgrade = upgrades[tag][indexPath.row]
        
        cell.delegate = self
        cell.upgrade = upgrade
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
            let upgrade = upgrades[3][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.delegate = self
            cell.upgrade = upgrade
            cell.buyButton.tag = indexPath.row
            cell.buyButton.addTarget(self, action: #selector(handleButtonAction(sender:)), for: .touchUpInside)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScratchCardBuyCell", for: indexPath) as! ScratchCardBuyCell
        cell.button.addTarget(self, action: #selector(handleButtonAction(sender:)), for: .touchUpInside)
        cell.button.tag = indexPath.row
        cell.scratchCardImageView.image = #imageLiteral(resourceName: "ScratchCardRandom")
        cell.titleLabel.text = "\(cardStore.buyScratchCards[indexPath.row].value) cards"
        cell.currencyImageView.image = cardStore.buyScratchCards[indexPath.row].type == .ad ? #imageLiteral(resourceName: "AdIcon") : #imageLiteral(resourceName: "Lightning")
        cell.priceLabel.text = "\(cardStore.buyScratchCards[indexPath.row].price)"
        return cell
    }
    
    func setupSettingsView(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Start from beggining"
            cell.detailTextLabel?.text = "Will delete your progress"
        } else {
            cell.textLabel?.text = "Created by"
            cell.detailTextLabel?.text = "Maciej Kowalski"
        }
        return cell
    }
    
    @objc func dischargeBatteryButton(sender: UIButton) {
        model.money += Double(battery.chargePercentage)/100*battery.capacity*sqrt(model.powerPrice) * Double(sender.tag)
        battery.charge = 0
        battery.startTime = Date()
        tableView.reloadSections([0], with: .none)
    }
    
    @objc func changeScratchCard(sender: UIButton) {
        currentScratchCard.level = sender.tag
        currentScratchCard = ScratchCard(level: sender.tag)
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
    
    @objc func handleButtonAction(sender: UIButton) {
        let i = sender.tag
        if tableView.tag == 2 {
            let card = cardStore.buyScratchCards[i]
            if card.type == .lightning && card.price > model.lightnings {
                showStoreView()
                return
            }
            if card.type == .lightning { model.lightnings -= card.price }
            cardStore.addCards(cardStore.buyScratchCards[i].value)
            tableView.reloadSections([0], with: .none)
        }
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        if tableView.tag == 1 && indexPath.section == 0 {
            switch indexPath.row {
            case 0: height = 170
            default: height = 50
            }
        } else if tableView.tag == 2 && indexPath.section == 0 {
            switch indexPath.row {
            case 0: height = 130
            default: height = 192
            }
        } else {
            height = 80
        }
        return UIDevice.current.userInterfaceIdiom == .pad ? height*2 : height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        if tableView.tag == 1 && indexPath.section == 0 {
            switch indexPath.row {
            case 0: height = 170
            default: height = 50
            }
        } else if tableView.tag == 2 && indexPath.section == 0 {
            switch indexPath.row {
            case 0: height = 130
            default: height = 192
            }
        } else {
            height = 80
        }
        return UIDevice.current.userInterfaceIdiom == .pad ? height*2 : height
    }
}

extension GameViewController: UpgradeViewCellDelegate {
    func buyButtonPressed(cell: UpgradeViewCell) {
        if tableView.tag == 0 {
            let tag = segmentedUpgradeControl.selectedSegmentIndex
            let upgrade = cell.upgrade!
            guard model.money > upgrade.cost else { return }
            model.money -= upgrade.cost
            upgrade.level += 1
            if let level = model.upgradeStore.upgradeLevels[upgrade.emoji] {
                model.upgradeStore.upgradeLevels[upgrade.emoji] = level+1
            }
            if tag == 0 { model.nominalWindSpeed += upgrade.value }
            if tag == 1 { model.powerConversion += upgrade.value }
            if tag == 2 { model.powerPrice += upgrade.value }
        } else if tableView.tag == 1 {
            let upgrade = cell.upgrade!
            guard model.money > upgrade.cost else { return }
            model.money -= upgrade.cost
            guard let index = tableView.indexPath(for: cell)?.row else { return }
            if index == 0 {
                battery.chargingPower += upgrade.value
            } else {
                battery.capacity += upgrade.value * 3600
            }
            upgrade.level += 1
            if let level = model.upgradeStore.upgradeLevels[upgrade.emoji] {
                model.upgradeStore.upgradeLevels[upgrade.emoji] = level+1
            }
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
            model.money += cell.currentCard!.prizeValue * cell.moneyPerSec!
        }
    }
    
    func showNewCard(cell: ScratchCardCell) {
        currentScratchCard = ScratchCard(level: currentScratchCard.level)
        cell.scratchCardButton.show()
        tableView.reloadSections([0], with: .none)
    }
}


