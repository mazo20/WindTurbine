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
    
    @IBOutlet var buyButton: BuyButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var levelView: UIView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var iconImageView: ScaledWidthImageView!
    
    var data: UpgradeCellData? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.titleText
            detailLabel.text = data.detailText
            emojiLabel.text = data.emoji
            levelLabel.text = data.level
            levelView.isHidden = data.level == nil ? true : false
            buyButton.setImage(data.buttonImage, for: .normal)
            buyButton.setTitle(data.buttonTitle, for: .normal)
            buyButton.backgroundColor = data.buttonColor
            buyButton.addTarget(self, action: #selector(didTapBuyButton(sender:)), for: .touchUpInside)
            iconImageView.image = data.iconImage
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
