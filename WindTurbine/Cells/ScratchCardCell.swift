//
//  ScratchCardCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

protocol ScratchCardCellDelegate {
    func cardScratched(cell: ScratchCardCell)
    func showNewCard(cell: ScratchCardCell)
}

class ScratchCardCell: UITableViewCell {
    
    var delegate: ScratchCardCellDelegate?
    
    @IBOutlet var scratchCardButton: UIButton!
    @IBOutlet var backgroundButton: UIButton!
    @IBOutlet var detailLabel: UILabel!
    
    @IBAction func cardScratched(_ sender: Any) {
        delegate?.cardScratched(cell: self)
    }
    
    @IBAction func showNewCard(_ sender: Any) {
        delegate?.showNewCard(cell: self)
    }
    
    var currentCard: ScratchCard? {
        didSet {
            updateViews()
        }
    }
    
    var moneyPerSec: Double? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let card = currentCard, let money = moneyPerSec else { return }
        scratchCardButton.setImage(UIImage(imageLiteralResourceName: card.imageName), for: .normal)
        backgroundButton.setImage(UIImage(imageLiteralResourceName: card.backgroundImageName), for: .normal)
        detailLabel.text = "$\((card.prizeValue * money).numberFormatter(ofType: .balance))"
        scratchCardButton.isHidden = card.isScratched ? true : false
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
