//
//  GameData.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

// Notifications
let CloudHasMoreRecentDataThanLocal: String = "cloud_has_more_recent_data_than_local"

@objc(GameData)
class GameData : NSObject, NSCoding { // TODO doesnt need to inheirit from NSObject
    // Singleton
    static var sharedGameData = GameData.loadInstance()
    
    // Synchronization between local and iCloud data
    var timeLastUpdated: Date
    
    // Characters
    var warriorCharacter: CharacterData
    var archerCharacter: CharacterData
    var mageCharacter: CharacterData
    var monkCharacter: CharacterData
    var selectedCharacter: CharacterType
    
    // Tutorial acks - Key + Versions #. Minor versions don't exclude, major versions exclude?
    var tutorialsAcknowledged: [String: Double] = [:]

    // Ads?
    var adsUnlocked: Bool = false
    
    // Scores
    var totalGemsCollected = 0
    
    // Game Center reporting
    var bestRecordedGameProgress: Int? = nil
    var bestRecordedGemsCollected: Int? = nil
    var bestRecordedPlaysToBeatWorld4: Int? = nil
    var bestRecordedLongestSuperstarStreak: Int? = nil
    var bestRecordedAverageLevelScore: Int? = nil
    var number1StarScores: Int = 0
    var number2StarScores: Int = 0
    var number3StarScores: Int = 0
    var number4StarScores: Int = 0
    
    // Rating
    var playerHasRatedGame: Bool = false
    var promptRateMeCountdown: Int = 10
    var promptRateMeMax: Int = 10
    
    // Store a copy of the data we got from the cloud in case it was more recent
    var unarchivedCloudData: GameData?
    
    // Preferences
    var preferenceSoundEffects: Bool = true
    var preferenceMusic: Bool = true
    
    // Achievements
    var achievementsCompleted = NSMutableSet()
    
    // Played
    var timesPlayed: Int = 0
    var adPopCountdown: Int = 20
    var adPopMax: Int = 5
    
    // Ads
    var lastVideoAdWatch: Date
    static var videoAdCooldown: Int = -2
    
    // Heart Boost
    static var heartBoostCooldown: Int = -20
    var heartBoostLastUsed: Date
    var heartBoostCount: Int = 0
    static var heartBoostPromptCooldown: Int = -10
    var heartBoostLastPrompted: Date
    static var adsPurchasedHeartBoostMultiplier: Int = 3
    
    // Cloud vs local
    var cloudSyncing: Bool = true
    
    private var _totalDiamonds: Int = 0
    var totalDiamonds: Int {
        get {
            return _totalDiamonds
        }
        set {
            // Add new gems to total
            if newValue > self._totalDiamonds {
                self.totalGemsCollected = self.totalGemsCollected + (newValue - self._totalDiamonds)
            }
                
            // Update gem count
            self._totalDiamonds = newValue
        }
    }
    
    var highScore: Int {
        get {
            var score: Int = 0
            
            // Add warrior score
            score = score + warriorCharacter.totalCitrine * 5
            score = score + warriorCharacter.totalStars
            
            // Add archer score
            score = score + archerCharacter.totalCitrine * 5
            score = score + archerCharacter.totalStars
            
            // Add mage score
            score = score + mageCharacter.totalCitrine * 5
            score = score + mageCharacter.totalStars
            
            // Add monk score
            score = score + monkCharacter.totalCitrine * 5
            score = score + monkCharacter.totalStars
            
            // Add gem score
            score = score + self.totalGemsCollected
            
            return score
        }
    }
    
    // iCloud key
    static let SSiCloudGameDataKey: String = "iCloudGameDataKey"
    static let SSGameDataLastUpdated: String = "SSGameDataLastUpdated"

    // Security keys
    static let SSGameDataChecksumKey: String = "gameDataChecksumKey"
    
    // Data keys
    let SSGameDataWarriorCharacterKey: String = "warriorCharacterKey"
    let SSGameDataArcherCharacterKey: String = "archerCharacterKey"
    let SSGameDataMageCharacterKey: String = "mageCharacterKey"
    let SSGameDataMonkCharacterKey: String = "monkCharacterKey"
    let SSGameDataSelectedCharacterKey: String = "selectedCharacterKey"
    let SSGameDataTotalDiamondsKey: String = "totalDiamonds"
    let SSGameDataTotalGemsCollectedKey: String = "totalGemsCollected"
    let SSGameDataAdsUnlockedKey: String = "adsUnlocked"
    let SSGameDataTutorialsAcknowledgedKey: String = "tutorialsAcknowledged"
    let SSGameDataTimesPlayedKey: String = "timesPlayedKey"
    
