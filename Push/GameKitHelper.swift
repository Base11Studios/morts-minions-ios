//
//  GameKitHelper.swift
//  Push
//
//  Created by Dan Bellinski on 03/11/16.
//  Copyright © 2015 Dan Bellinski. All rights reserved.

// Adapted from an Objective C class GameKitHelper from Ray Wenderlich tutorials:
//  Copyright (c) 2010, 2011 Ray Wenderlich
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

let PresentAuthenticationViewController: String = "present_authentication_view_controller"
let LocalPlayerIsAuthenticated: String = "local_player_authenticated"
let LocalPlayerNotAuthenticated: String = "local_player_not_authenticated"

class GameKitHelper: NSObject {
    // Singleton
    static let sharedInstance = GameKitHelper()
    
    var authenticationViewController: UIViewController?
    var lastError: Error?
    var enableGameCenter: Bool = true
    var waitingForAchievementsToReturn: Bool = false
    var waitingForAchievementsToReport: Bool = false
    var achievementsCompleted = Array<GKAchievement>()
    var triedToAuthenticate: Bool = true
    var lastAchievementReturnAttempt: Date
    
    override init() {
        let calendar = NSCalendar.autoupdatingCurrent
        self.lastAchievementReturnAttempt = calendar.date(byAdding: Calendar.Component.minute, value: -2, to: Date())!
        
        super.init()
    }
    
