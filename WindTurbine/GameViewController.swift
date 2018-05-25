//
//  ViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var statsView: StatsView!
    @IBOutlet var lightningCountView: UIView!
    @IBOutlet var levelView: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var lightningLabel: UILabel!
    @IBOutlet var levelProgressView: UIProgressView!
    @IBOutlet var levelUpButton: UIButton!
    @IBOutlet var cloudView: UIView!
    @IBOutlet var upgradeView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var windTurbineView: UIView!
    @IBOutlet var closeUpgradeViewButton: UIButton!
    @IBOutlet var tableTitle: UILabel!
    @IBOutlet var segmentedUpgradeControl: UISegmentedControl!
    @IBOutlet var segmentedControlView: UIView!
    
    @IBOutlet var tabButton1: UIButton!
    @IBOutlet var tabButton2: UIButton!
    @IBOutlet var tabButton3: UIButton!
    @IBOutlet var tabButton4: UIButton!
    
    var storeView: LightningStoreView?
    var levelUpView: LevelUpView?
    var darkBackgroundView: UIView?
    var upgrades: [[Upgrade]] {
        get {
            return model.upgrades
        }
    }
    var model: Model!
    var cardStore: ScratchCardStore {
        return model.cardStore
    }
    var battery: Battery {
        return model.battery
    }
    var currentScratchCard = ScratchCard(level: 1)
    
    @IBAction func upgradeViewButton(_ sender: UIButton) {
        segmentedControlView.isHidden = sender.tag == 0 ? false : true
        let title = ["Buy upgrades to earn more", "Battery charges when you aren't playing", "Test your luck with scratch cards", "Menu"]
        tableTitle.text = title[sender.tag]
        tableView.tag = sender.tag
        tableView.reloadData()
        upgradeView.show()
        setTabButtonsWhite()
        sender.setImage(UIImage(imageLiteralResourceName: "TabButton\(sender.tag+1)Yellow"), for: .normal)
    }
    
    func setTabButtonsWhite() {
        tabButton1.setImage(UIImage(imageLiteralResourceName: "TabButton1White"), for: .normal)
        tabButton2.setImage(UIImage(imageLiteralResourceName: "TabButton2White"), for: .normal)
        tabButton3.setImage(UIImage(imageLiteralResourceName: "TabButton3White"), for: .normal)
        tabButton4.setImage(UIImage(imageLiteralResourceName: "TabButton4White"), for: .normal)
        
    }
    
    @IBAction func changeUpgradeView(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func closeUpgradeView(_ sender: Any) {
        upgradeView.hide()
        setTabButtonsWhite()
    }
    
    @IBAction func levelUpButton(_ sender: Any) {
        levelUp()
        showLevelUpView()
    }
    
    @IBAction func buyLightningsButton(_ sender: Any) {
        showStoreView()
    }
    
    @objc func closeStoreView() {
        self.storeView?.removeFromSuperview()
        self.darkBackgroundView?.removeFromSuperview()
    }
    
    func showStoreView() {
        showDarkBackgroundView()
        
        let frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width*0.8, height: self.view.frame.height*0.6))
        storeView = LightningStoreView(frame: frame)
        storeView?.delegate = self
        storeView?.center = self.view.center
        storeView?.closeButton.addTarget(self, action: #selector(closeStoreView), for: .touchUpInside)
        self.view.addSubview(storeView!)
    }
    
    func showLevelUpView() {
        showDarkBackgroundView()
        
        let frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width*0.7, height: self.view.frame.height*0.5))
        levelUpView = LevelUpView(frame: frame)
        levelUpView?.center = self.view.center
        levelUpView?.delegate = self
        levelUpView?.levelGoal = model.levelGoal
        self.view.addSubview(levelUpView!)
    }
    
    func showDarkBackgroundView() {
        darkBackgroundView = UIView(frame: self.view.frame)
        darkBackgroundView?.center = self.view.center
        darkBackgroundView?.backgroundColor = .black
        darkBackgroundView?.alpha = 0.8
        self.view.addSubview(darkBackgroundView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibNames = ["UpgradeViewCell", "BatteryLevelCell", "ButtonCell", "ScratchCardCell", "ScratchCardsMenuCell", "ScratchCardBuyCell"]
        for nibName in nibNames {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initCloudView(cloudView)
        initTurbineView()
        
        upgradeView.hide()
        
        lightningCountView.roundCorners(.bottomLeft, radius: 8)
        levelView.roundCorners(.bottomRight, radius: 8)
        levelUpButton.roundCorners(.allCorners, radius: 8)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTables), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    
    @objc func update() {
        model.update()
        
        statsView.balanceLabel.text = "$\(model.money.numberFormatter(ofType: .balance))"
        statsView.moneyPerSecLabel.text = "$\(model.moneyPerSec.numberFormatter(ofType: .income))/s"
        statsView.windSpeedLabel.text = "\(model.windSpeed.numberFormatter(ofType: .income))km/h"
        statsView.powerLabel.text = "\(model.powerOutput.numberFormatter(ofType: .power))W"
        lightningLabel.text = "\(model.lightnings)"
        levelLabel.text = "Lvl \(model.level)"
        
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
        let tag = tableView.tag == 0 ? segmentedUpgradeControl.selectedSegmentIndex : 3
        for (i, upgrade) in upgrades[tag].enumerated() where upgrade.cost < model.money {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: tableView.tag)) as?  UpgradeViewCell else { return }
            cell.buyButton.backgroundColor = #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1)
        }
    }
    
    func levelUp() {
        model.level += 1
        model.levelProgress = 0
        model.lightnings += 1
        levelUpButton.hide()
        levelProgressView.show()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        model.tapped()
    }
}

extension GameViewController: LevelUpViewDelegate {
    func collectMoney(button: UIButton) {
        model.money += levelUpView!.prize * Double(button.tag)
        levelUpView?.removeFromSuperview()
        darkBackgroundView?.removeFromSuperview()
    }
}

extension GameViewController: LightningStoreViewDelegate {
    func buyLightnings(button: UIButton) {
        let values = [5, 12, 29, 52, 89, 180]
        model.lightnings += values[button.tag-1]
        storeView?.removeFromSuperview()
        darkBackgroundView?.removeFromSuperview()
    }
    

}