    // Ads
    let SSGameDataAdPopCountownKey: String = "adPopCountdownKey"
    let SSGameDataLastVideoAdWatch: String = "lastVideoAdWatch"
    let SSGameDataHeartBoostLastUsed: String = "heartBoostLastUsed"
    let SSGameDataHeartBoostLastPrompted: String = "heartBoostLastPrompted"
    let SSGameDataHeartBoostCountKey: String = "heartBoostCount"
    
    // Data keys gamecenter
    let SSGameDataBRGemsCollectedKey: String = "brGemsCollected"
    let SSGameDataBRLevelProgressKey: String = "brLevelProgress"
    let SSGameDataBRPlaysToBeatWorld4Key: String = "brPlaysToBeatWorld4"
    let SSGameDataBRLongestSuperstarStreakKey: String = "brLongestSuperstarStreak"
    let SSGameDataBRAverageScoreKey: String = "brAverageScore"
    let SSGameDataNumber1StarScoresKey: String = "brNumber1StarScores"
    let SSGameDataNumber2StarScoresKey: String = "brNumber2StarScores"
    let SSGameDataNumber3StarScoresKey: String = "brNumber3StarScores"
    let SSGameDataNumber4StarScoresKey: String = "brNumber4StarScores"
    
    // Rating
    let SSGameDataPlayerHasRatedGameKey: String = "playerHasRatedGameKey"
    let SSGameDataPromptRateMeCountdownKey: String = "promptRateMeCountdownKey"
    
    // Preferences
    let SSGameDataPreferenceSoundEffects: String = "preferenceSoundEffectsKey"
    let SSGameDataPreferenceMusic: String = "preferenceMusicKey"
    
