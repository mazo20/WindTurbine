//
//  GameCenterControllerDelegate.swift
//  WindTurbine
//
//  Created by Maciej Kowalski on 05.06.2018.
//  Copyright © 2018 Maciej Kowalski. All rights reserved.
//

import GameKit

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func submitScoreToGameCenter() {
        var report = [GKScore]()
        let totalMoney = GKScore(leaderboardIdentifier: GameCenterIdentifiers.POWER_TOTAL_MONEY)
        totalMoney.value = Int64(model.totalMoney)
        let maxLevel = GKScore(leaderboardIdentifier: GameCenterIdentifiers.MAX_LEVEL)
        maxLevel.value = Int64(model.maxLevel)
        report.append(totalMoney)
        report.append(maxLevel)
        if let planet1value = model.planetTotalMoney[0] {
            let planet1 = GKScore(leaderboardIdentifier: GameCenterIdentifiers.PLANET_1)
            planet1.value = Int64(planet1value)
            report.append(planet1)
        }
        if let planet2value = model.planetTotalMoney[1] {
            let planet2 = GKScore(leaderboardIdentifier: GameCenterIdentifiers.PLANET_2)
            planet2.value = Int64(planet2value)
            report.append(planet2)
        }
        if let planet3value = model.planetTotalMoney[2] {
            let planet3 = GKScore(leaderboardIdentifier: GameCenterIdentifiers.PLANET_3)
            planet3.value = Int64(planet3value)
            report.append(planet3)
        }
        
        GKScore.report(report) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Total money: \(totalMoney.value), max level: \(maxLevel.value) - submitted to your Leaderboard!")
            }
        }
    }
    
    func showGameCenter() {
        submitScoreToGameCenter()
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .default
        gcVC.leaderboardIdentifier = GameCenterIdentifiers.POWER_TOTAL_MONEY
        present(gcVC, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if let viewController = viewController { // Show login for Game Center
                self.present(viewController, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                self.enableGameCenterButton()
            } else {
                self.gcEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
}
