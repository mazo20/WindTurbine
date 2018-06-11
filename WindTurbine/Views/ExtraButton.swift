//
//  ExtraButton.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class ExtraButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners(.allCorners, radius: frame.size.height/4)
        self.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
        clipsToBounds = true
        let inset = frame.size.height/8
        imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
    }
}
