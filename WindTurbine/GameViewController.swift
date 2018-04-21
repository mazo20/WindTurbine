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
    @IBOutlet var windTurbineView: WindTurbineView!
    @IBOutlet var closeUpgradeViewButton: UIButton!
    
    var model: Model!
    var windUpgrades = [Upgrade]()
    var powerUpgrades = [Upgrade]()
    var priceUpgrades = [Upgrade]()
    var upgrades = [[Upgrade]]()
    
    @IBAction func upgradeViewButton(_ sender: UIButton) {
        if upgradeView.isHidden { showUpgradeView() }
        if sender.tag == 3 { model = Model() }
        checkForUpgradeLevels()
        tableView.tag = sender.tag
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
        
        let nib = UINib(nibName: "UpgradeViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpgradeViewCell")
        
        windTurbineView.model = model
        
        addUpgrades()
        
        moneyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular)
        
        checkForUpgradeLevels()
        
    }
    
    func checkForUpgradeLevels() {
        if model.upgradeLevels.count == 0 {
            for i in 0..<3 {
                let array = [Int](repeating: 1, count: upgrades[i].count)
                model.upgradeLevels.append(array)
            }
        }
    }
    
    func addUpgrades() {
        let filenames = ["WindUpgrades", "PowerUpgrades", "PriceUpgrades"]
        for name in filenames {
            if let windDictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: name),
                let upgrades = windDictionary["upgrades"] as? [Dictionary<String, Any>] {
                addUpgradesToArray(upgrades)
            }
        }
    }
    
    func addUpgradesToArray(_ us: [Dictionary<String, Any>]) {
        var upgradeCategory = [Upgrade]()
        for upgrade in us {
            if let emoji = upgrade["emoji"] as? String, let name = upgrade["name"] as? String, let initialCost = upgrade["initialCost"] as? Double, let initialValue = upgrade["initialValue"] as? Double, let costMultiplier = upgrade["costMultiplier"] as? Double, let valueMultiplier = upgrade["valueMultiplier"] as? Double {
                let u = Upgrade(emoji: emoji, name: name, initialCost: initialCost, initialValue: initialValue, costMultiplier: costMultiplier, valueMultiplier: valueMultiplier)
                upgradeCategory.append(u)
            }
        }
        upgrades.append(upgradeCategory)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hideUpgradeView()
        lightningCountView.roundCorners(.bottomLeft, radius: 8)
        levelView.roundCorners(.bottomRight, radius: 8)
        levelUpButton.roundCorners(.allCorners, radius: 8)
        
        levelLabel.text = "Lvl \(model.level)"
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func update() {
        model.update()
        moneyLabel.text = "$\(model.money.moneyFormatter)"
        moneyPerSecLabel.text = "$\(model.moneyPerSec.moneyFormatter)/s"
        powerOutputLabel.text = "\(model.powerOutput.powerFormatter)W"
        windSpeedLabel.text = "\(model.windSpeed.powerFormatter)km/h"
        
        updateProgressBar()
        
        if !upgradeView.isHidden {
            checkForUpgrades()
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
        let tag = tableView.tag
        switch tag {
            case 0, 1, 2:
            for (i, upgrade) in upgrades[tag].enumerated() {
                if model.money > upgrade.initialCost * pow(upgrade.costMultiplier, Double(model.upgradeLevels[tag][i]-1)) {
                    if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as?  UpgradeViewCell {
                        cell.buyButton.backgroundColor = #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1)
                    }
                    
                }
            }
            default:
            print("Something went wrong")
        }
        
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
        case 0, 1, 2:
            return upgrades[tableView.tag].count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var upgrade: Upgrade!
        var level: Int = 0
        var detailValueType = ""
        let type = [" km/h", " W", " $/W"]
        let tag = tableView.tag
        switch tag {
        case 0, 1, 2:
            upgrade = upgrades[tag][indexPath.row]
            level = model.upgradeLevels[tag][indexPath.row]
            detailValueType = type[tag]
        default:
            print("Something went wrong")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeViewCell", for: indexPath) as! UpgradeViewCell
        cell.titleLabel?.text = upgrade.name
        let detail = upgrade.initialValue * pow(upgrade.valueMultiplier,Double(level)-1)
        cell.detailLabel?.text = "+\(detail.powerFormatter)" + detailValueType
        cell.emojiLabel.text = upgrade.emoji
        cell.levelLabel.text = "\(level)"
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action: #selector(handleButtonAction(sender:)), for: .touchUpInside)
        let cost = upgrade.initialCost * pow(upgrade.costMultiplier, Double(level-1))
        cell.buyButton.setTitle("$\(cost.moneyFormatter)", for: UIControlState.normal)
        cell.buyButton.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        return cell
    }
    
    @objc func handleButtonAction(sender: UIButton) {
        let tag = tableView.tag
        let i = sender.tag
        if model.money < upgrades[tag][i].initialCost * pow(upgrades[tag][i].costMultiplier,Double(model.upgradeLevels[tag][i])-1) { return }
        switch tag {
        case 0:
            model.nominalWindSpeed += upgrades[tag][i].initialValue * pow(upgrades[tag][i].valueMultiplier,Double(model.upgradeLevels[tag][i])-1)
            model.money -= upgrades[tag][i].initialCost * pow(upgrades[tag][i].costMultiplier,Double(model.upgradeLevels[tag][i])-1)
            model.upgradeLevels[tag][i] += 1
        case 1:
            model.powerConversion += upgrades[tag][i].initialValue * pow(upgrades[tag][i].valueMultiplier,Double(model.upgradeLevels[tag][i])-1)
            model.money -= upgrades[tag][i].initialCost * pow(upgrades[tag][i].costMultiplier,Double(model.upgradeLevels[tag][i])-1)
            model.upgradeLevels[tag][i] += 1
        case 2:
            model.powerPrice += upgrades[tag][i].initialValue * pow(upgrades[tag][i].valueMultiplier,Double(model.upgradeLevels[tag][i])-1)
            model.money -= upgrades[tag][i].initialCost * pow(upgrades[tag][i].costMultiplier,Double(model.upgradeLevels[tag][i])-1)
            model.upgradeLevels[tag][i] += 1
        default:
            print("Sth wrong")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



