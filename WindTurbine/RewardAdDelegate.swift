//
//  RewardAdDelegate.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 06.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit
import Firebase

extension GameViewController: GADRewardBasedVideoAdDelegate {
    
    enum RewardAd {
        case battery, levelUp, addCards, bonusAd, none
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        /*
        switch currentRewardAd {
        case .battery:
            dischargeBattery(withMultiplier: 2)
        case .levelUp:
            collectLevelUpReward(withMultiplier: 2)
        case .addCards:
            cardStore.addCards(5)
        case .bonusAd:
            hidePopUp()
            guard let bonus = bonusMultiplier else { return }
            model.multiplyIncome(by: bonus.multiplier, duration: bonus.duration)
            bonusMultiplier = nil
            hideRewardVideoAdButton()
        case .none:
            print("reward not set")
        }
        */
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        switch currentRewardAd {
        case .battery:
            dischargeBattery(withMultiplier: 2)
        case .levelUp:
            collectLevelUpReward(withMultiplier: 2)
        case .addCards:
            cardStore.addCards(5)
        case .bonusAd:
            hidePopUp()
            guard let bonus = bonusMultiplier else { return }
            model.multiplyIncome(by: bonus.multiplier, duration: bonus.duration)
            bonusMultiplier = nil
            hideRewardVideoAdButton()
        case .none:
            print("reward not set")
        }
        currentRewardAd = .none
        loadRewardVideoAd()
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        if !tableView.isHidden {
            //tableView.reloadDataWithAutoSizingCellWorkAround()
            //tableView.reloadSections([0], with: .none)
            tableView.reloadSections([0], with: .automatic)
            tableView.reloadSections([0], with: .automatic)
        }
        showRewardVideoAdButton()
    }
    
    func loadRewardVideoAd() {
        let request = GADRequest()
        request.testDevices = ["1f6002c7d5c2f1b6ccf6cad047464c74"]
        request.keywords = ["idle", "game"]
        //GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-2381874254836236/8164754698")
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
    }
    
    func isRewardVideoAdReady() -> Bool {
        return GADRewardBasedVideoAd.sharedInstance().isReady
    }
    
    func presentRewardVideoAd(for type: RewardAd) {
        if isRewardVideoAdReady() {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            currentRewardAd = type
        }
        
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward failed to load: \(error). Will try again in 10 sec")
        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            self.loadRewardVideoAd()
        })
        
    }
    
}