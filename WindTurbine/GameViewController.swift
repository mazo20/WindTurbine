//
//  ViewController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit
import Firebase
import StoreKit

class GameViewController: UIViewController {
    
    @IBOutlet var statsView: StatsView!
    @IBOutlet var topBarView: UIView!
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
    
    var tabButtons = [UIButton]()
    
    var bonusAdButton: ExtraButton?
    var gameCenterButton: ExtraButton?
    
    var storeView: LightningStoreView?
    var popUpView: PopUpView?
    var turbineView: TurbineView?
    var darkBackgroundView: UIView?
    
    var purchaseIndex: Int?
    
    var didAddBackground = false
    
    var levelUpPrize = 0.0
    var bonusMultiplier: (multiplier: Double, duration: TimeInterval)?
    
    var currentRewardAd = RewardAd.none
    var currentOnboardingScene = OnboardingType.unknown
    var bonusAdDate = Date()
    var sessionStartTime = Date()
    
    var gcEnabled = false // Stores if the user has Game Center enabled
    
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
        let title = ["Buy upgrades to earn more", "Battery charges when you aren't playing", "Test your luck with scratch cards", "Menu - extra upgrades"]
        tableTitle.text = title[sender.tag]
        tableView.tag = sender.tag
        
        tableView.reloadDataWithAutoSizingCellWorkAround()
        upgradeView.show()
        
        //Set sender button to theme color and other to white
        setTabButtonsWhite()
        sender.tintColor = ColorScheme.buttonColor
        
