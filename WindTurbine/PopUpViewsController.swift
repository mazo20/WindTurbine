//
//  PopUpViewsController.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 07.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import UIKit

extension GameViewController: PopUpViewDelegate {
    
    func initPopUpView() -> PopUpView? {
        let frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width*0.7, height: self.view.frame.height*0.5))
        let popUpView = PopUpView(frame: frame)
        popUpView.center = self.view.center
        popUpView.delegate = self
        self.popUpView = popUpView
        showDarkBackgroundView()
        self.view.addSubview(popUpView)
        return popUpView
    }
    
    func hidePopUp(view: PopUpView? = nil) {
        view?.removeFromSuperview()
        popUpView?.removeFromSuperview()
        darkBackgroundView?.removeFromSuperview()
    }
    
    func showDarkBackgroundView() {
        if let view = darkBackgroundView, self.view.subviews.contains(view) { return }
        darkBackgroundView = UIView(frame: self.view.frame)
        darkBackgroundView?.center = self.view.center
        darkBackgroundView?.backgroundColor = .black
        darkBackgroundView?.alpha = 0.75
        self.view.addSubview(darkBackgroundView!)
    }
    
    func showLevelUpView() {
        levelUpPrize = model.levelGoal * Double.random(min: 0.2, max: 0.3)
        guard let view = initPopUpView() else { return }
        view.type = .levelUp
        view.titleLabel.text = "Level up bonus!"
        view.descriptionLabel.text = levelUpPrize.valueFormatter(ofType: .cost)
        view.normalButton.setTitle("Collect", for: .normal)
        view.adButton.setTitle("Collect x2", for: .normal)
        if !isRewardVideoAdReady() {
            view.adButton.removeFromSuperview()
        }
    }
    
    func showRestartGameView() {
        guard let view = initPopUpView() else { return }
        view.type = .restartGame
        view.titleLabel.text = "Start from beggining"
        view.descriptionLabel.text = "Your income will be increased by 20%, but all current progress will be lost"
        view.normalButton.setTitle("Restart", for: .normal)
        view.adButton.setTitle("Keep playing", for: .normal)
    }
    
    @objc func showBonusAdView() {
        guard isRewardVideoAdReady(), let view = initPopUpView() else { return }
        bonusMultiplier = bonusMultiplier ?? BonusMultiplierHelper.getRandomMultiplier()
        view.type = .bonusAd
        view.titleLabel.text = "Get reward!"
        view.descriptionLabel.text = "Increase your income by \(Int((bonusMultiplier!.multiplier-1)*100))% for \(Int(bonusMultiplier!.duration))s"
        view.normalButton.setTitle("No thanks", for: .normal)
        view.adButton.setTitle("Watch video!", for: .normal)
    }
    
    func showOnboardingViewFor(type: OnboardingType) {
        guard type != .unknown else { return }
        let text = OnboardingHelper.textFor(type: type)
        currentOnboardingScene = type
        
        let origin = upgradeView.convert(CGPoint(x: upgradeView.frame.minX+10, y: upgradeView.frame.midY), to: self.view)
        let frame = CGRect(origin: origin, size: CGSize(width: tableView.frame.width-20, height: upgradeView.frame.height/2+tabButton1.frame.height-10))
        let popUpView = PopUpView(frame: frame)
        
        popUpView.delegate = self
        popUpView.titleLabel?.text = text.title
        popUpView.descriptionLabel?.text = text.description
        popUpView.normalButton.removeFromSuperview()
        switch type {
        case .main1, .main2:
            popUpView.adButton.setTitle("Next", for: .normal)
        case .main3:
            popUpView.adButton.setTitle("Start playing", for: .normal)
        default:
            popUpView.adButton.setTitle("OK", for: .normal)
        }
        popUpView.type = .onboarding
        self.popUpView = popUpView
        showDarkBackgroundView()
        self.view.addSubview(popUpView)
    }
    
    func buttonPressed(button: UIButton, view: PopUpView) {
        switch (view.type, button.tag) {
        case (.levelUp, 1):
            collectLevelUpReward(withMultiplier: 1)
        case (.levelUp, 2):
            presentRewardVideoAd(for: .levelUp)
        case (.restartGame, 1):
            model.reset()
            model.incomeMult *= 1.2
            upgradeView.hide()
            hidePopUp(view: view)
        case (.restartGame, 2):
            hidePopUp(view: view)
        case (.bonusAd, 1):
            hideRewardVideoAdButton()
            hidePopUp(view: view)
        case (.bonusAd, 2):
            presentRewardVideoAd(for: .bonusAd)
        case (.onboarding, _):
            hidePopUp(view: view)
            switch currentOnboardingScene {
            case .main1:
                currentOnboardingScene = .main2
                showOnboardingViewFor(type: .main2)
            case .main2:
                currentOnboardingScene = .main3
                showOnboardingViewFor(type: .main3)
            default:
                currentOnboardingScene = .unknown
                print("Shouldn't present any more scenes")
            }
        default:
            print("Case not handled, type: \(view.type), tag: \(button.tag)")
        }
    }
}
