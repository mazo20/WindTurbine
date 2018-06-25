//
//  UpgradesDelegate.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 22.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class UpgradesDelegate: NSObject, UITableViewDelegate, BatteryDelegate {
    func battery(_ battery: Battery, willDischarge charge: Double) {
        print("Will discharge with value \(charge)")
    }
    
    
}
