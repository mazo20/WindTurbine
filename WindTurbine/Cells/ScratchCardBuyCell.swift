//
//  ScratchCardBuyCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 06.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class ScratchCardBuyCell: UITableViewCell {
    
    @IBOutlet var scratchCardImageView: ScaledWidthImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var button: BuyButton!
    @IBOutlet var buttonView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.roundCorners(.allCorners, radius: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        
    }
    
}
