//
//  CharacterData.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterData)
class CharacterData : NSObject { // TODO doesnt have to extend this after objc conversion
    // Store all level progress here
    var levelProgress: [Int : LevelData] = [:]
    var levelsPerWorld: Int = 16
    var godMode: Bool = true
    var lastHeartBoost: Int = 0
    var goldHearts: Int = 0
    var isCharacterUnlocked: Bool = false
    
    // More scoring // TODO add all these to saved data
    var citrineStreak: Int = 0
    var longestCitrineStreak: Int = 0
    var totalRewardsEarned: Int = 0
    var totalTimesPlayed: Int = 0
    var hasBeatWorld4: Bool = false
    var playsToBeatWorld4: Int = 0
    
    // Purchased superstars
    var purchasedSuperstars: Int = 0
    
    // Heart boost
    var countDownToBoost: Int = 0
    
    // Free Rejuvenates
    var freeRejuvenations: Int = 1
    
    var totalStars: Int {
        get {
            if godMode {
                return 500
            } else {
                var stars: Int = 0
                // Iterate through levelprogress
                for (_, data) in self.levelProgress {
                    stars += data.starsEarnedHighScore
                }
                return stars
            }
        }
    }
    
    var totalCitrine: Int {
        get {
            if godMode {
                return 500
            } else {
                var citrine: Int = 0
                // Iterate through levelprogress
                for (_, data) in self.levelProgress {
                    citrine += data.citrineEarnedHighScore
                }
                
                // Also add the boosted ones we purchased
                citrine += self.purchasedSuperstars
                
                return citrine
            }
        }
    }
    
    // Skills
    var spentStars: Int = 0
    var unspentStars: Int {
        get {
            if godMode {
                return 250
            } else {
                return self.totalStars - spentStars
            }
        }
    }
    var spentCitrine: Int = 0
    var unspentCitrine: Int {
        get {
            if godMode {
                return 250
            } else {
                return self.totalCitrine - spentCitrine
            }
        }
    }
    var unlockedUpgrades = NSMutableArray()
    var defaultUpgrades = NSMutableArray()
    
    var lastPlayedLevelByWorld: [String : Int] = [:]
    var lastPlayedWorld: String = "earth"
    
    var totalLevels: Int = 0

    // Key for encoding/decoding lookups
    let SSGameDataLevelProgressKey: String = "levelProgress"
    let SSGameDataLastPlayedLevelByWorldKey: String = "lastPlayedLevelByWorld"
    let SSGameDataLastPlayedWorldKey: String = "lastPlayedWorld"
    let SSGameDataSpentStarsKey: String = "spentStars"
    let SSGameDataSpentCitrineKey: String = "spentCitrine"
    let SSGameDataUnlockedUpgradesKey: String = "unlockedUpgrades"
    let SSGameDataDefaultUpgradesKey: String = "defaultUpgrades"
    let SSGameDataLastHeartBoostKey: String = "lastHeartBoostKey"
    let SSGameDataCharacterUnlockedKey: String = "characterUnlockedKey"
    let SSGameDataCharacterPurcahsedSuperstarsKey: String = "purchasedSuperstarsKey"
    let SSGameDataGoldHeartsKey: String = "goldHeartsKey"
    
    // Other
    let SSGameDataHeartBoostCounterKey: String = "heartBoostCounterKey"
    let SSGameDataFreeRejuvenationsKey: String = "freeRejuvenationsKey"
    
    // Gamecenter score keys
    let SSGameDataCitrineStreakKey: String = "citrineStreak"
    let SSGameDataTotalRewardsEarnedKey: String = "totalRewardsEarned"
    let SSGameDataTotalTimesPlayedKey: String = "totalTimesPlayed"
    let SSGameDataHasBeatWorld4Key: String = "hasBeatWorld4"
    let SSGameDataLongestCitrineStreakKey: String = "longestCitrineStreak"
    let SSGameDataPlaysToBeatWorld4Key: String = "playsToBeatWorld4"
    
