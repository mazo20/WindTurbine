//
//  StoreReviewHelper.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 06.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        var appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int ?? 0
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
    }
    static func incrementLevelUpCount() { //called from levelUp()
        var levelUpCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.LEVEL_UP_COUNT) as? Int ?? 0
        levelUpCount += 1
        UserDefaults.standard.set(levelUpCount, forKey: UserDefaultsKeys.LEVEL_UP_COUNT)
    }
    static func checkAndAskForReview() { // called when buyButton is pressed
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        let appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int ?? 1
        let levelUpCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.LEVEL_UP_COUNT) as? Int ?? 1
        
        
        switch (levelUpCount, appOpenCount) {
        case (10, _) where appOpenCount > 10:
            StoreReviewHelper().requestReview()
            incrementLevelUpCount()//This way it won't show the request again until next milestone
        case _ where levelUpCount%20 == 0 || appOpenCount%100 == 0:
            StoreReviewHelper().requestReview()
            incrementLevelUpCount()
        default:
            print("App run count is: \(appOpenCount), level up count is: \(levelUpCount)")
            break
        }
        
    }
    fileprivate func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
