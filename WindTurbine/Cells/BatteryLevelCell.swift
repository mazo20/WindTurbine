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
    @IBOutlet var chargeLabel: UILabel!
    @IBOutlet var chargingPowerLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
    
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
