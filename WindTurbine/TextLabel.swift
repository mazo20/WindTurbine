//
//  TextLabel.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 18.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

@IBDesignable
class TextLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
}
