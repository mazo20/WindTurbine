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
        let bestScoreInt = GKScore(leaderboardIdentifier: GameCenterIdentifiers.POWER_TOTAL_MONEY)
        bestScoreInt.value = Int64(model.totalMoney)
        GKScore.report([bestScoreInt]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Best score (\(bestScoreInt.value)) submitted to your Leaderboard!")
            }
        }
    }
    
    func showGameCenter() {
        submitScoreToGameCenter()
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
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