    func authenticateLocalPlayer(_ promptUserOfFailure: Bool) {
        if !GameData.sharedGameData.getSelectedCharacterData().godMode {
            let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
            if localPlayer.isAuthenticated {
                NotificationCenter.default.post(name: Notification.Name(rawValue: LocalPlayerIsAuthenticated), object: nil)
                return
            }

            localPlayer.authenticateHandler = {(viewController : UIViewController?, error : Error?) -> Void in
                if (error != nil) {
                    self.lastError = error
                } else {
                    self.lastError = nil
                }
                
                if ((viewController) != nil) {
                    self.triedToAuthenticate = true
                    self.setupAuthenticationViewController(viewController!)
                } else if GKLocalPlayer.localPlayer().isAuthenticated {
                    self.enableGameCenter = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: LocalPlayerIsAuthenticated), object: nil)
                } else {
                    if promptUserOfFailure {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: LocalPlayerNotAuthenticated), object: nil)
                    }
                    self.enableGameCenter = false
                    self.triedToAuthenticate = true
                }
            }
        } else {
            self.enableGameCenter = false
        }
    }
    
    func setupAuthenticationViewController(_ authenticationViewController: UIViewController) {
        self.authenticationViewController = authenticationViewController
        NotificationCenter.default.post(name: Notification.Name(rawValue: PresentAuthenticationViewController), object: self)
    }
    
    func updateScores() {
        if !GameData.sharedGameData.getSelectedCharacterData().godMode {
            // Gems collected
            let gems: Int = GameData.sharedGameData.totalGemsCollected
            
            if GameData.sharedGameData.bestRecordedGemsCollected == nil || gems > GameData.sharedGameData.bestRecordedGemsCollected! {
                GameData.sharedGameData.bestRecordedGemsCollected = gems
            }
            
            // Game Progress
            let progress: Int = GameData.sharedGameData.getGameProgressAllCharacters()
            
            if GameData.sharedGameData.bestRecordedGameProgress == nil || progress > GameData.sharedGameData.bestRecordedGameProgress! {
                GameData.sharedGameData.bestRecordedGameProgress = progress
            }
            
            // Longest Streak
            let streak: Int = GameData.sharedGameData.getLongestCitrineStreakAllCharacters()
            
            if GameData.sharedGameData.bestRecordedLongestSuperstarStreak == nil || streak > GameData.sharedGameData.bestRecordedLongestSuperstarStreak! {
                GameData.sharedGameData.bestRecordedLongestSuperstarStreak = streak
            }
            
            // Average level score
            let average: Int? = GameData.sharedGameData.getAverageLevelScoreAllCharacters()
            
            if average != nil && GameData.sharedGameData.bestRecordedAverageLevelScore == nil || average! > GameData.sharedGameData.bestRecordedAverageLevelScore! {
                GameData.sharedGameData.bestRecordedAverageLevelScore = average
            }
            
            // Plays to beat 4
            let plays4: Int? = GameData.sharedGameData.getPlaysToBeatWorld4AllCharacters()
            
            if plays4 != nil && GameData.sharedGameData.bestRecordedPlaysToBeatWorld4 == nil || plays4! > GameData.sharedGameData.bestRecordedPlaysToBeatWorld4! {
                GameData.sharedGameData.bestRecordedPlaysToBeatWorld4 = plays4
            }
            
            //self.resyncScores()
        }
    }
    
    func resyncScores() {
        if enableGameCenter {
            self.syncLeaderboard()
            //self.syncAchievements()
        }
    }
    
    func syncLeaderboard() {
        var scores = Array<GKScore>()
        
        // Gems collected
        if GameData.sharedGameData.bestRecordedGemsCollected != nil {
            let score = GKScore(leaderboardIdentifier: Leaderboards.GemsCollectedGroup.rawValue)
            score.value = Int64(GameData.sharedGameData.bestRecordedGemsCollected!)
            scores.append(score)
        }
        
        // Game Progress
        if GameData.sharedGameData.bestRecordedGameProgress != nil {
            let score = GKScore(leaderboardIdentifier: Leaderboards.GameProgressGroup.rawValue)
            score.value = Int64(GameData.sharedGameData.bestRecordedGameProgress!)
            scores.append(score)
        }
        
        // Longest Streak
        if GameData.sharedGameData.bestRecordedLongestSuperstarStreak != nil {
            let score = GKScore(leaderboardIdentifier: Leaderboards.LongestSuperstarStreakSolo.rawValue)
            score.value = Int64(GameData.sharedGameData.bestRecordedLongestSuperstarStreak!)
            scores.append(score)
        }
        
        // Average Level Score
        if GameData.sharedGameData.bestRecordedAverageLevelScore != nil {
            let score = GKScore(leaderboardIdentifier: Leaderboards.AverageLevelScoreSolo.rawValue)
            score.value = Int64(GameData.sharedGameData.bestRecordedAverageLevelScore!)
            scores.append(score)
        }
        
        // Plays to beat 4
        if GameData.sharedGameData.bestRecordedPlaysToBeatWorld4 != nil {
            let score = GKScore(leaderboardIdentifier: Leaderboards.PlaysToBeatWorld4Solo.rawValue)
            score.value = Int64(GameData.sharedGameData.bestRecordedPlaysToBeatWorld4!)
            scores.append(score)
        }
        
        // Report scores if we have something new
        if !scores.isEmpty {
            GKScore.report(scores, withCompletionHandler: { (error: Error?) in
                //NSLog("\(error.debugDescription)")
            })
        }
    }
    
    func checkCharacterAchievements() {
        var achievementsToCheck = Array<Achievements>()
        achievementsToCheck.append(Achievements.UnlockACharacter)
        achievementsToCheck.append(Achievements.Unlock2Characters)
        
        for achievement in achievementsToCheck {
            if lookUpCharacterAchievementSuccess(achievement) {
                // Add it to the gamedata array
                GameData.sharedGameData.achievementsCompleted.add(achievement.rawValue)
            } // If not then the achievement wasn't met
        }
        
        //self.syncAchievements()
    }
    
    // put all char check achievements here
    func lookUpCharacterAchievementSuccess(_ achievement: Achievements) -> Bool {
        if !GameData.sharedGameData.achievementsCompleted.contains(achievement.rawValue) { // TODO will this contains work?
            switch achievement {
            case .UnlockACharacter:
                if GameData.sharedGameData.getTotalCharactersUnlocked() >= 3 {
                    return true
                }
            case .Unlock2Characters:
                if GameData.sharedGameData.getTotalCharactersUnlocked() >= 4 {
                    return true
                }
            default:
                return false
            }
        }
        
        return false
    }
    
    func checkLevelIntroAchievements(_ scene: GameScene) {
        var achievementsToCheck = Array<Achievements>()
        achievementsToCheck.append(Achievements.ReachWorld2)
        achievementsToCheck.append(Achievements.ReachWorld3)
        achievementsToCheck.append(Achievements.ReachWorld4)
        
        for achievement in achievementsToCheck {
            if lookUpLevelIntroAchievementSuccess(scene, achievement: achievement) {
                // Add it to the gamedata array
                GameData.sharedGameData.achievementsCompleted.add(achievement.rawValue)
            } // If not then the achievement wasn't met
        }
    }
    
    // put all level intro check achievements here
    func lookUpLevelIntroAchievementSuccess(_ scene: GameScene, achievement: Achievements) -> Bool {
        if !GameData.sharedGameData.achievementsCompleted.contains(achievement.rawValue) { // TODO will this contains work?
            switch achievement {
            case .ReachWorld2:
                if scene.worldNumber > 1 {
                    return true
                }
            case .ReachWorld3:
                if scene.worldNumber > 2 {
                    return true
                }
            case .ReachWorld4:
                if scene.worldNumber > 3 {
                    return true
                }
            default:
                return false
            }
        }
        
        return false
    }
    
    func checkAchievements(_ score: LevelScore) {
        for achievement in Achievements.allValues() {
            if lookUpAchievementSuccess(score, achievement: achievement) {
                // Add it to the gamedata array
                GameData.sharedGameData.achievementsCompleted.add(achievement.rawValue)
            } // If not then the achievement wasn't met
        }
        
        //self.syncAchievements()
    }
    
    // put all end of level check achievements here
    func lookUpAchievementSuccess(_ score: LevelScore, achievement: Achievements) -> Bool {
        if !GameData.sharedGameData.achievementsCompleted.contains(achievement.rawValue) { // TODO will this contains work?
            switch achievement {
            case .Earn1SuperStar:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 1 {
                    return true
                }
            case .Earn5SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 5 {
                    return true
                }
            case .Earn10SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 10 {
                    return true
                }
            case .Earn25SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 25 {
                    return true
                }
            case .Earn50SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 50 {
                    return true
                }
            case .Earn100SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 100 {
                    return true
                }
            case .Earn250SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 250 {
                    return true
                }
            case .Earn500SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 500 {
                    return true
                }
            case .Earn1000SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 1000 {
                    return true
                }
            case .Earn2500SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 2500 {
                    return true
                }
            case .Earn5000SuperStars:
                if GameData.sharedGameData.getTotalSuperstarsEarned() >= 5000 {
                    return true
                }
            case .Beat1Challenge:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 1 {
                    return true
                }
            case .Beat5Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 5 {
                    return true
                }
            case .Beat15Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 15 {
                    return true
                }
            case .Beat30Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 30 {
                    return true
                }
            case .Beat60Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 60 {
                    return true
                }
            case .Beat100Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 100 {
                    return true
                }
            case .Beat250Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 250 {
                    return true
                }
            case .Beat500Challenges:
                if GameData.sharedGameData.getTotalChallengesCompleted() >= 500 {
                    return true
                }
            case .ChallengeTypesBeat5:
                if GameData.sharedGameData.getUniqueChallengesCompleted() >= 5 {
                    return true
                }
            case .ChallengeTypesBeat10:
                if GameData.sharedGameData.getUniqueChallengesCompleted() >= 10 {
                    return true
                }
            case .ChallengeTypesBeat15:
                if GameData.sharedGameData.getUniqueChallengesCompleted() >= 15 {
                    return true
                }
            case .ChallengeTypesBeat20:
                if GameData.sharedGameData.getUniqueChallengesCompleted() >= 20 {
                    return true
                }
            case .ChallengeTypesBeat25:
                if GameData.sharedGameData.getUniqueChallengesCompleted() >= 25 {
                    return true
                }
            case .ChallengeTypesBeat30:
                if GameData.sharedGameData.getUniqueChallengesCompleted() >= 30 {
                    return true
                }
            case .Earn1Star:
                if GameData.sharedGameData.getTotalStarsEarned() >= 1 {
                    return true
                }
            case .Earn10Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 10 {
                    return true
                }
            case .Earn25Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 25 {
                    return true
                }
            case .Earn50Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 50 {
                    return true
                }
            case .Earn100Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 100 {
                    return true
                }
            case .Earn200Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 200 {
                    return true
                }
            case .Earn350Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 350 {
                    return true
                }
            case .Earn500Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 500 {
                    return true
                }
            case .Earn750Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 750 {
                    return true
                }
            case .Earn1000Stars:
                if GameData.sharedGameData.getTotalStarsEarned() >= 1000 {
                    return true
                }
            case .Collect5GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 5 {
                    return true
                }
            case .Collect15GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 15 {
                    return true
                }
            case .Collect25GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 25 {
                    return true
                }
            case .Collect50GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 50 {
                    return true
                }
            case .Collect100GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 100 {
                    return true
                }
            case .Collect250GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 250 {
                    return true
                }
            case .Collect500GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 500 {
                    return true
                }
            case .Collect1000GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 1000 {
                    return true
                }
            case .Collect2500GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 2500 {
                    return true
                }
            case .Collect5000GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 5000 {
                    return true
                }
            case .Collect10000GemsAccumulative:
                if GameData.sharedGameData.getTotalGemsEarned() >= 10000 {
                    return true
                }
            case .World1AllStarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allStarsEarnedForWorld(1) {
                    return true
                }
            case .World2AllStarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allStarsEarnedForWorld(2) {
                    return true
                }
            case .World3AllStarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allStarsEarnedForWorld(3) {
                    return true
                }
            case .World4AllStarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allStarsEarnedForWorld(4) {
                    return true
                }
            case .World1AllSuperstarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allSuperstarsEarnedForWorld(1) {
                    return true
                }
            case .World2AllSuperstarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allSuperstarsEarnedForWorld(2) {
                    return true
                }
            case .World3AllSuperstarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allSuperstarsEarnedForWorld(3) {
                    return true
                }
            case .World4AllSuperstarsEarned:
                if GameData.sharedGameData.getSelectedCharacterData().allSuperstarsEarnedForWorld(4) {
                    return true
                }
            case .World1AllChallengesBeat:
                if GameData.sharedGameData.getSelectedCharacterData().allChallengesEarnedForWorld(1) {
                    return true
                }
            case .World2AllChallengesBeat:
                if GameData.sharedGameData.getSelectedCharacterData().allChallengesEarnedForWorld(2) {
                    return true
                }
            case .World3AllChallengesBeat:
                if GameData.sharedGameData.getSelectedCharacterData().allChallengesEarnedForWorld(3) {
                    return true
                }
            case .World4AllChallengesBeat:
                if GameData.sharedGameData.getSelectedCharacterData().allChallengesEarnedForWorld(4) {
                    return true
                }
            case .BeatChapter1World1To4:
                if GameData.sharedGameData.getNumberCharactersThatBeatWorld4() >= 1 {
                    return true
                }
            case .BeatChapter1TwoCharacters:
                if GameData.sharedGameData.getNumberCharactersThatBeatWorld4() >= 2 {
                    return true
                }
            case .BeatChapter1ThreeCharacters:
                if GameData.sharedGameData.getNumberCharactersThatBeatWorld4() >= 3 {
                    return true
                }
            case .BeatChapter1FourCharacters:
                if GameData.sharedGameData.getNumberCharactersThatBeatWorld4() >= 4 {
                    return true
                }
            case .CompleteALevelWith3HealthRemaining:
                if score.heartsRemaining >= 3 {
                    return true
                }
            case .CompleteALevelWith4HealthRemaining:
                if score.heartsRemaining >= 4 {
                    return true
                }
            case .CompleteALevelWith5HealthRemaining:
                if score.heartsRemaining >= 5 {
                    return true
                }
            case .CompleteALevelWith6HealthRemaining:
                if score.heartsRemaining >= 6 {
                    return true
                }
            case .CompleteALevelWith7HealthRemaining:
                if score.heartsRemaining >= 7 {
                    return true
                }
            case .CompleteALevelWith8HealthRemaining:
                if score.heartsRemaining >= 8 {
                    return true
                }
            default:
                return false
            }
        }
        
        return false
    }
    
    func getAchievements() {
        // Add a minute to last attempt
        let calendar = NSCalendar.autoupdatingCurrent
        let untilDate = calendar.date(byAdding: Calendar.Component.minute, value: 1, to: self.lastAchievementReturnAttempt)
        
        if enableGameCenter && !self.waitingForAchievementsToReport && (!self.waitingForAchievementsToReturn || untilDate! < Date() ) {
            self.waitingForAchievementsToReturn = true
            self.lastAchievementReturnAttempt = Date()
            
            GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
                if error == nil {
                    if achievements != nil {
                        self.achievementsCompleted.removeAll()
                        self.achievementsCompleted = achievements!
                    }
                    
                    self.waitingForAchievementsToReturn = false
                }
            })
        }
    }
    
    func syncAchievements() {
        //for achievement in GameData.sharedGameData.achievementsCompleted {
            //NSLog("Achievement obtained \(achievement)")
        //}
        
        if enableGameCenter && !self.waitingForAchievementsToReturn {
            var achievements = Array<GKAchievement>() // This will be sent to GameCenter
            
            for completedAchievement in GameData.sharedGameData.achievementsCompleted {
                var alreadySent = false
                
                for achievement in self.achievementsCompleted {
                    if achievement.identifier == completedAchievement as? String && achievement.isCompleted == true {
                        alreadySent = true
                    }
                }
                
                if !alreadySent {
                    let reportAchievement = GKAchievement.init(identifier: completedAchievement as? String)
                    reportAchievement.percentComplete = 100
                    reportAchievement.showsCompletionBanner = true
                    achievements.append(reportAchievement)
                }
            }
            
            if !achievements.isEmpty {
                self.waitingForAchievementsToReport = true
                // Report to GameKit
                GKAchievement.report(achievements, withCompletionHandler: { (error: Error?) in
                    self.waitingForAchievementsToReport = false
                })
            }
        }
    }
}
