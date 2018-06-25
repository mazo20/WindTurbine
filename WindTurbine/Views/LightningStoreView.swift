//
//  LightningStoreView.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 16.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

protocol LightningStoreViewDelegate {
    func buyLightnings(button: UIButton)
}

class LightningStoreView: UIView {
    
    var delegate: LightningStoreViewDelegate? {
        didSet {
            let products = IAPHandler.shared.products()
            guard products.count == 6 else {
                self.removeFromSuperview()
                return
            }
            let views = [buyView1, buyView2, buyView3, buyView4, buyView5, buyView6]
            let values = [25, 55, 140, 320, 760, 1830]
            let free = [5, 15, 50, 160, 500, 1400]
            
            var price = [String]()
            for product in products {
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                price.append(numberFormatter.string(from: product.price)!)
            }
            
            
            for i in 0..<views.count {
                
                views[i]?.delegate = self.delegate
                views[i]?.buyButton.tag = i+1
                views[i]?.valueLabel.text = "\(values[i])"
                views[i]?.freeValueLabel.text = "(\(free[i]) free)"
                views[i]?.buyButton.setTitle(price[i], for: .normal)
                
            }
        }
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var buyView1: LightningBuyView!
    @IBOutlet var buyView2: LightningBuyView!
    @IBOutlet var buyView3: LightningBuyView!
    @IBOutlet var buyView4: LightningBuyView!
    @IBOutlet var buyView5: LightningBuyView!
    @IBOutlet var buyView6: LightningBuyView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("LightningStoreView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        
        
        
        
        
    }
    
}
