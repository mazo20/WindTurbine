//
//  BonusAdView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

protocol PopUpViewDelegate {
    func buttonPressed(button: UIButton, view: PopUpView)
}

enum PopUpViewType {
    case levelUp, restartGame, bonusAd, onboarding, none
}

class PopUpView: UIView {
    
    var delegate: PopUpViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var greyButton: UIButton!
    @IBOutlet var yellowButton: UIButton!
    
    var type: PopUpViewType = .none
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(button: sender, view: self)
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
        Bundle.main.loadNibNamed("PopUpView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        greyButton.tag = 1
        yellowButton.tag = 2
    }
    
}
