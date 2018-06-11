//
//  OnboardingHelper.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 08.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

enum OnboardingType: Int {
    case upgrades, battery, cards, main1, main2, main3, unknown
    
    fileprivate func key() -> String {
        return "Onboarding_\(rawValue)"
    }
}

struct OnboardingHelper {
    
    
    
    static func isOpeningFirstTime(type: OnboardingType) -> Bool {
        guard type != .unknown else { return false }
        if let bool = UserDefaults.standard.value(forKey: type.key()) as? Bool {
            return bool
        } else {
            UserDefaults.standard.set(false, forKey: type.key())
            return true
        }
    }
    
    static func textFor(type: OnboardingType) -> (title: String, description: String) {
        switch type {
        case .main1:
            return (title: "Welcome to Power!", description: "The wind turbine is producing electricity. Tap the screen to increase wind speed and therefore your income!")
        case .main2:
            return (title: "Welcome to Power!", description: "Buy upgrades to expand your production.\nUse battery and scratch cards for your advantage.")
        case .main3:
            return (title: "Welcome to Power!", description: "Do you have what it take's to power the world?")
        case .upgrades:
            return (title: "Upgrade store", description: "Here you can upgrade your turbine which will greatly increase your income.")
        case .battery:
            return (title: "Battery charging", description: "The battery is charging even when you are not playing. Come back regularly to collect money.")
        case .cards:
            return (title: "Scratch cards", description: "Each card has a prize. You can win a lot, but it will take some time.")
        default:
            return (title: "Unknown", description: "Error occured")
        }
    }
    
}