    // Achievements
    let SSGameDataAchievementsCompleted: String = "achievementsCompletedKey"
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.timeLastUpdated, forKey: GameData.SSGameDataLastUpdated)
        encoder.encode(self.warriorCharacter, forKey: SSGameDataWarriorCharacterKey)
        encoder.encode(self.archerCharacter, forKey: SSGameDataArcherCharacterKey)
        encoder.encode(self.mageCharacter, forKey: SSGameDataMageCharacterKey)
        encoder.encode(self.monkCharacter, forKey: SSGameDataMonkCharacterKey)
        encoder.encode(self.selectedCharacter.rawValue, forKey: SSGameDataSelectedCharacterKey)
        encoder.encode(self._totalDiamonds, forKey: SSGameDataTotalDiamondsKey)
        encoder.encode(self.totalGemsCollected, forKey: SSGameDataTotalGemsCollectedKey)
        encoder.encode(self.adsUnlocked, forKey: SSGameDataAdsUnlockedKey)
        encoder.encode(self.tutorialsAcknowledged, forKey: SSGameDataTutorialsAcknowledgedKey)
        encoder.encode(self.timesPlayed, forKey: SSGameDataTimesPlayedKey)
        
        // Ads
        encoder.encode(self.adPopCountdown, forKey: SSGameDataAdPopCountownKey)
        encoder.encode(self.lastVideoAdWatch, forKey: SSGameDataLastVideoAdWatch)
        encoder.encode(self.heartBoostLastUsed, forKey: SSGameDataHeartBoostLastUsed)
        encoder.encode(self.heartBoostLastPrompted, forKey: SSGameDataHeartBoostLastPrompted)
        encoder.encode(self.heartBoostCount, forKey: SSGameDataHeartBoostCountKey)
        
        // Rating info
        encoder.encode(self.playerHasRatedGame, forKey: SSGameDataPlayerHasRatedGameKey)
        encoder.encode(self.promptRateMeCountdown, forKey: SSGameDataPromptRateMeCountdownKey)
        
        // Preferences
        encoder.encode(self.preferenceSoundEffects, forKey: SSGameDataPreferenceSoundEffects)
        encoder.encode(self.preferenceMusic, forKey: SSGameDataPreferenceMusic)
        
        // Achievements
        encoder.encode(self.achievementsCompleted, forKey: SSGameDataAchievementsCompleted)
        encoder.encode(self.number1StarScores, forKey: SSGameDataNumber1StarScoresKey)
        encoder.encode(self.number2StarScores, forKey: SSGameDataNumber2StarScoresKey)
        encoder.encode(self.number3StarScores, forKey: SSGameDataNumber3StarScoresKey)
        encoder.encode(self.number4StarScores, forKey: SSGameDataNumber4StarScoresKey)
        
        // Encode game center stats
        if self.bestRecordedGemsCollected != nil {
            encoder.encode(self.bestRecordedGemsCollected!, forKey: SSGameDataBRGemsCollectedKey)
        }
        
        if self.bestRecordedGameProgress != nil {
            encoder.encode(self.bestRecordedGameProgress!, forKey: SSGameDataBRLevelProgressKey)
        }
        
        if self.bestRecordedLongestSuperstarStreak != nil {
            encoder.encode(self.bestRecordedLongestSuperstarStreak!, forKey: SSGameDataBRLongestSuperstarStreakKey)
        }
        
        if self.bestRecordedAverageLevelScore != nil {
            encoder.encode(self.bestRecordedAverageLevelScore!, forKey: SSGameDataBRAverageScoreKey)
        }
        
        if self.bestRecordedPlaysToBeatWorld4 != nil {
            encoder.encode(self.bestRecordedPlaysToBeatWorld4!, forKey: SSGameDataBRPlaysToBeatWorld4Key)
        }
    }
    
    override init() {
        warriorCharacter = CharacterData(defaultUpgrades: Warrior.getDefaultSkills())
        // Make sure the warrior is unlocked
        warriorCharacter.isCharacterUnlocked = true
        
        archerCharacter = CharacterData(defaultUpgrades: Archer.getDefaultSkills())
        archerCharacter.isCharacterUnlocked = true
        
        mageCharacter = CharacterData(defaultUpgrades: Mage.getDefaultSkills())
        monkCharacter = CharacterData(defaultUpgrades: Monk.getDefaultSkills())
        selectedCharacter = .Warrior
        
        // Setup the initial date
        self.timeLastUpdated = Date(timeIntervalSince1970: TimeInterval(0))
        
        let calendar = NSCalendar.autoupdatingCurrent
        self.lastVideoAdWatch = calendar.date(byAdding: Calendar.Component.minute, value: GameData.videoAdCooldown, to: Date())!
        self.heartBoostLastUsed = calendar.date(byAdding: Calendar.Component.minute, value: GameData.heartBoostCooldown * GameData.adsPurchasedHeartBoostMultiplier, to: Date())!
        self.heartBoostLastPrompted = calendar.date(byAdding: Calendar.Component.minute, value: GameData.heartBoostPromptCooldown, to: Date())!
        
        super.init()
    }

    required init(coder decoder: NSCoder) {
        if let decodedTimeLastUpdate = decoder.decodeObject(forKey: GameData.SSGameDataLastUpdated) as? Date {
            self.timeLastUpdated = decodedTimeLastUpdate
        } else {
            self.timeLastUpdated = Date(timeIntervalSince1970: TimeInterval(0))
        }
        
        if let decodedLastVideoAdWatch = decoder.decodeObject(forKey: SSGameDataLastVideoAdWatch) as? Date {
            self.lastVideoAdWatch = decodedLastVideoAdWatch
        } else {
            let calendar = NSCalendar.autoupdatingCurrent
            self.lastVideoAdWatch = calendar.date(byAdding: Calendar.Component.minute, value: GameData.videoAdCooldown, to: Date())!
        }
        
        if let decodedHeartBoostLastUsed = decoder.decodeObject(forKey: SSGameDataHeartBoostLastUsed) as? Date {
            self.heartBoostLastUsed = decodedHeartBoostLastUsed
        } else {
            let calendar = NSCalendar.autoupdatingCurrent
            self.heartBoostLastUsed = calendar.date(byAdding: Calendar.Component.minute, value: GameData.heartBoostCooldown * GameData.adsPurchasedHeartBoostMultiplier, to: Date())!
        }
        
        if let decodedHeartBoostLastPrompted = decoder.decodeObject(forKey: SSGameDataHeartBoostLastPrompted) as? Date {
            self.heartBoostLastPrompted = decodedHeartBoostLastPrompted
        } else {
            let calendar = NSCalendar.autoupdatingCurrent
            self.heartBoostLastPrompted = calendar.date(byAdding: Calendar.Component.minute, value: GameData.heartBoostPromptCooldown, to: Date())!
        }
        
        if decoder.containsValue(forKey: SSGameDataHeartBoostCountKey) {
            self.heartBoostCount = decoder.decodeInteger(forKey: SSGameDataHeartBoostCountKey)
        }
        
        if let decodedChar = decoder.decodeObject(forKey: SSGameDataWarriorCharacterKey) as? CharacterData {
            warriorCharacter = decodedChar
        } else {
            warriorCharacter = CharacterData(defaultUpgrades: Warrior.getDefaultSkills())
        }
        
        // Make sure warrior is unlocked
        warriorCharacter.isCharacterUnlocked = true
        
        if let decodedChar = decoder.decodeObject(forKey: SSGameDataArcherCharacterKey) as? CharacterData {
            archerCharacter = decodedChar
        } else {
            archerCharacter = CharacterData(defaultUpgrades: Archer.getDefaultSkills())
        }
        
        // Make sure archerCharacter is unlocked
        archerCharacter.isCharacterUnlocked = true
        
        if let decodedChar = decoder.decodeObject(forKey: SSGameDataMageCharacterKey) as? CharacterData {
            mageCharacter = decodedChar
        } else {
            mageCharacter = CharacterData(defaultUpgrades: Mage.getDefaultSkills())
        }
        
        if let decodedChar = decoder.decodeObject(forKey: SSGameDataMonkCharacterKey) as? CharacterData {
            monkCharacter = decodedChar
        } else {
            monkCharacter = CharacterData(defaultUpgrades: Monk.getDefaultSkills())
        }
        
        if let decodedSelection = decoder.decodeObject(forKey: SSGameDataSelectedCharacterKey) as? String {
            selectedCharacter = CharacterType(rawValue: decodedSelection)!   
        } else {
            selectedCharacter = .Warrior
        }
        
        if decoder.containsValue(forKey: SSGameDataTotalDiamondsKey) {
            self._totalDiamonds = decoder.decodeInteger(forKey: SSGameDataTotalDiamondsKey)
        }
        if decoder.containsValue(forKey: SSGameDataTotalGemsCollectedKey) {
            self.totalGemsCollected = decoder.decodeInteger(forKey: SSGameDataTotalGemsCollectedKey)
        }
        if decoder.containsValue(forKey: SSGameDataAdsUnlockedKey) {
            self.adsUnlocked = decoder.decodeBool(forKey: SSGameDataAdsUnlockedKey)
        }
        if decoder.containsValue(forKey: SSGameDataTimesPlayedKey) {
            self.timesPlayed = decoder.decodeInteger(forKey: SSGameDataTimesPlayedKey)
        }
        
        // Scores
        if decoder.containsValue(forKey: SSGameDataNumber1StarScoresKey) {
            self.number1StarScores = decoder.decodeInteger(forKey: SSGameDataNumber1StarScoresKey)
        }
        if decoder.containsValue(forKey: SSGameDataNumber2StarScoresKey) {
            self.number2StarScores = decoder.decodeInteger(forKey: SSGameDataNumber2StarScoresKey)
        }
        if decoder.containsValue(forKey: SSGameDataNumber3StarScoresKey) {
            self.number3StarScores = decoder.decodeInteger(forKey: SSGameDataNumber3StarScoresKey)
        }
        if decoder.containsValue(forKey: SSGameDataNumber4StarScoresKey) {
            self.number4StarScores = decoder.decodeInteger(forKey: SSGameDataNumber4StarScoresKey)
        }
        
        // Ads
        if decoder.containsValue(forKey: SSGameDataAdPopCountownKey) {
            self.adPopCountdown = decoder.decodeInteger(forKey: SSGameDataAdPopCountownKey)
        }
        
        // Tutorials
        if let tutorialsAcknowledged: [String : Double] = decoder.decodeObject(forKey: SSGameDataTutorialsAcknowledgedKey) as? [String : Double] {
            self.tutorialsAcknowledged = tutorialsAcknowledged
        } else {
            self.tutorialsAcknowledged = [:]
        }
        
        // Get game center data
        if decoder.containsValue(forKey: SSGameDataBRLevelProgressKey) {
            self.bestRecordedGameProgress = decoder.decodeInteger(forKey: SSGameDataBRLevelProgressKey)
        }
        if decoder.containsValue(forKey: SSGameDataBRGemsCollectedKey) {
            self.bestRecordedGemsCollected = decoder.decodeInteger(forKey: SSGameDataBRGemsCollectedKey)
        }
        if decoder.containsValue(forKey: SSGameDataBRAverageScoreKey) {
            self.bestRecordedAverageLevelScore = decoder.decodeInteger(forKey: SSGameDataBRAverageScoreKey)
        }
        if decoder.containsValue(forKey: SSGameDataBRLongestSuperstarStreakKey) {
            self.bestRecordedLongestSuperstarStreak = decoder.decodeInteger(forKey: SSGameDataBRLongestSuperstarStreakKey)
        }
        if decoder.containsValue(forKey: SSGameDataBRPlaysToBeatWorld4Key) {
            self.bestRecordedPlaysToBeatWorld4 = decoder.decodeInteger(forKey: SSGameDataBRPlaysToBeatWorld4Key)
        }
        
        // Achievements
        if let achievementsCompleted: NSMutableSet = decoder.decodeObject(forKey: SSGameDataAchievementsCompleted) as? NSMutableSet {
            self.achievementsCompleted = achievementsCompleted
        } else {
            self.achievementsCompleted = NSMutableSet()
        }
        
        // Rating
        if decoder.containsValue(forKey: SSGameDataPlayerHasRatedGameKey) {
            self.playerHasRatedGame = decoder.decodeBool(forKey: SSGameDataPlayerHasRatedGameKey)
        }
        if decoder.containsValue(forKey: SSGameDataPromptRateMeCountdownKey) {
            self.promptRateMeCountdown = decoder.decodeInteger(forKey: SSGameDataPromptRateMeCountdownKey)
        }
        
        // Preferences
        if decoder.containsValue(forKey: SSGameDataPreferenceMusic) {
            self.preferenceMusic = decoder.decodeBool(forKey: SSGameDataPreferenceMusic)
        }
        if decoder.containsValue(forKey: SSGameDataPreferenceSoundEffects) {
            self.preferenceSoundEffects = decoder.decodeBool(forKey: SSGameDataPreferenceSoundEffects)
        }
        
        super.init()
    }
    
    func save() {
        self.timeLastUpdated = Date()
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        
        // Generate the checksum
        let checksum = SecureStringCreator.computeSHA256DigestForData(encodedData)
        
        // Write data to storage
        try? encodedData.write(to: URL(fileURLWithPath: GameData.filePath()), options: .atomic)
        
        // Write new checksum to keychain
        KeychainWrapper.setString(checksum as String, forKey: GameData.SSGameDataChecksumKey)
        
        if self.cloudSyncing {
            // Save to iCloud
            self.saveToiCloud()
        }
    }
    
    func resetAllData() {
        self.warriorCharacter = CharacterData(defaultUpgrades: Warrior.getDefaultSkills())
        self.archerCharacter = CharacterData(defaultUpgrades: Archer.getDefaultSkills())
        self.mageCharacter = CharacterData(defaultUpgrades: Mage.getDefaultSkills())
        self.monkCharacter = CharacterData(defaultUpgrades: Monk.getDefaultSkills())
        self.selectedCharacter = .Warrior
        
        save()
    }
    
    func saveToiCloud() {
        let iCloudStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default()
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        
        // Set data into icloud dictionary (locally)
        iCloudStore.set(encodedData, forKey: GameData.SSiCloudGameDataKey)
    }
    
    class func filePath() -> String {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("gamedata")
        
        return filePath
    }
    
    class func loadInstance() -> GameData {
        let localData = self.getLocalData()
        let cloudData = self.getCloudData()
        
        var unarchivedLocal: GameData? = nil
        var unarchivedCloud: GameData? = nil
        
        if localData != nil {
            unarchivedLocal = (NSKeyedUnarchiver.unarchiveObject(with: localData!) as! GameData)
        }
        
        if cloudData != nil {
            unarchivedCloud = (NSKeyedUnarchiver.unarchiveObject(with: cloudData!) as! GameData)
        }
        
        return self.getDesiredGameData(unarchivedLocal, cloud: unarchivedCloud)
    }
    
    // Always loads local or new but if there is cloud sends notification to user that they can load it up if desired
    class func getDesiredGameData(_ local: GameData?, cloud: GameData?) -> GameData {
        // If there is cloud and local, return local.
        if cloud != nil && local != nil {
            // If cloud > local, notify user of choice.
            let localTime = local!.timeLastUpdated
            let cloudTime = cloud!.timeLastUpdated
            
            if cloudTime.compare(localTime) == ComparisonResult.orderedDescending {
                // Store the cloud data we pulled so we can load it if needed
                local!.unarchivedCloudData = cloud
                
                // Notify user that cloud data is greater, give them choice
                //NotificationCenter.default.post(name: Notification.Name(rawValue: CloudHasMoreRecentDataThanLocal), object: nil)
            }
            
            return local!
        }
        // If there is cloud and not local, return GameData. Notify user of choice.
        else if cloud != nil && local == nil {
            // Store the cloud data we pulled so we can load it if needed
            let newData = GameData()
            
            newData.unarchivedCloudData = cloud
            
            // Notify user that cloud data is greater, give them choice
            //NotificationCenter.default.post(name: Notification.Name(rawValue: CloudHasMoreRecentDataThanLocal), object: nil)
            
            return newData
        }
        // If there is local, return local
        else if local != nil {
            return local!
        }
        // If there is nothing, return GameData
        else {
            return GameData()
        }
    }
    
    class func getLocalData() -> Data? {
        // ***** Get local data
        var localData = try? Data(contentsOf: URL(fileURLWithPath: GameData.filePath()))
        
        if (localData != nil) {
            // Security check. Make sure the data wasn't manipulated
            // Get the checksum from the keychain
            let savedFileChecksum = KeychainWrapper.stringForKey(GameData.SSGameDataChecksumKey)
            
            // Calculate the checksum of the data
            let checksum = SecureStringCreator.computeSHA256DigestForData(localData!)
            
            //NSLog("Saved file checksum is \(savedFileChecksum)")
            //NSLog("Local data computed checksum is \(checksum)")
            
            if (savedFileChecksum == nil || savedFileChecksum != checksum as String) {
                //NSLog("Saved file checksum is \(savedFileChecksum)")
                //NSLog("Local data computed checksum is \(checksum)")
                
                // The local data was empty or hacked. We dont want to use it.
                localData = nil
            }
        }
        
        return localData
    }
    
    class func getCloudData() -> Data? {
        // Get the store from memory
        let iCloudStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore.default()
        
        // Set data into iCloud dictionary (locally)
        let dataFromCloud = iCloudStore.data(forKey: GameData.SSiCloudGameDataKey)
        
        return dataFromCloud
    }
    
    func getSelectedCharacterData() -> CharacterData {
        if (selectedCharacter == .Warrior) {
            return warriorCharacter
        } else if (selectedCharacter == .Archer) {
            return archerCharacter
        } else if (selectedCharacter == .Mage) {
            return mageCharacter
        } else if (selectedCharacter == .Monk) {
            return monkCharacter
        }
        
        return warriorCharacter
    }
    
    func getGameProgressAllCharacters() -> Int {
        var stars: Int = 0
        
        stars = stars + getScore(self.warriorCharacter)
        stars = stars + getScore(self.archerCharacter)
        stars = stars + getScore(self.mageCharacter)
        stars = stars + getScore(self.monkCharacter)
        
        return stars
    }
    
    private func getScore(_ char: CharacterData) -> Int {
        var score: Int = 0
        
        score = score + char.totalStars
        score = score + char.totalCitrine * 5
        
        return score
    }
    
    func getLongestCitrineStreakAllCharacters() -> Int {
        var streak: Int = 0
        
        if self.warriorCharacter.longestCitrineStreak > streak {
            streak = self.warriorCharacter.longestCitrineStreak
        }
        
        if self.archerCharacter.longestCitrineStreak > streak {
            streak = self.archerCharacter.longestCitrineStreak
        }
        
        if self.monkCharacter.longestCitrineStreak > streak {
            streak = self.monkCharacter.longestCitrineStreak
        }
        
        if self.mageCharacter.longestCitrineStreak > streak {
            streak = self.mageCharacter.longestCitrineStreak
        }
        
        return streak
    }
    
    func getAverageLevelScoreAllCharacters() -> Int? {
        var bestAvg: Double = 0
        
        // If level 33 (this is level 1 of world 3)
        if !self.warriorCharacter.isLevelLocked(33) {
            // Get this characters average
            let charAvg: Double = Double(self.warriorCharacter.totalRewardsEarned) / Double(self.warriorCharacter.totalTimesPlayed)
            
            // Take the best avg
            if charAvg > bestAvg {
                bestAvg = charAvg
            }
        }
        
        // If level 33 (this is level 1 of world 3)
        if !self.archerCharacter.isLevelLocked(33) {
            // Get this characters average
            let charAvg: Double = Double(self.archerCharacter.totalRewardsEarned) / Double(self.archerCharacter.totalTimesPlayed)
            
            // Take the best avg
            if charAvg > bestAvg {
                bestAvg = charAvg
            }
        }
        
        // If level 33 (this is level 1 of world 3)
        if !self.monkCharacter.isLevelLocked(33) {
            // Get this characters average
            let charAvg: Double = Double(self.monkCharacter.totalRewardsEarned) / Double(self.monkCharacter.totalTimesPlayed)
            
            // Take the best avg
            if charAvg > bestAvg {
                bestAvg = charAvg
            }
        }
        
        // If level 33 (this is level 1 of world 3)
        if !self.mageCharacter.isLevelLocked(33) {
            // Get this characters average
            let charAvg: Double = Double(self.mageCharacter.totalRewardsEarned) / Double(self.mageCharacter.totalTimesPlayed)
            
            // Take the best avg
            if charAvg > bestAvg {
                bestAvg = charAvg
            }
        }
        
        return Int(bestAvg * 1000)
    }
    
    func getPlaysToBeatWorld4AllCharacters() -> Int? {
        var plays: Int? = nil
        
        if self.warriorCharacter.hasBeatWorld4 {
            plays = self.warriorCharacter.playsToBeatWorld4
        }
        
        if plays == nil || self.archerCharacter.hasBeatWorld4 && (self.archerCharacter.playsToBeatWorld4 < plays!) {
            plays = self.archerCharacter.playsToBeatWorld4
        }
        
        if plays == nil || self.monkCharacter.hasBeatWorld4 && (self.monkCharacter.playsToBeatWorld4 < plays!) {
            plays = self.monkCharacter.playsToBeatWorld4
        }
        
        if plays == nil || self.mageCharacter.hasBeatWorld4 && (self.mageCharacter.playsToBeatWorld4 < plays!) {
            plays = self.mageCharacter.playsToBeatWorld4
        }
        
        return plays
    }
    
    // Achievements
    func getTotalSuperstarsEarned() -> Int {
        var totalSuperstars: Int = 0
        
        totalSuperstars += self.warriorCharacter.totalCitrine
        totalSuperstars += self.archerCharacter.totalCitrine
        totalSuperstars += self.monkCharacter.totalCitrine
        totalSuperstars += self.mageCharacter.totalCitrine
        
        return totalSuperstars
    }
    
    func getTotalStarsEarned() -> Int {
        var totalStars: Int = 0
        
        totalStars += self.warriorCharacter.totalStars
        totalStars += self.archerCharacter.totalStars
        totalStars += self.monkCharacter.totalStars
        totalStars += self.mageCharacter.totalStars
        
        return totalStars
    }
    
    func getTotalChallengesCompleted() -> Int {
        var totalChallenges: Int = 0
        
        totalChallenges += self.getChallengesCompletedForCharacter(self.warriorCharacter)
        totalChallenges += self.getChallengesCompletedForCharacter(self.archerCharacter)
        totalChallenges += self.getChallengesCompletedForCharacter(self.mageCharacter)
        totalChallenges += self.getChallengesCompletedForCharacter(self.monkCharacter)
        
        return totalChallenges
    }
    
    private func getChallengesCompletedForCharacter(_ char: CharacterData) -> Int {
        var totalChallenges: Int = 0
        
        for i in 1...char.totalLevels {
            if char.levelProgress[i] != nil && char.levelProgress[i]?.challengeCompletion != nil {
                totalChallenges += char.levelProgress[i]!.challengeCompletion.count
            }
        }
        
        return totalChallenges
    }

    func getUniqueChallengesCompleted() -> Int {
        var set: Set = Set<String>()
        
        set = self.getUniqueChallengesCompletedForCharacter(self.warriorCharacter, set: set)
        set = self.getUniqueChallengesCompletedForCharacter(self.archerCharacter, set: set)
        set = self.getUniqueChallengesCompletedForCharacter(self.mageCharacter, set: set)
        set = self.getUniqueChallengesCompletedForCharacter(self.monkCharacter, set: set)
        
        return set.count
    }
    
    private func getUniqueChallengesCompletedForCharacter(_ char: CharacterData, set: Set<String>) -> Set<String> {
        var newSet: Set = set
        
        for i in 0...char.totalLevels - 1 {
            if char.levelProgress[i] != nil && char.levelProgress[i]?.challengeCompletion != nil {
                for challenge in char.levelProgress[i]!.challengeCompletion {
                    newSet.insert(challenge as! String)
                }
            }
        }
        
        return newSet
    }

    func getTotalGemsEarned() -> Int {
        return self.totalGemsCollected
    }
    
    func getTotalCharactersUnlocked() -> Int {
        var unlocked: Int = 0
        
        if self.warriorCharacter.isCharacterUnlocked {
            unlocked += 1
        }
        if self.archerCharacter.isCharacterUnlocked {
            unlocked += 1
        }
        if self.mageCharacter.isCharacterUnlocked {
            unlocked += 1
        }
        if self.monkCharacter.isCharacterUnlocked {
            unlocked += 1
        }
        
        return unlocked
    }
    
    func getNumberCharactersThatBeatWorld4() -> Int {
        var beat4: Int = 0
        
        if self.warriorCharacter.levelProgress[64] != nil && self.warriorCharacter.levelProgress[64]!.starsEarnedHighScore >= 2 {
            beat4 += 1
        }
        
        if self.archerCharacter.levelProgress[64] != nil && self.archerCharacter.levelProgress[64]!.starsEarnedHighScore >= 2 {
            beat4 += 1
        }
        
        if self.mageCharacter.levelProgress[64] != nil && self.mageCharacter.levelProgress[64]!.starsEarnedHighScore >= 2 {
            beat4 += 1
        }
        
        if self.monkCharacter.levelProgress[64] != nil && self.monkCharacter.levelProgress[64]!.starsEarnedHighScore >= 2 {
            beat4 += 1
        }
        
        return beat4
    }
    
    func getNumberCharactersThatBeatWorld5() -> Int {
        var beat5: Int = 0
        
        if self.warriorCharacter.levelProgress[80] != nil && self.warriorCharacter.levelProgress[80]!.starsEarnedHighScore >= 2 {
            beat5 += 1
        }
        
        if self.archerCharacter.levelProgress[80] != nil && self.archerCharacter.levelProgress[80]!.starsEarnedHighScore >= 2 {
            beat5 += 1
        }
        
        if self.mageCharacter.levelProgress[80] != nil && self.mageCharacter.levelProgress[80]!.starsEarnedHighScore >= 2 {
            beat5 += 1
        }
        
        if self.monkCharacter.levelProgress[80] != nil && self.monkCharacter.levelProgress[80]!.starsEarnedHighScore >= 2 {
            beat5 += 1
        }
        
        return beat5
    }
    
    func checkAndResetCharacterSkills() -> Bool {
        var reset = false
        
        var tutorialAck: Double?
        var tutorialKey: String
        var tutorialVersion: Double
        
        // First Skill
        tutorialKey = "ResetAllCharactersSkills" + CharacterType.getCharacterName(GameData.sharedGameData.selectedCharacter)
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        if tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion) {
            if GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.count > 1 {
                // Let's reset characters if needed
                GameData.sharedGameData.resetCharacterSkills(char: GameData.sharedGameData.selectedCharacter)
                reset = true
            }
            
            // Ack the reset and save
            GameData.sharedGameData.tutorialsAcknowledged[tutorialKey] = tutorialVersion
            self.save()
        }
        
        return reset
    }
    
    func resetCharacterSkills(char: CharacterType) {
        if char == CharacterType.Warrior {
            warriorCharacter.resetCharacterSkills()
        } else if char == CharacterType.Archer {
            archerCharacter.resetCharacterSkills()
        } else if char == CharacterType.Monk {
            monkCharacter.resetCharacterSkills()
        } else if char == CharacterType.Mage {
            mageCharacter.resetCharacterSkills()
        }
    }
    
    func getHeartBoostCooldown() -> Int {
        if !self.adsUnlocked {
            return GameData.heartBoostCooldown
        } else {
            return GameData.heartBoostCooldown * GameData.adsPurchasedHeartBoostMultiplier
        }
    }
    
    func configureHeartBoost(enable: Bool) {
        if enable {
            self.heartBoostCount = 1
        } else {
            self.heartBoostCount = 0
        }
    }
}
