//
//  LevelData.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class LevelData : NSObject {
    // Experience gainers
    var heartsCollected: Int = 0
    var maxHeartsToCollect: Int = 0
    var distanceTraveled: CGFloat = 0
    var maxDistanceToTravel: CGFloat = 0
    
    // Completion progress
    var starsEarnedHighScore: Int = 0
    var previousStarsEarnedHighScore: Int = 0
    var citrineEarnedHighScore: Int = 0
    var previousCitrineEarnedHighScore: Int = 0
    
    // Challenges
    var challengeCompletion = NSMutableSet() //[String : Bool] = [:]
    var availableChallenges = NSMutableSet() //[String : Bool] = [:]

    // Rewards
    var tier1Percent: CGFloat = 0.50
    var tier2Percent: CGFloat = 0.70
    var tier3Percent: CGFloat = 0.90
    var citrinePercent: CGFloat = 1.0
    
    // Random statistics
    var timesLevelPlayed: Int = 0
    
    // Keys for encoding/decoding lookups
    let SSLevelHeartsCollectedKey: String = "heartsCollected"
    let SSLevelMaxHeartsToCollectKey: String = "maxHeartsToCollect"
    let SSLevelDistanceTraveledKey: String = "distanceTraveled"
    let SSLevelMaxDistanceToTravelKey: String = "maxDistanceToTravel"
    let SSLevelStarsEarnedHighScoreKey: String = "starsEarnedHighScore"
    let SSLevelPreviousStarsEarnedHighScoreKey: String = "previousStarsEarnedHighScore"
    let SSLevelCitrineEarnedHighScoreKey: String = "citrineEarnedHighScore"
    let SSLevelPreviousCitrineEarnedHighScoreKey: String = "previousCitrineEarnedHighScore"
    let SSLevelTier1PercentKey: String = "tier1Percent"
    let SSLevelTier2PercentKey: String = "tier2Percent"
    let SSLevelTier3PercentKey: String = "tier3Percent"
    let SSLevelCitrinePercentKey: String = "citrinePercent"
    let SSLevelTimesLevelPlayedKey: String = "timesLevelPlayed"
    let SSLevelChallengeCompletionKey: String = "challengeCompletion"
    let SSLevelAvailableChallengesKey: String = "availableChallenges"
    
    init(maxHearts: Int, maxDistance: CGFloat) {
        self.maxHeartsToCollect = maxHearts
        self.maxDistanceToTravel = maxDistance
    }
    
    func encodeWithCoder(_ encoder: NSCoder) {
        encoder.encode(self.heartsCollected, forKey: SSLevelHeartsCollectedKey)
        encoder.encode(self.maxHeartsToCollect, forKey: SSLevelMaxHeartsToCollectKey)
        encoder.encode(Double(self.distanceTraveled), forKey: SSLevelDistanceTraveledKey)
        encoder.encode(Double(self.maxDistanceToTravel), forKey: SSLevelMaxDistanceToTravelKey)
        encoder.encode(self.starsEarnedHighScore, forKey: SSLevelStarsEarnedHighScoreKey)
        encoder.encode(self.previousStarsEarnedHighScore, forKey: SSLevelPreviousStarsEarnedHighScoreKey)
        encoder.encode(self.citrineEarnedHighScore, forKey: SSLevelCitrineEarnedHighScoreKey)
        encoder.encode(self.previousCitrineEarnedHighScore, forKey: SSLevelPreviousCitrineEarnedHighScoreKey)
        encoder.encode(Double(self.tier1Percent), forKey: SSLevelTier1PercentKey)
        encoder.encode(Double(self.tier2Percent), forKey: SSLevelTier2PercentKey)
        encoder.encode(Double(self.tier3Percent), forKey: SSLevelTier3PercentKey)
        encoder.encode(Double(self.citrinePercent), forKey: SSLevelCitrinePercentKey)
        encoder.encode(self.timesLevelPlayed, forKey: SSLevelTimesLevelPlayedKey)
        
        // Challenge progress
        encoder.encode(self.availableChallenges, forKey: SSLevelAvailableChallengesKey)
        encoder.encode(self.challengeCompletion, forKey: SSLevelChallengeCompletionKey)
    }
    
    init(coder decoder: NSCoder) {
        self.heartsCollected = decoder.decodeInteger(forKey: SSLevelHeartsCollectedKey)
        self.maxHeartsToCollect = decoder.decodeInteger(forKey: SSLevelMaxHeartsToCollectKey)
        self.distanceTraveled = CGFloat(decoder.decodeDouble(forKey: SSLevelDistanceTraveledKey))
        self.maxDistanceToTravel = CGFloat(decoder.decodeDouble(forKey: SSLevelMaxDistanceToTravelKey))
        self.starsEarnedHighScore = decoder.decodeInteger(forKey: SSLevelStarsEarnedHighScoreKey)
        self.previousStarsEarnedHighScore = decoder.decodeInteger(forKey: SSLevelPreviousStarsEarnedHighScoreKey)
        self.citrineEarnedHighScore = decoder.decodeInteger(forKey: SSLevelCitrineEarnedHighScoreKey)
        self.previousCitrineEarnedHighScore = decoder.decodeInteger(forKey: SSLevelPreviousCitrineEarnedHighScoreKey)
        self.tier1Percent = CGFloat(decoder.decodeDouble(forKey: SSLevelTier1PercentKey))
        self.tier2Percent = CGFloat(decoder.decodeDouble(forKey: SSLevelTier2PercentKey))
        self.tier3Percent = CGFloat(decoder.decodeDouble(forKey: SSLevelTier3PercentKey))
        self.citrinePercent = CGFloat(decoder.decodeDouble(forKey: SSLevelCitrinePercentKey))
        self.timesLevelPlayed = decoder.decodeInteger(forKey: SSLevelTimesLevelPlayedKey)
        
        // Challenges
        if let challengeCompletion = decoder.decodeObject(forKey: SSLevelChallengeCompletionKey) as? NSMutableSet {
            self.challengeCompletion = challengeCompletion
        } else {
            self.challengeCompletion = NSMutableSet()
        }
        if let availableChallenges = decoder.decodeObject(forKey: SSLevelAvailableChallengesKey) as? NSMutableSet {
            self.availableChallenges = availableChallenges
        } else {
            self.availableChallenges = NSMutableSet()
        }
    }
    
    func updateLevelData(_ heartsCollected: Int, distanceTraveled: CGFloat, heartsRemaining: Int, worldNumber: Int, levelNumber: Int) -> LevelScore {
        // Update from passed vars
        self.heartsCollected = heartsCollected
        
        // Make sure we don't somehow get further than total level
        if self.maxDistanceToTravel < distanceTraveled {
            self.distanceTraveled = self.maxDistanceToTravel
        } else {
            self.distanceTraveled = distanceTraveled
        }
        
        // Increment times played
        self.timesLevelPlayed += 1
        
        // Set previous counters to new high scores so we know if the score changed this round
        self.previousStarsEarnedHighScore = self.starsEarnedHighScore
        self.previousCitrineEarnedHighScore = self.citrineEarnedHighScore
        
        // Calculate stars earned
        let enemyRatio = CGFloat(self.heartsCollected)/CGFloat(self.maxHeartsToCollect)
        let distanceRatio = self.distanceTraveled/self.maxDistanceToTravel
        let totalRatio = (enemyRatio + distanceRatio) / 2
        
        // Local calcs
        var thisLevelStarsEarned = 0
        var thisLevelCitrineEarned = 0
        
        if totalRatio >= tier1Percent && totalRatio < tier2Percent {
            thisLevelStarsEarned = 1
        } else if totalRatio >= tier2Percent && totalRatio < tier3Percent {
            thisLevelStarsEarned = 2
        } else if totalRatio >= tier3Percent {
            thisLevelStarsEarned = 3
        }
        
        // Check for citrine
        if totalRatio >= citrinePercent {
            thisLevelCitrineEarned = 1
        }
        
        // Set new scores
        if thisLevelStarsEarned >= starsEarnedHighScore {
            previousStarsEarnedHighScore = starsEarnedHighScore
            starsEarnedHighScore = thisLevelStarsEarned
        }
        if thisLevelCitrineEarned >= citrineEarnedHighScore {
            previousCitrineEarnedHighScore = citrineEarnedHighScore
            citrineEarnedHighScore = thisLevelCitrineEarned
        }
        
        return LevelScore(heartsCollected: self.heartsCollected, maxHeartsToCollect: self.maxHeartsToCollect, distanceTraveled: self.distanceTraveled, maxDistanceToTravel: self.maxDistanceToTravel, heartsCollectedPercent: enemyRatio, distanceTraveledPercent: distanceRatio, totalCompletePercent: totalRatio, starsRewarded: thisLevelStarsEarned, newStarsEarned: self.starsEarnedHighScore - self.previousStarsEarnedHighScore, previousStarsEarned: self.previousStarsEarnedHighScore, citrineRewarded: thisLevelCitrineEarned, newCitrineEarned: self.citrineEarnedHighScore - self.previousCitrineEarnedHighScore, previousCitrineEarned: self.previousCitrineEarnedHighScore, heartsRemaining: heartsRemaining, worldNumber: worldNumber, levelNumber: levelNumber)
    }
}
