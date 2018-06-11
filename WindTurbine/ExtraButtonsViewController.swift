//
//  File.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension GameViewController {
    
    struct Size {
        static var width: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 60
            }
            return 40
        }
        static var height: CGFloat {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 60
            }
            return 40
        }
    }
    
    
    func enableGameCenterButton() {
        guard gameCenterButton == nil else {
            print("Game center button already shown")
            return
        }
        let button = ExtraButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: Size.width, height: Size.height))
        button.center = CGPoint(x: windTurbineView.frame.minX-Size.width, y: windTurbineView.frame.maxY-Size.height)
        button.setImage(#imageLiteral(resourceName: "LeaderboardIcon"), for: .normal)
        button.addTarget(self, action: #selector(showGameCenterButton), for: .touchUpInside)
        button.layer.zPosition = 4
        windTurbineView.addSubview(button)
        UIView.animate(withDuration: 0.5, animations: {
            button.center.x = self.windTurbineView.frame.minX + Size.width
            })
        gameCenterButton = button
        print("Game Center button enabled")
    }
    
    func showRewardVideoAdButton() {
        guard bonusAdButton == nil else {
            print("Reward ad button already shown")
            return
        }
        guard Date() > bonusAdDate else {
            print("Cannot show ad yet, need to wait \(bonusAdDate.timeIntervalSinceNow)s")
            return
        }
        let button = ExtraButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: Size.width, height: Size.height))
        button.setImage(#imageLiteral(resourceName: "AdIcon"), for: .normal)
        button.center = CGPoint(x: windTurbineView.frame.maxX + Size.width, y: windTurbineView.frame.maxY - Size.height)
        button.addTarget(self, action: #selector(showBonusAdView), for: .touchUpInside)
        button.layer.zPosition = 4
        windTurbineView.addSubview(button)
        UIView.animate(withDuration: 0.5, animations: {
            button.center.x = self.windTurbineView.frame.maxX - Size.width
        })
        bonusAdButton = button
        print("Bonus ad button enabled")
    }
    
    func hideRewardVideoAdButton() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bonusAdButton?.center.x = self.windTurbineView.frame.maxX + Size.width
        }, completion: { _ in
            self.bonusAdButton?.removeFromSuperview()
            self.bonusAdButton = nil
            self.bonusAdDate = Date(timeIntervalSinceNow: 600)
            let _ = Timer.scheduledTimer(withTimeInterval: 601, repeats: false, block: { _ in
                self.showRewardVideoAdButton()
            })
        })
    }
    
    @objc func showGameCenterButton() {
        showGameCenter()
    }
    
}
