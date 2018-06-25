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
    
    var bonusAdButton: ExtraButton?
    var gameCenterButton: ExtraButton?
    
    var storeView: LightningStoreView?
    var popUpView: PopUpView?
    var darkBackgroundView: UIView?
    
    var purchaseIndex: Int?
    
    var didAddBackground = false
    
    var levelUpPrize = 0.0
    var bonusMultiplier: (multiplier: Double, duration: TimeInterval)?
    
    var currentRewardAd = RewardAd.none
    var currentOnboardingScene = OnboardingType.unknown
    var bonusAdDate = Date()
    
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
        let title = ["Buy upgrades to earn more", "Battery charges when you aren't playing", "Test your luck with scratch cards", "Menu"]
        tableTitle.text = title[sender.tag]
        tableView.tag = sender.tag
        
        tableView.reloadDataWithAutoSizingCellWorkAround()
        upgradeView.show()
        
        setTabButtonsWhite()
        sender.setImage(UIImage(imageLiteralResourceName: "TabButton\(sender.tag+1)Yellow"), for: .normal)
        
        if [0, 1, 2].contains(sender.tag) {
           shouldShowOnboardingViewFor(value: sender.tag)
        }
    }
    
    func shouldShowOnboardingViewFor(value: Int) {
        let type = OnboardingType(rawValue: value) ?? OnboardingType.unknown
        if OnboardingHelper.isOpeningFirstTime(type: type) {
            showOnboardingViewFor(type: type)
        }
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
        
        let nibNames = ["UpgradeViewCell", "BatteryLevelCell", "ButtonCell", "ScratchCardCell", "ScratchCardsMenuCell", "ScratchCardBuyCell"]
        for nibName in nibNames {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
        
        //nibNames.map { tableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)}
        
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
    }
    
    override func viewDidLayoutSubviews() {
        lightningCountView.roundCorners(.bottomLeft, radius: 8)
        levelView.roundCorners(.bottomRight, radius: 8)
        levelUpButton.roundCorners(.allCorners, radius: 8)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !didAddBackground {
            initCloudView(cloudView)
            initTurbineView()
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
        levelProgressView.setProgress(Float(model.levelProgress/model.levelGoal), animated: true)
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
        model.level += 1
        model.levelProgress = 0
        model.lightnings += 1
        levelUpButton.hide()
        levelProgressView.show()
        StoreReviewHelper.incrementLevelUpCount()
    }
    
    func dischargeBattery(withMultiplier x: Double) {
        model.addMoney(amount: battery.discharge() * model.powerPrice * x)
        tableView.reloadSections([0], with: .none)
    }
    
    func collectLevelUpReward(withMultiplier x: Double) {
        model.addMoney(amount: levelUpPrize * x)
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

