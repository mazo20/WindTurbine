//
//  UpgradeView+Animations.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 11.04.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func showUpgradeView() {
        self.upgradeView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.upgradeView.center.y -= self.upgradeView.frame.size.height*3/2
        })
    }
    
    func hideUpgradeView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.upgradeView.center.y += self.upgradeView.frame.size.height*3/2
        }, completion: { (finished) in
            self.upgradeView.isHidden = true
        })
    }
}