    func encodeWithCoder(_ encoder: NSCoder) {
        encoder.encode(self.levelProgress, forKey: SSGameDataLevelProgressKey)
        encoder.encode(self.spentStars, forKey: SSGameDataSpentStarsKey)
        encoder.encode(self.spentCitrine, forKey: SSGameDataSpentCitrineKey)
        encoder.encode(self.unlockedUpgrades, forKey: SSGameDataUnlockedUpgradesKey)
        encoder.encode(self.defaultUpgrades, forKey: SSGameDataDefaultUpgradesKey)
        encoder.encode(self.lastHeartBoost, forKey: SSGameDataLastHeartBoostKey)
        encoder.encode(self.goldHearts, forKey: SSGameDataGoldHeartsKey)
        encoder.encode(self.purchasedSuperstars, forKey: SSGameDataCharacterPurcahsedSuperstarsKey)
        encoder.encode(self.countDownToBoost, forKey: SSGameDataHeartBoostCounterKey)
        encoder.encode(self.countDownToBoost, forKey: SSGameDataFreeRejuvenationsKey)
        
        // Level states
        encoder.encode(self.lastPlayedLevelByWorld, forKey: SSGameDataLastPlayedLevelByWorldKey)
        encoder.encode(self.lastPlayedWorld, forKey: SSGameDataLastPlayedWorldKey)
        
        // Character unlock
        encoder.encode(self.isCharacterUnlocked, forKey: SSGameDataCharacterUnlockedKey)
        
        // GC scores
        encoder.encode(self.citrineStreak, forKey: SSGameDataCitrineStreakKey)
        encoder.encode(self.longestCitrineStreak, forKey: SSGameDataLongestCitrineStreakKey)
        encoder.encode(self.totalRewardsEarned, forKey: SSGameDataTotalRewardsEarnedKey)
        encoder.encode(self.totalTimesPlayed, forKey: SSGameDataTotalTimesPlayedKey)
        encoder.encode(self.hasBeatWorld4, forKey: SSGameDataHasBeatWorld4Key)
        encoder.encode(self.playsToBeatWorld4, forKey: SSGameDataPlaysToBeatWorld4Key)
    }
    
    init(defaultUpgrades: NSMutableArray) {
        // Add in the default upgrades
        self.defaultUpgrades.addObjects(from: defaultUpgrades as [AnyObject])
        self.unlockedUpgrades.addObjects(from: defaultUpgrades as [AnyObject])
        
        super.init()
    }
    
    init(coder decoder: NSCoder) {
        if let levelProgress: [Int : LevelData] = decoder.decodeObject(forKey: SSGameDataLevelProgressKey) as? [Int : LevelData] {
            self.levelProgress = levelProgress
        } else {
            self.levelProgress = [:]
        }
        
        self.lastPlayedWorld = decoder.decodeObject(forKey: SSGameDataLastPlayedWorldKey) as! String
        if self.lastPlayedWorld == "" {
            self.lastPlayedWorld = "earth"
        }

        if let lastPlayedLevelByWorld: [String : Int] = decoder.decodeObject(forKey: SSGameDataLastPlayedLevelByWorldKey) as? [String : Int] {
            self.lastPlayedLevelByWorld = lastPlayedLevelByWorld
        } else {
            self.lastPlayedLevelByWorld = [:]
        }
        
        self.spentStars = decoder.decodeInteger(forKey: SSGameDataSpentStarsKey)
        self.spentCitrine = decoder.decodeInteger(forKey: SSGameDataSpentCitrineKey)
        
        self.unlockedUpgrades = decoder.decodeObject(forKey: SSGameDataUnlockedUpgradesKey) as! NSMutableArray
        self.defaultUpgrades = decoder.decodeObject(forKey: SSGameDataDefaultUpgradesKey) as! NSMutableArray
        
        self.lastHeartBoost = decoder.decodeInteger(forKey: SSGameDataLastHeartBoostKey)
        
        if decoder.containsValue(forKey: SSGameDataGoldHeartsKey) {
            self.goldHearts = decoder.decodeInteger(forKey: SSGameDataGoldHeartsKey)
        } else {
            self.goldHearts = 0
        }
        
        self.isCharacterUnlocked = decoder.decodeBool(forKey: SSGameDataCharacterUnlockedKey)

        if decoder.containsValue(forKey: SSGameDataCharacterPurcahsedSuperstarsKey) {
            self.purchasedSuperstars = decoder.decodeInteger(forKey: SSGameDataCharacterPurcahsedSuperstarsKey)
        }
        
        if decoder.containsValue(forKey: SSGameDataHeartBoostCounterKey) {
            self.countDownToBoost = decoder.decodeInteger(forKey: SSGameDataHeartBoostCounterKey)
        } else {
            self.countDownToBoost = 0
        }
        
        if decoder.containsValue(forKey: SSGameDataFreeRejuvenationsKey) {
            self.freeRejuvenations = decoder.decodeInteger(forKey: SSGameDataFreeRejuvenationsKey)
            
            if self.freeRejuvenations > 1 {
                self.freeRejuvenations = 1
            }
        } else {
            self.freeRejuvenations = 1
        }
        
        // GC Scores
        self.citrineStreak = decoder.decodeInteger(forKey: SSGameDataCitrineStreakKey)
        self.longestCitrineStreak = decoder.decodeInteger(forKey: SSGameDataLongestCitrineStreakKey)
        self.totalRewardsEarned = decoder.decodeInteger(forKey: SSGameDataTotalRewardsEarnedKey)
        self.totalTimesPlayed = decoder.decodeInteger(forKey: SSGameDataTotalTimesPlayedKey)
        self.hasBeatWorld4 = decoder.decodeBool(forKey: SSGameDataHasBeatWorld4Key)
        self.playsToBeatWorld4 = decoder.decodeInteger(forKey: SSGameDataPlaysToBeatWorld4Key)
    }
    
