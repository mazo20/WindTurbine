//
//  WindTurbine.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import Foundation

class WindTurbine {
    
    var bladesRPM: Double = 0
    var powerOutput: Double = 0
    var wind: Wind!
    
    init() {
        wind = Wind()
    }
    
}
