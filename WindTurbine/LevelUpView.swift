//
//  LevelUpView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 24.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

protocol LevelUpViewDelegate {
    func collectMoney(button: UIButton)
}

class LevelUpView: UIView {
    
    var delegate: LevelUpViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var prizeLabel: UILabel!
    @IBOutlet var collectButton: UIButton!
    @IBOutlet var collectx2Button: UIButton!
    
    @IBAction func collectMoney(_ sender: UIButton) {
        delegate?.collectMoney(button: sender)
    }
    
    var prize: Double! {
        didSet {
            prizeLabel.text = prize.valueFormatter(ofType: .cost)
        }
    }
    
    var levelGoal: Double! {
        didSet {
            prize = levelGoal * Double.random(min: 0.03, max: 0.05)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("LevelUpView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        collectButton.tag = 1
        collectx2Button.tag = 2
    }
    
}
