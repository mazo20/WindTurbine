//
//  BalanceAndValuesView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 23.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class StatsView: UIView {
    
    @IBOutlet var balanceLabel: TextLabel!
    @IBOutlet var moneyPerSecLabel: TextLabel!
    @IBOutlet var powerLabel: TextLabel!
    @IBOutlet var windSpeedLabel: TextLabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("StatsView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            balanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .regular)
        } else {
            balanceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 35, weight: .regular)
        }
    }
    
}
