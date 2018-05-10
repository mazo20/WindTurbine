//
//  ScratchCardsMenuCell.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 04.05.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

class ScratchCardsMenuCell: UITableViewCell {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var level1CountLabel: UILabel!
    @IBOutlet var level2CountLabel: UILabel!
    @IBOutlet var level3CountLabel: UILabel!
    
    var cardNumbers: [Int] = [0,0,0] {
        didSet {
            level1CountLabel.text = "\(cardNumbers[0])"
            level2CountLabel.text = "\(cardNumbers[1])"
            level3CountLabel.text = "\(cardNumbers[2])"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button1.tag = 1
        button2.tag = 2
        button3.tag = 3
        
        
    }
    
    func addTargets(_ target: Any?, action: Selector, for event: UIControlEvents) {
        button1.addTarget(target, action: action, for: event)
        button2.addTarget(target, action: action, for: event)
        button3.addTarget(target, action: action, for: event)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        
    }
    
}
