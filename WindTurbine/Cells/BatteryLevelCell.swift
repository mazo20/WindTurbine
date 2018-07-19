//
//  BatteryLevelCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class BatteryLevelCell: UITableViewCell {
    
    @IBOutlet var batteryImageView: UIImageView!
    @IBOutlet var batteryFillImageView: UIImageView!
    @IBOutlet var chargeLabel: UILabel!
    @IBOutlet var chargingPowerLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
    
    var battery: Battery? {
        didSet {
            updateValues()
        }
    }
    
    var powerPrice: Double? {
        didSet {
            updateValues()
        }
    }
    
    func updateValues() {
        guard let battery = battery, let price = powerPrice else { return }
        let maxAmount = battery.capacity * price
        let currentAmount = Double(battery.chargePercentage)/100 * maxAmount
        chargeLabel.text = "\(battery.chargePercentage)% ($\(currentAmount.numberFormatter(ofType: .balance)))"
        chargingPowerLabel.text = battery.chargingPower.valueFormatter(ofType: .power)
        capacityLabel.text = (battery.capacity/3600).valueFormatter(ofType: .capacity) + " (\(maxAmount.valueFormatter(ofType: .balance)))"
        batteryImageView.image = #imageLiteral(resourceName: "Battery0")
        batteryFillImageView.tintColor = ColorScheme.labelColor
        if battery.chargePercentage < 20 {
            batteryFillImageView.image = nil
        } else if battery.chargePercentage < 40 {
            batteryFillImageView.image = #imageLiteral(resourceName: "BatteryFill25")
        } else if battery.chargePercentage < 60 {
            batteryFillImageView.image = #imageLiteral(resourceName: "BatteryFill50")
        } else if battery.chargePercentage < 80 {
            batteryFillImageView.image = #imageLiteral(resourceName: "BatteryFill75")
        } else {
            batteryFillImageView.image = #imageLiteral(resourceName: "BatteryFill100")
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
