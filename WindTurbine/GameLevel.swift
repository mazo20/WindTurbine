//
//  GameLevel.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 02.07.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

struct GameLevel {
    
    enum Planet: Int {
        case earth
        case moon
        case mars
    }
    
    static func getPlanet() -> Planet {
        let rawValue = UserDefaults.standard.value(forKey: UserDefaultsKeys.GAME_LEVEL) as? Int ?? 0
        return Planet(rawValue: rawValue) ?? .earth
    }
    
    static func canMoveToNewPlanet() -> Bool {
        let currentPlanet = getPlanet()
        let nextPlanet = Planet(rawValue: currentPlanet.rawValue+1)
        return nextPlanet != nil
    }
    
    static func moveToNewPlanet() -> Bool {
        let currentPlanet = getPlanet()
        let nextPlanet = Planet(rawValue: currentPlanet.rawValue+1)
        
        guard let planet = nextPlanet else { return false }
        UserDefaults.standard.setValue(planet.rawValue, forKey: UserDefaultsKeys.GAME_LEVEL)
        return true
    }
    
    static var planetMult: Double {
        return pow(5.0, Double(getPlanet().rawValue))
    }
    
}
