//
//  GameKitManager.swift
//  論理ゲーム
//
//  Created by 森居麗 on 2018/05/27.
//  Copyright © 2018年 森居麗. All rights reserved.
//

import UIKit
import GameKit
class GameKitManager: NSObject,GKGameCenterControllerDelegate {
    private static let leaderboardID = "LogicalRate"
    
    private static let manager = GameKitManager()
    
    class func getInstance() -> GameKitManager {
        return GameKitManager.manager
    }
   private(set) var localPlayer: GKLocalPlayer
    
    private weak var rootViewController: UIViewController!
    
    override private init() {
        self.localPlayer = GKLocalPlayer.localPlayer()
        self.rootViewController = nil
        super.init()
    }
   func login(rootViewController: UIViewController) {
        self.localPlayer = GKLocalPlayer.localPlayer()
        self.localPlayer.authenticateHandler = {(loginViewController, error) in
            if loginViewController != nil {
                rootViewController.present(loginViewController!, animated: true, completion: nil)
            }
        }
    }
    func reportScore(point: Int) {
        let score = GKScore(leaderboardIdentifier: GameKitManager.leaderboardID)
        score.value = Int64(point)
        GKScore.report([score], withCompletionHandler: nil)
    }
    func showLeaderboard(rootViewController: UIViewController) {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.leaderboardIdentifier = GameKitManager.leaderboardID
        gameCenterViewController.gameCenterDelegate = self
        self.rootViewController = rootViewController  // to dismiss gameCenterViewController
        rootViewController.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        if self.rootViewController != nil {
            self.rootViewController.dismiss(animated: true, completion: nil)
            self.rootViewController = nil
        }
    }
}