    func initializeLevel(_ level: Int, maxHearts: Int, maxDistance: CGFloat) {
        // If the level hasnt been init, initialize to 0 so we can display it as a score
        if self.levelProgress[level] == nil {
            self.levelProgress[level] = LevelData(maxHearts: maxHearts, maxDistance: maxDistance)
        } else {
            // Set the max values to the new ones in case the level has been changed
            self.levelProgress[level]?.maxHeartsToCollect = maxHearts
            self.levelProgress[level]?.maxDistanceToTravel = maxDistance
        }
    }
    
    func isLevelLocked(_ level: Int) -> Bool {
        if (godMode) || level == 1 {
            return false
        } else {
            // If we're looking at a level > total levels, this is the credits menu. need to have earned 2 stars on this level
            if level > self.totalLevels {
                // Check if the current level (level - 1) has 2 star earned.
                if self.levelProgress[level - 1]?.starsEarnedHighScore > 1 {
                    return false
                } else {
                    return true
                }
            } else if !hasEnoughStarsToUnlock(level) || !beatLevelBeforeToUnlock(level) {
                return true
            } else {
                return false
            }
        }
    }
    
    func hasEnoughStarsToUnlock(_ level: Int) -> Bool {
        return self.totalStars >= getLevelUnlockRequirements(level)
    }
    
    func beatLevelBeforeToUnlock(_ level: Int) -> Bool {
        // Need 1 if any normal level, need 2 if it is end of level
        return level == 1 || (self.levelProgress[level-1] != nil && self.levelProgress[level-1]?.starsEarnedHighScore > 0 && level % self.levelsPerWorld != 1) || (self.levelProgress[level-1] != nil && self.levelProgress[level-1]?.starsEarnedHighScore > 1 && level % self.levelsPerWorld == 1)
    }
    
    func isWorldLocked(_ level: Int) -> Bool {
        if godMode {
            return false
        } else {
            return !beatLevelBeforeToUnlock(level)
        }
    }
    
    func getLastPlayedLevelByWorld(_ world: String) -> Int {
        if let level: Int = self.lastPlayedLevelByWorld[world] {
            return level
        } else {
            return self.getAdjustedLevelNumberByWorld(world, level: 1)
        }
    }
    
    func getAdjustedLevelNumberByWorld(_ world: String, level: Int) -> Int {
        var adjuster = 0
        
        if world == "earth" {
            adjuster = 0
        } else if world == "water" {
            adjuster = 1
        } else if world == "fire" {
            adjuster = 2
        } else if world == "air" {
            adjuster = 3
        } else if world == "spirit" {
            adjuster = 4
        }
        
        return level + (adjuster * self.levelsPerWorld)
    }
    
    func getLevelNumberForWorld(_ overallLevel: Int) -> Int {
        let lvl: Int = overallLevel % self.levelsPerWorld
        
        if lvl == 0 {
            return 16
        } else {
            return lvl
        }
    }
    
    func getWorldNumber(_ world: String) -> Int {
        if world == "earth" {
            return 1
        } else if world == "water" {
            return 2
        } else if world == "fire" {
            return 3
        } else if world == "air" {
            return 4
        } else if world == "spirit" {
            return 5
        }
        
        return 1
    }
    
    func getWorldForLevel(_ level: Int) -> String {
        let worldCalc = Double(level) / Double(self.levelsPerWorld)
        
        if worldCalc <= 1.0 {
            return "earth"
        } else if worldCalc <= 2.0 {
            return "water"
        } else if worldCalc <= 3.0 {
            return "fire"
        } else if worldCalc <= 4.0 {
            return "air"
        } else if worldCalc <= 5.0 {
            return "spirit"
        } else {
            return ""
        }
    }
    
    func getLevelUnlockRequirements(_ level: Int) -> Int {
        // Need to get 2 of 3 stars on average
        var levelReqs: Int = (level-1) * 2
        
        // Every 4 levels, need at least one 3 star
        levelReqs += Int(floor(Double(level)/4.0))
        
        return levelReqs
    }
    
    func resetCharacterSkills() {
        // Clear out array
        self.unlockedUpgrades = NSMutableArray()
        
        // Add the default skills
        self.unlockedUpgrades.addObjects(from: self.defaultUpgrades as [AnyObject])
        
        // Reset spent skills
        self.spentStars = 0
        self.spentCitrine = 0
    }
    
