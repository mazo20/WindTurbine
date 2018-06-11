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
    
    var upgrade: Upgrade? {
        didSet {
            guard let upgrade = upgrade else { return }
            titleLabel.text = upgrade.name
            detailLabel.text = "+" + upgrade.value.valueFormatter(ofType: formatterType(rawValue: upgrade.type.rawValue)!)
            emojiLabel.text = upgrade.emoji
            levelView.show()
            levelLabel.text = "\(upgrade.level)"
            buyButton.setImage(nil, for: .normal)
            buyButton.setTitle(upgrade.cost.valueFormatter(ofType: .cost), for: .normal)
            buyButton.addTarget(self, action: #selector(didTapBuyButton(sender:)), for: .touchUpInside)
            if let imageName = upgrade.imageName {
                iconImageView.image = UIImage(imageLiteralResourceName: imageName)
            } else {
                iconImageView.image = nil
            }
        }
    }
    
    var buyScratchCard: BuyScratchCard? {
        didSet {
            guard let card = buyScratchCard else { return }
            detailLabel.text = ""
            emojiLabel.text = ""
            levelView.hide()
            iconImageView.image = #imageLiteral(resourceName: "ScratchCardRandom")
            buyButton.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3176470588, blue: 0.3098039216, alpha: 1)
            titleLabel.text = "\(card.value) cards"
            switch card.type {
            case .date:
                guard let date = card.date else { return }
                buyButton.setImage(nil, for: .normal)
                let time = date.timeIntervalSinceNow
                if time < 0 {
                    buyButton.setTitle("Collect", for: .normal)
                } else {
                    buyButton.setTitle("\(Int(time/60))min", for: .normal)
                }
            case .ad:
                buyButton.setImage(#imageLiteral(resourceName: "AdIcon"), for: .normal)
                buyButton.setTitle("\(card.price)", for: .normal)
            case .lightning:
                buyButton.setImage(#imageLiteral(resourceName: "Lightning"), for: .normal)
                buyButton.setTitle("\(card.price)", for: .normal)
            }
            buyButton.addTarget(self, action: #selector(didTapBuyButton(sender:)), for: .touchUpInside)
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
