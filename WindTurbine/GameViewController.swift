//
//  ViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var moneyLabel: TextLabel!
    @IBOutlet var moneyPerSecLabel: TextLabel!
    @IBOutlet var powerOutputLabel: TextLabel!
    @IBOutlet var windSpeedLabel: TextLabel!
    @IBOutlet var lightningCountView: UIView!
    @IBOutlet var levelView: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var levelProgressView: UIProgressView!
    @IBOutlet var levelUpButton: UIButton!
    @IBOutlet var upgradeView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var windTurbineView: UIView!
    @IBOutlet var closeUpgradeViewButton: UIButton!
    @IBOutlet var tableTitle: UILabel!
    @IBOutlet var segmentedUpgradeControl: UISegmentedControl!
    @IBOutlet var segmentedControlView: UIView!
    var model: Model!
    var upgrades = UpgradeStore().upgrades
    var cardStore: ScratchCardStore {
        return model.cardStore
    }
    var battery: Battery {
        return model.battery
    }
    var currentScratchCard = ScratchCard(level: 1)
    
    @IBAction func upgradeViewButton(_ sender: UIButton) {
        segmentedControlView.isHidden = sender.tag == 0 ? false : true
        tableView.tag = sender.tag
        tableView.reloadData()
        if upgradeView.isHidden { showUpgradeView() }
        if sender.tag == 3 {
            model = Model()
            checkForUpgradeLevels()
            tableView.reloadData()
        }
    }
    @IBAction func changeUpgradeView(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func closeUpgradeView(_ sender: Any) {
        hideUpgradeView()
    }
    
    @IBAction func levelUpButton(_ sender: Any) {
       levelUp()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nibNames = ["UpgradeViewCell", "BatteryLevelCell", "ButtonCell", "ScratchCardCell", "ScratchCardsMenuCell", "ScratchCardBuyCell"]
        for nibName in nibNames {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
        
        checkForUpgradeLevels()
    }
    
    func checkForUpgradeLevels() {
        if model.upgradeLevels.count == 0 {
            for i in 0..<4 {
                let array = [Int](repeating: 1, count: upgrades[i].count)
                model.upgradeLevels.append(array)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let windTurbineV = WindTurbineView(frame: windTurbineView.frame)
        windTurbineV.model = model
        windTurbineView.addSubview(windTurbineV)
        hideUpgradeView()
        lightningCountView.roundCorners(.bottomLeft, radius: 8)
        levelView.roundCorners(.bottomRight, radius: 8)
        levelUpButton.roundCorners(.allCorners, radius: 8)
        
        levelLabel.text = "Lvl \(model.level)"
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTables), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    
    @objc func update() {
        model.update()
        moneyLabel.text = "$\(model.money.numberFormatter(ofType: .balance))"
        moneyPerSecLabel.text = "$\(model.moneyPerSec.numberFormatter(ofType: .income))/s"
        powerOutputLabel.text = "\(model.powerOutput.numberFormatter(ofType: .power))W"
        windSpeedLabel.text = "\(model.windSpeed.numberFormatter(ofType: .income))km/h"
        
        let time = Date().timeIntervalSince(battery.startTime)
        battery.charge = battery.chargingPower*time
        
        updateProgressBar()
        if !upgradeView.isHidden {
            checkForUpgrades()
        }
    }
    
    @objc func updateTables() {
        if !upgradeView.isHidden && tableView.tag == 1 {
            let contentOffset = tableView.contentOffset
            tableView.reloadSections([0], with: .none)
            tableView.contentOffset = contentOffset
        }
    }
    
    
    func updateProgressBar() {
        levelProgressView.setProgress(Float(model.levelProgress/model.levelGoal), animated: true)
        if levelProgressView.progress == 1 {
            levelProgressView.isHidden = true
            levelUpButton.isHidden = false
        }
    }
    
    func checkForUpgrades() {
        guard [0,1].contains(tableView.tag) else { return }
        if tableView.tag == 0 {
            for (i, upgrade) in upgrades[segmentedUpgradeControl.selectedSegmentIndex].enumerated() {
                guard model.money > costForLevel(cost: upgrade.baseCost, multiplier: upgrade.costMult, level: model.upgradeLevels[segmentedUpgradeControl.selectedSegmentIndex][i]), let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as?  UpgradeViewCell else { return }
                cell.buyButton.backgroundColor = #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1)
            }
        } else if tableView.tag == 1 {
            for (i, upgrade) in upgrades[3].enumerated() {
                guard model.money > costForLevel(cost: upgrade.baseCost, multiplier: upgrade.costMult, level: model.upgradeLevels[3][i]), let cell = tableView.cellForRow(at: IndexPath(row: i, section: 1)) as?  UpgradeViewCell else { return }
                cell.buyButton.backgroundColor = #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1)
            }
        }
        
    }
    
    func costForLevel(cost: Double, multiplier: Double, level: Int) -> Double {
        return cost * pow(multiplier,Double(level-1))
    }
    
    func valueForLevel(value: Double, multiplier: Double, level: Int) -> Double {
        return value * pow(multiplier,Double(level/5))
    }
    
    func levelUp() {
        model.level += 1
        model.levelProgress = 0
        levelLabel.text = "Lvl \(model.level)"
        levelUpButton.isHidden = true
        levelProgressView.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        print("Wind turbine tapped")
        model.tapped()
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return upgrades[segmentedUpgradeControl.selectedSegmentIndex].count
        case 1:
            let rows = [3, 2]
            return rows[section]
        case 2:
            let rows = [2, 4]
            return rows[section]
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            return setupBatteryTableView(indexPath: indexPath)
        } else if tableView.tag == 2 {
            return setupScratchCardTableView(indexPath: indexPath)
        }
        var upgrade: Upgrade!
        var level: Int = 0
        var detailValueType = ""
        let type = [" km/h", " W/(km/h)", " $/W"]
        
        let tag = segmentedUpgradeControl.selectedSegmentIndex
        if [0, 1, 2].contains(tag) {
            upgrade = upgrades[tag][indexPath.row]
            level = model.upgradeLevels[tag][indexPath.row]
            detailValueType = type[tag]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
        cell.titleLabel?.text = upgrade.name
        let detail = valueForLevel(value: upgrade.baseValue, multiplier: upgrade.valueMult, level: level)
        cell.detailLabel?.text = "+\(detail.numberFormatter(ofType: .income))" + detailValueType
        cell.emojiLabel.text = upgrade.emoji
        cell.iconImageView.image = nil
        cell.levelLabel.text = "\(level)"
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action: #selector(handleButtonAction(sender:)), for: .touchUpInside)
        let cost = costForLevel(cost: upgrade.baseCost, multiplier: upgrade.costMult, level: level)
        cell.buyButton.setTitle("$\(cost.numberFormatter(ofType: .income))", for: UIControlState.normal)
        cell.buyButton.backgroundColor = model.money > cost ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        return cell
    }
    
    func setupBatteryTableView(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BatteryLevelCell", for: indexPath) as! BatteryLevelCell
                cell.chargeLabel.text = "\(battery.chargePercentage)% ($\((Double(battery.chargePercentage)/100*battery.capacity*model.powerPrice).numberFormatter(ofType: .balance)))"
                cell.chargingPowerLabel.text = "\(battery.chargingPower.numberFormatter(ofType: .power))W"
                cell.capacityLabel.text = "\((battery.capacity/3600).numberFormatter(ofType: .power))Wh ($\((battery.capacity*model.powerPrice).numberFormatter(ofType: .balance)))"
                if battery.chargePercentage < 20 {
                    cell.batteryImageView.image = #imageLiteral(resourceName: "Battery0")
                } else if battery.chargePercentage < 40 {
                    cell.batteryImageView.image = #imageLiteral(resourceName: "Battery25")
                } else if battery.chargePercentage < 60 {
                    cell.batteryImageView.image = #imageLiteral(resourceName: "Battery50")
                } else if battery.chargePercentage < 80 {
                    cell.batteryImageView.image = #imageLiteral(resourceName: "Battery75")
                } else {
                    cell.batteryImageView.image = #imageLiteral(resourceName: "Battery100")
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.button.setTitle("Discharge battery ($\((Double(battery.chargePercentage)/100*battery.capacity*model.powerPrice).numberFormatter(ofType: .balance)))", for: .normal)
                cell.button.setTitleColor(.white, for: .normal)
                cell.button.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
                cell.button.tag = 1
                cell.button.addTarget(self, action: #selector(dischargeBatteryButton(sender:)), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cell.button.setTitle("Discharge battery x2 ($\((Double(battery.chargePercentage)/100*2*battery.capacity*model.powerPrice).numberFormatter(ofType: .balance)))", for: .normal)
                cell.button.setTitleColor(.black, for: .normal)
                cell.button.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8588235294, blue: 0.2941176471, alpha: 1)
                cell.button.tag = 2
                cell.button.addTarget(self, action: #selector(dischargeBatteryButton(sender:)), for: .touchUpInside)
                return cell
            }
        } else {
            let upgrade = upgrades[3][indexPath.row]
            let level = model.upgradeLevels[3][indexPath.row]
            let value = valueForLevel(value: upgrade.baseValue, multiplier: upgrade.valueMult, level: level)
            let unit = indexPath.row == 0 ? "W" : "Wh"
            let cost = costForLevel(cost: upgrade.baseCost, multiplier: upgrade.costMult, level: level)
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
            cell.emojiLabel.text = upgrade.emoji
            cell.iconImageView.image = UIImage(named: upgrade.imageName)
            cell.levelLabel.text = "\(level)"
            cell.detailLabel.text = "+\(value.numberFormatter(ofType: .power))\(unit)"
            cell.titleLabel.text = upgrade.name
            cell.buyButton.tag = indexPath.row
            cell.buyButton.addTarget(self, action: #selector(handleButtonAction(sender:)), for: .touchUpInside)
            cell.buyButton.setTitle("$\(cost.numberFormatter(ofType: .income))", for: .normal)
            cell.buyButton.backgroundColor = model.money > cost ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
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
            cell.scratchCardButton.setImage(UIImage(imageLiteralResourceName: currentScratchCard.imageName), for: .normal)
            cell.scratchCardButton.addTarget(self, action: #selector(cardScratched(sender:)), for: .touchUpInside)
            cell.backgroundButton.setImage(UIImage(imageLiteralResourceName: currentScratchCard.backgroundImageName), for: .normal)
            cell.backgroundButton.addTarget(self, action: #selector(newCard(sender:)), for: .touchUpInside)
            cell.detailLabel.text = "$\(currentScratchCard.prizeValue.numberFormatter(ofType: .balance))"
            cell.scratchCardButton.isHidden = currentScratchCard.isScratched ? true : false
            if cardStore.cards[currentScratchCard.level-1] == 0 {
                cell.scratchCardButton.setImage(#imageLiteral(resourceName: "ScratchCard0"), for: .normal)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScratchCardBuyCell", for: indexPath) as! ScratchCardBuyCell
        cell.button.addTarget(self, action: #selector(handleButtonAction(sender:)), for: .touchUpInside)
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "3 random cards"
            cell.currencyImageView.image = #imageLiteral(resourceName: "AdIcon")
            cell.priceLabel.text = "1"
        case 1:
            cell.titleLabel.text = "12 random cards"
            cell.currencyImageView.image = #imageLiteral(resourceName: "AdIcon")
            cell.priceLabel.text = "3"
        case 2:
            cell.titleLabel.text = "30 random cards"
            cell.currencyImageView.image = #imageLiteral(resourceName: "Lightning")
            cell.priceLabel.text = "5"
        case 3:
            cell.titleLabel.text = "150 random cards"
            cell.currencyImageView.image = #imageLiteral(resourceName: "Lightning")
            cell.priceLabel.text = "20"
        default:
            print("Too much cells")
        }
        
        return cell
    }
    
    @objc func cardScratched(sender: UIButton) {
        guard cardStore.cards[currentScratchCard.level-1] > 0 else { return }
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ScratchCardCell
        cardStore.cards[currentScratchCard.level-1] -= 1
        currentScratchCard.isScratched = true
        cell.scratchCardButton.isHidden = true
        tableView.reloadSections([0], with: .none)
        if currentScratchCard.prizeType == .money {
            model.money += currentScratchCard.prizeValue
        }
    }
    
    @objc func newCard(sender: UIButton) {
        print("asdf")
        currentScratchCard = ScratchCard(level: currentScratchCard.level)
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ScratchCardCell
        cell.scratchCardButton.isHidden = false
    }
    
    @objc func dischargeBatteryButton(sender: UIButton) {
        model.money += Double(battery.chargePercentage)/100*battery.capacity*model.powerPrice * Double(sender.tag)
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
        if tableView.tag == 1 {
            guard model.money > costForLevel(cost: upgrades[3][i].baseCost, multiplier: upgrades[3][i].costMult, level: model.upgradeLevels[3][i]) else { return }
            let value = valueForLevel(value: upgrades[3][i].baseValue, multiplier: upgrades[3][i].valueMult, level: model.upgradeLevels[3][i])
            model.money -= costForLevel(cost: upgrades[3][i].baseCost, multiplier: upgrades[3][i].costMult, level: model.upgradeLevels[3][i])
            model.upgradeLevels[3][i] += 1
            if i == 0 {
                battery.chargingPower += value
            } else {
                battery.capacity += value*3600
            }
        } else if tableView.tag == 2 {
            cardStore.addCards(5)
            tableView.reloadSections([0], with: .none)
        } else {
            let tag = segmentedUpgradeControl.selectedSegmentIndex
            var value: Double = 0
            guard model.money > costForLevel(cost: upgrades[tag][i].baseCost, multiplier: upgrades[tag][i].costMult, level: model.upgradeLevels[tag][i]) else { return }
            if [0,1,2].contains(tag) {
                value = valueForLevel(value: upgrades[tag][i].baseValue, multiplier: upgrades[tag][i].valueMult, level: model.upgradeLevels[tag][i])
                model.money -= costForLevel(cost: upgrades[tag][i].baseCost, multiplier: upgrades[tag][i].costMult, level: model.upgradeLevels[tag][i])
                model.upgradeLevels[tag][i] += 1
            }
            switch tag {
            case 0:
                model.nominalWindSpeed += value
            case 1:
                model.powerConversion += value
            case 2:
                model.powerPrice += value
            default:
                print("Sth wrong")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case 1, 2:
            return 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 && indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 170
            default:
                return 50
            }
        }
        if tableView.tag == 2 && indexPath.section == 0 {
            switch indexPath.row {
            case 0: return 130
            default: return 192
            }
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 && indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 170
            default:
                return 50
            }
        }
        if tableView.tag == 2 && indexPath.section == 0 {
            switch indexPath.row {
            case 0: return 130
            default: return 192
            }
        }
        return 80
    }
}