    func purchaseUpgrade(_ currency: Currency, cost: Int, id: CharacterUpgrade) {
        switch currency {
        case .Citrine:
            self.spentCitrine += cost
        case .Stars:
            self.spentStars += cost
        }

        self.unlockedUpgrades.add(id.rawValue)
    }
    
    func isUpgradeUnlocked(_ upgrade: CharacterUpgrade) -> Bool {
        if self.unlockedUpgrades.index(of: upgrade.rawValue) >= 0 && self.unlockedUpgrades.index(of: upgrade.rawValue) < self.unlockedUpgrades.count {
            return true
        } else {
            return false
        }
    }
    
    func updateScores(_ score: LevelScore, worldNumber: Int, levelNumber: Int) {
        // Update citrine streak
        if score.citrineRewarded == 1 {
            self.citrineStreak = self.citrineStreak + 1
            
            // Keep record of the highest
            if self.citrineStreak > self.longestCitrineStreak {
                self.longestCitrineStreak = self.citrineStreak
            }
        } else {
            // Reset our streak
            self.citrineStreak = 0
        }
        
        // Add counters for the average calculation
        self.totalRewardsEarned += score.citrineRewarded + score.starsRewarded
        self.totalTimesPlayed += 1
        
        // Plays to beat world 4
        //NSLog("\(self.getLevelNumberForWorld(levelNumber))")
        if !self.hasBeatWorld4 && worldNumber == 4 && self.getLevelNumberForWorld(levelNumber) == self.levelsPerWorld && score.starsRewarded == 1 {
            self.hasBeatWorld4 = true
            self.playsToBeatWorld4 = self.totalTimesPlayed
        }
    }
    
    func incrementTimesPlayed(levelNumber: Int) {
        self.totalTimesPlayed += 1
        self.levelProgress[levelNumber]!.timesLevelPlayed += 1
    }
    
    func getNextSuperstarPurchaseCost() -> Int {
        switch self.purchasedSuperstars {
        case 0:
            return 5
        case 1:
            return 12
        case 2:
            return 20
        case 3:
            return 35
        case 4:
            return 50
        case 5:
            return 50
        default:
            return 50
        }
    }
    
    func purchaseNextSuperstar() {
        self.purchasedSuperstars += 1
    }
    
    func allStarsEarnedForWorld(_ world: Int) -> Bool {
        let calcLevelNumber: Int = self.levelsPerWorld * (world - 1) + 1
        var notMet: Bool = false
        
        for i in calcLevelNumber...calcLevelNumber + 15 {
            if levelProgress[i] == nil || levelProgress[i]?.starsEarnedHighScore < 3 {
                notMet = true
            }
        }
        
        return !notMet
    }
    
    func allSuperstarsEarnedForWorld(_ world: Int) -> Bool {
        let calcLevelNumber: Int = self.levelsPerWorld * (world - 1) + 1
        var notMet: Bool = false
        
        for i in calcLevelNumber...calcLevelNumber + 15 {
            if levelProgress[i] == nil || levelProgress[i]?.citrineEarnedHighScore < 1 {
                notMet = true
            }
        }
        
        return !notMet
    }
    
    func allChallengesEarnedForWorld(_ world: Int) -> Bool {
        let calcLevelNumber: Int = self.levelsPerWorld * (world - 1) + 1
        var notMet: Bool = false
        
        for i in calcLevelNumber...calcLevelNumber + 15 {
            if levelProgress[i] == nil || levelProgress[i]?.availableChallenges.count != levelProgress[i]?.challengeCompletion.count {
                notMet = true
            }
        }
        
        return !notMet
    }
    
    func challengesEarnedForWorld(_ world: Int) -> Int {
        let calcLevelNumber: Int = self.levelsPerWorld * (world - 1) + 1
        var number: Int = 0
        
        for i in calcLevelNumber...calcLevelNumber + 15 {
            if levelProgress[i] != nil && levelProgress[i]?.challengeCompletion.count != nil {
                number += levelProgress[i]!.challengeCompletion.count
            }
        }
        
        return number
    }
    
    func challengesUnlocked(_ currentLevel: Int) -> Bool {
        // If the 6th level has been played or this is the 6th level
        if levelProgress[6] != nil && levelProgress[6]?.timesLevelPlayed > 0 || currentLevel == 6 {
            return true
        } else {
            return false
        }
    }
    
    func hasFreeRejuvenations() -> Bool {
        if self.freeRejuvenations > 0 {
            return true
        } else {
            return false
        }
    }
    
    func useFreeRejuvenation() {
        self.freeRejuvenations -= 1
    }
}
