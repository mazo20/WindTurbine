//
//  UpgradeViewCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 12.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

protocol UpgradeViewCellDelegate: class {
    func buyButtonPressed(cell: UpgradeViewCell)
}

class UpgradeViewCell: UITableViewCell {
    
    var delegate: UpgradeViewCellDelegate?
    
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var levelView: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    var upgrade: Upgrade! {
        didSet {
            titleLabel.text = upgrade.name
            detailLabel.text = "+" + upgrade.value.valueFormatter(ofType: upgrade.type)
            emojiLabel.text = upgrade.emoji
            levelLabel.text = "\(upgrade.level)"
            buyButton.setTitle(upgrade.cost.valueFormatter(ofType: .cost), for: .normal)
            buyButton.addTarget(self, action: #selector(didTapBuyButton(sender:)), for: .touchUpInside)
            if let imageName = upgrade.imageName {
                iconImageView.image = UIImage(imageLiteralResourceName: imageName)
            } else {
                iconImageView.image = nil
            }
        }
    }
    
    @objc func didTapBuyButton(sender: UIButton) {
        delegate?.buyButtonPressed(cell: self)
    }
    
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
