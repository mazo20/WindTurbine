//
//  UpgradeViewCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 12.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class UpgradeViewCell: UITableViewCell {
    
    
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var levelView: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buyButton.layer.cornerRadius = 8
        levelView.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
