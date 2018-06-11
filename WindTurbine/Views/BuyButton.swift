//
//  BuyButton.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 06.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class BuyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setImage(_ image: UIImage?, for state: UIControlState) {
        super.setImage(image, for: state)
        if let _ = image {
            if UIDevice.current.userInterfaceIdiom == .pad {
                imageEdgeInsets = UIEdgeInsetsMake(8.5, 22, 8.5, 68)
                titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0)
            } else {
                imageEdgeInsets = UIEdgeInsetsMake(7, 15, 7, 55)
                titleEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0)
            }
            
        } else {
            imageEdgeInsets = .zero
            titleEdgeInsets = .zero
        }
    }
    
    
    
}
