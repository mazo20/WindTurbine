//
//  ButtonCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 03.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet var button: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    var currentAmount: Double = 0.0 {
        didSet {
            if button.tag == 1 {
                button.setTitle("Discharge battery ($\(currentAmount.numberFormatter(ofType: .balance)))", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = ColorScheme.menuColor
            } else {
                button.setTitle("Discharge battery x2 ($\((currentAmount*2).numberFormatter(ofType: .balance)))", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = ColorScheme.buttonColor
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //button.roundCorners(.allCorners, radius: 8)
        
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.setNeedsLayout()
        button.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
