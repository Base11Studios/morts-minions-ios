//
//  ChallengeType.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/12/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

enum ChallengeType: String {
    case OneHeartLeft = "OneHeartLeft" // Make it to end of level with 1 heart left
    case NoHeartsCollected = "NoHeartsCollected" // Make it to the end of the level with 0 hearts collected
    case FullHealth = "FullHealth" // Make it to the end of level with full health
    case OneHundredPercent = "OneHundredPercent" // Complete 100% of the level - collect all minion hearts and travel complete distance
    case OhSoClose = "OhSoClose" // Collect 100% of the minion hearts but don't reach the end of the level
    case DestroyAllObstacles = "DestroyAllObstacles" // Destroy all the obstacles that are destroyable in the level
    case DontTouchObstacles = "DontTouchObstacles" // Dont touch any of the obstacles in the level
    case DontTouchProjectiles = "DontTouchProjectiles"
    case DontTouchEnemies = "DontTouchEnemies"
    case DieByObstacles = "DieByObstacles"
    case DieByProjectiles = "DieByProjectiles"
    case DieByEnemies = "DieByEnemies"
    case ReachEndOfLevel = "ReachEndOfLevel"
    case Score3Stars = "Score3Stars"
    case Score80Percent = "Score80Percent"
    case Collect75PercentHearts = "Collect75PercentHearts"
    case DontTouchAnything = "DontTouchAnything"
    //case EveryOtherEnemy = "EveryOtherEnemy" // Collect a minion heart from every other enemy you encounter. Position first shown on screen determines order.
    
    func getDescription() -> String {
        switch self {
        case .OneHeartLeft:
            return "Reach the end with 1 health left"
        case .NoHeartsCollected:
            return "Reach the end without freeing any minion hearts"
        case .FullHealth:
            return "Reach the end with full health"
        case .OneHundredPercent:
            return "Get a score of 100%"
        case .OhSoClose:
            return "Don't reach the end but collect all the minion hearts"
        case .DieByObstacles:
            return "Lose all your health by obstacles only"
        case .DieByProjectiles:
            return "Lose your last health by a projectile"
        case .DieByEnemies:
            return "Lose all your health by minions only"
        case .DontTouchObstacles:
            return "Reach the end without touching an obstacle"
        case .DontTouchProjectiles:
            return "Reach the end without touching a projectile"
        case .DontTouchEnemies:
            return "Reach the end without touching a minion"
        case .ReachEndOfLevel:
            return "Reach the end of the level"
        case .Score3Stars:
            return "Earn 3 stars"
        case .Score80Percent:
            return "Get a score of 80%"
        case .Collect75PercentHearts:
            return "Free at least 75% of the minion hearts"
        case .DestroyAllObstacles:
            return "Destroy all destructible obstacles"
        case .DontTouchAnything:
            return "Reach the end without touching anything"
        }
    }
}
