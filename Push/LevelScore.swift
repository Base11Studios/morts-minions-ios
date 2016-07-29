//
//  LevelScore.swift
//  Push
//
//  Created by Dan Bellinski on 10/23/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class LevelScore {
    // Player scores
    var heartsCollected: Int = 0
    var distanceTraveled: CGFloat = 0
    
    // Level stats
    var maxHeartsToCollect: Int = 0
    var maxDistanceToTravel: CGFloat = 0
    
    // Calculated scores
    var heartsCollectedPercent: CGFloat = 0
    var distanceTraveledPercent: CGFloat = 0
    var totalCompletePercent: CGFloat = 0
    var starsRewarded: Int = 0 // This is the total of stars for the round
    var newStarsEarned: Int = 0 // This is NEW stars, not total stars
    var previousStarsEarned: Int = 0
    var citrineRewarded: Int = 0 // This is the total # of citrine for the round
    var newCitrineEarned: Int = 0 // This is NEW citrine, not total citrine
    var previousCitrineEarned: Int = 0
    var heartsRemaining: Int = 0
    
    // World and level
    var worldNumber: Int = 0
    var levelNumber: Int = 0
    
    init(heartsCollected: Int, maxHeartsToCollect: Int, distanceTraveled: CGFloat, maxDistanceToTravel: CGFloat, heartsCollectedPercent: CGFloat, distanceTraveledPercent: CGFloat, totalCompletePercent: CGFloat, starsRewarded: Int = 0, newStarsEarned: Int = 0, previousStarsEarned: Int, citrineRewarded: Int = 0, newCitrineEarned: Int, previousCitrineEarned: Int, heartsRemaining: Int, worldNumber: Int, levelNumber: Int) {
        self.heartsCollected = heartsCollected
        self.maxHeartsToCollect = maxHeartsToCollect
        self.distanceTraveled = distanceTraveled
        self.maxDistanceToTravel = maxDistanceToTravel
        self.heartsCollectedPercent = heartsCollectedPercent
        self.distanceTraveledPercent = distanceTraveledPercent
        self.totalCompletePercent = totalCompletePercent
        self.starsRewarded = starsRewarded
        self.previousStarsEarned = previousStarsEarned
        self.newStarsEarned = newStarsEarned
        self.citrineRewarded = citrineRewarded
        self.previousCitrineEarned = previousCitrineEarned
        self.newCitrineEarned = newCitrineEarned
        self.heartsRemaining = heartsRemaining
        self.worldNumber = worldNumber
        self.levelNumber = levelNumber
    }
}