        if [0, 1, 2].contains(sender.tag) {
           shouldShowOnboardingViewFor(value: sender.tag)
        }
        switch sender.tag {
        case 0:
            Analytics.logEvent("upgrades_view", parameters: nil)
        case 1:
            Analytics.logEvent("battery_view", parameters: nil)
        case 2:
            Analytics.logEvent("cards_view", parameters: nil)
        case 3:
            Analytics.logEvent("menu_view", parameters: nil)
        default:
            print("Error: button tag too big")
        }
    }
    
    func shouldShowOnboardingViewFor(value: Int) {
        let type = OnboardingType(rawValue: value) ?? OnboardingType.unknown
        if OnboardingHelper.isOpeningFirstTime(type: type) {
            showOnboardingViewFor(type: type)
        }
    }
    
    func setTabButtonsWhite() {
        tabButtons.forEach { $0.tintColor = .white }
    }
    
    @IBAction func changeUpgradeView(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func closeUpgradeView(_ sender: Any) {
        upgradeView.hide()
        setTabButtonsWhite()
    }
    
    @IBAction func levelUpButton(_ sender: Any) {
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
        guard IAPHandler.shared.productsAreReady() else { return }
        showDarkBackgroundView()
        
        let frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width*0.85, height: self.view.frame.height*0.6))
        storeView = LightningStoreView(frame: frame)
        storeView?.delegate = self
        storeView?.center = self.view.center
        storeView?.closeButton.addTarget(self, action: #selector(closeStoreView), for: .touchUpInside)
        self.view.addSubview(storeView!)
        storeView?.layoutSubviews()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TESTING GITHUB FOR WOJTEK
        print("blablaalba")
        
        let nibNames = ["UpgradeViewCell", "BatteryLevelCell", "ButtonCell", "ScratchCardCell", "ScratchCardsMenuCell", "ScratchCardBuyCell"]
        for nibName in nibNames {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
        
        setUpViewsColor()
        
        let updateModelTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        let updateTablesTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateTables), userInfo: nil, repeats: true)
        updateModelTimer.tolerance = 0.05
        updateTablesTimer.tolerance = 1
        RunLoop.main.add(updateModelTimer, forMode: .commonModes)
        
        
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                if let index = strongSelf.purchaseIndex {
                    strongSelf.model.lightnings += IAPHandler.shared.PURCHASE_VALUES[index]
                    Analytics.logEvent("in-app-purchase", parameters: ["purchase_index": index+1])
                }
                
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
                
                
            }
            strongSelf.purchaseIndex = nil
        }
        
        authenticateLocalPlayer()
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        loadRewardVideoAd()
        upgradeView.hide()
        
        print(model.levelGoal)
    }
    
    func setUpViewsColor() {
        tabButtons = [tabButton1, tabButton2, tabButton3, tabButton4]
        setTabButtonsWhite()
        levelUpButton.setTitleColor(ColorScheme.buttonColor, for: .normal)
        levelProgressView.progressTintColor = ColorScheme.buttonColor
        segmentedUpgradeControl.tintColor = ColorScheme.buttonColor
        closeUpgradeViewButton.tintColor = ColorScheme.buttonColor
        statsView.backgroundColor = ColorScheme.backgroundColor
        topBarView.backgroundColor = ColorScheme.backgroundColor
        turbineView?.backHill?.tintColor = ColorScheme.backHillColor
        turbineView?.frontHill?.tintColor = ColorScheme.frontHillColor
        cloudView.backgroundColor = ColorScheme.backgroundColor
        statsView.tintColor = ColorScheme.labelColor
    }
    
    override func viewDidLayoutSubviews() {
        lightningCountView.roundCorners(.bottomLeft, radius: 8)
        levelView.roundCorners(.bottomRight, radius: 8)
        levelUpButton.roundCorners(.allCorners, radius: 8)
        levelProgressView.roundCorners(.allCorners, radius: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !didAddBackground {
            turbineView = TurbineView(frame: windTurbineView.frame)
            turbineView!.model = model
            windTurbineView.addSubview(turbineView!)
            initCloudView(cloudView)
            didAddBackground = true
            
            shouldShowOnboardingViewFor(value: 3) //main1 onboarding
            IAPHandler.shared.fetchAvailableProducts()
        }
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
        } else if !upgradeView.isHidden && tableView.tag == 2 {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }
    
    
    func updateProgressBar() {
        levelProgressView.setProgress(Float(model.levelProgress/model.levelGoal), animated: false)
        if levelProgressView.progress == 1 {
            levelProgressView.hide()
            levelUpButton.show()
        }
    }
    
    func checkForUpgrades() {
        for case let cell as UpgradeViewCell in tableView.visibleCells {
            guard let upgrade = model.upgradeStore.upgrades.first(where: {$0.hashValue == cell.data?.hashValue}) else { return }
            cell.buyButton.backgroundColor = upgrade.cost < model.money ? #colorLiteral(red: 0.1457930078, green: 0.764910063, blue: 0.2355007071, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        }
    }
    
    func levelUp() {
        model.levelUp()
        levelUpButton.hide()
        levelProgressView.show()
        StoreReviewHelper.incrementLevelUpCount()
    }
    
    func dischargeBattery(withMultiplier x: Double) {
        let percent = battery.chargePercentage
        let money = battery.discharge() * sqrt(model.powerPrice) * x
        print(money)
        model.addMoney(amount: money)
        let timeSinceSessionStart = Date().timeIntervalSince(sessionStartTime)
        Analytics.logEvent("discharge_battery", parameters: ["time_since_start": "\(timeSinceSessionStart/60)m",
                                                             "doubled_by_ad": x == 2 ? "yes" : "no",
                                                             "battery_percentage": percent,
                                                             "discharge_value": "$\(Int(money))",
                                                             "level": model.level])
        tableView.reloadSections([0], with: .none)
    }
    
    func collectLevelUpReward(withMultiplier x: Double) {
        model.addMoney(amount: levelUpPrize * x)
        Analytics.logEvent("level_up", parameters: ["level": model.level,
                                                    "doubled_by_ad": x == 2 ? "yes" : "no",
                                                    "income": model.moneyPerSec,
                                                    "income_multiplier" : model.incomeMult])
        levelUp()
        hidePopUp()
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

extension GameViewController: LightningStoreViewDelegate {
    func buyLightnings(button: UIButton) {
        purchaseIndex = button.tag-1
        IAPHandler.shared.purchaseMyProduct(index: purchaseIndex!)
    }
}

