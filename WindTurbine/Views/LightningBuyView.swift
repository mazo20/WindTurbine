//
//  LightningBuyView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 16.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class LightningBuyView: UIView {
    
    var delegate: LightningStoreViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var freeValueLabel: UILabel!
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        delegate?.buyLightnings(button: sender)
        print("buttonPressed")
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
        Bundle.main.loadNibNamed("LightningBuyView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func layoutSubviews() {
        buyButton.roundCorners(.allCorners, radius: 8)
        //priceLabel.layer.cornerRadius = 8
        //priceLabel.layer.borderWidth = 2
        //priceLabel.layer.borderColor = UIColor.yellow.cgColor
    }
    
}
