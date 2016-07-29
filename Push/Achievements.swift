//
//  Leaderboards.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/11/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation
// IF ADDING AN ACHIEVEMENT MAKE SURE TO ADD TO ALLVALUES FUNC
enum Achievements : String {
//Acquire by completing 5 challenge objectives on any levels
//You beat 5 challenges!
    case Beat1Challenge = "com.mm.achieve.beat1challenge"
    case Beat5Challenges = "com.mm.achieve.beat5challenges"
    case Beat15Challenges = "com.mm.achieve.beat15challenges"
    case Beat30Challenges = "com.mm.achieve.beat30challenges"
    case Beat60Challenges = "com.mm.achieve.beat60challenges"
    case Beat100Challenges = "com.mm.achieve.beat100challenges"
    case Beat250Challenges = "com.mm.achieve.beat150challenges"
    case Beat500Challenges = "com.mm.achieve.beat500challenges"

// Beat 5 Types of Challenges
// Acquire by completing 5 different types of challenges
// You beat 5 types of challenges!
    case ChallengeTypesBeat5 = "com.mm.achieve.challengetypesbeat5"
    case ChallengeTypesBeat10 = "com.mm.achieve.challengetypesbeat10"
    case ChallengeTypesBeat15 = "com.mm.achieve.challengetypesbeat15"
    case ChallengeTypesBeat20 = "com.mm.achieve.challengetypesbeat20"
    case ChallengeTypesBeat25 = "com.mm.achieve.challengetypesbeat25"
    case ChallengeTypesBeat30 = "com.mm.achieve.challengetypesbeat30"

// Collect a Superstar
// Collect 5 Superstars
// Acquire by collecting a superstar on any level
// Acquire by collecting 5 superstars on any levels
// You collected a superstar!
// You collected 5 superstars!
    case Earn1SuperStar = "com.mm.achieve.earn1superstar"
    case Earn5SuperStars = "com.mm.achieve.earn5superstars"
    case Earn10SuperStars = "com.mm.achieve.earn10superstars"
    case Earn25SuperStars = "com.mm.achieve.earn25superstars"
    case Earn50SuperStars = "com.mm.achieve.earn50superstars"
    case Earn100SuperStars = "com.mm.achieve.earn100superstars"
    case Earn250SuperStars = "com.mm.achieve.earn250superstars"
    case Earn500SuperStars = "com.mm.achieve.earn500superstars"
    case Earn1000SuperStars = "com.mm.achieve.earn1000superstars"
    case Earn2500SuperStars = "com.mm.achieve.earn2500superstars"
    case Earn5000SuperStars = "com.mm.achieve.earn5000superstars"
    
// Collect a Star
// Collect 5 Stars
// Acquire by collecting a star on any level
// Acquire by collecting 5 stars on any levels
// You collected a star!
// You collected 5 stars!
    case Earn1Star = "com.mm.achieve.earn1star"
    case Earn10Stars = "com.mm.achieve.earn10stars"
    case Earn25Stars = "com.mm.achieve.earn25stars"
    case Earn50Stars = "com.mm.achieve.earn50stars"
    case Earn100Stars = "com.mm.achieve.earn100stars"
    case Earn200Stars = "com.mm.achieve.earn200stars"
    case Earn350Stars = "com.mm.achieve.earn350stars"
    case Earn500Stars = "com.mm.achieve.earn500stars"
    case Earn750Stars = "com.mm.achieve.earn750stars"
    case Earn1000Stars = "com.mm.achieve.earn1000stars"
   
//Acquire by unlocking a new character
//You unlocked a character!
    case UnlockACharacter = "com.mm.achieve.unlockacharacter"
    case Unlock2Characters = "com.mm.achieve.unlock2characters"


// TODO 3 below need to be entered in iTunes    
    case UpgradeASkillFully = "com.mm.achieve.upgradeaskillfully"
    case UnlockEverySkillOnACharacter = "com.mm.achieve.unlockeveryskillonacharacter"
    case UpgradeEverySkillFullyOnACharacter = "com.mm.achieve.unlockeveryskillfullyonacharacter"
   
// Collect 5 Gems
// Acquire by collecting 5 gems. Spent gems also count towards this total.
// You have collected 5 gems across your journey!
    case Collect5GemsAccumulative = "com.mm.achieve.collect5gemsaccumulative"
    case Collect15GemsAccumulative = "com.mm.achieve.collect15gemsaccumulative"
    case Collect25GemsAccumulative = "com.mm.achieve.collect25gemsaccumulative"
    case Collect50GemsAccumulative = "com.mm.achieve.collect50gemsaccumulative"
    case Collect100GemsAccumulative = "com.mm.achieve.collect100gemsaccumulative"
    case Collect250GemsAccumulative = "com.mm.achieve.collect250gemsaccumulative"
    case Collect500GemsAccumulative = "com.mm.achieve.collect500gemsaccumulative"
    case Collect1000GemsAccumulative = "com.mm.achieve.collect1000gemsaccumulative"
    case Collect2500GemsAccumulative = "com.mm.achieve.collect2500gemsaccumulative"
    case Collect5000GemsAccumulative = "com.mm.achieve.collect5000gemsaccumulative"
    case Collect10000GemsAccumulative = "com.mm.achieve.collect10000gemsaccumulative"
    
// Beat All Challenges in World 1
// Acquire by completing all the challenge objectives in World 1
// You beat all the challenges in World 1!

// Collect All Stars in World 1
// Acquire by collecting all the stars in World 1
// You collected all the stars in World 1!

// Collect All Superstars in World 1
// Acquire by collecting all the Superstars in World 1
// You collected all the Superstars in World 1!
    case World1AllChallengesBeat = "com.mm.achieve.world1allchallengesbeat" // Unlocks after beating every challenge in world 1
    case World1AllStarsEarned = "com.mm.achieve.world1allstarsearned" // All stars from world 1 are earned. Does not inlude superstars
    case World1AllSuperstarsEarned = "com.mm.achieve.world1allsuperstarsearned" // All superstars from world 1 are earned
    
    case World2AllChallengesBeat = "com.mm.achieve.world2allchallengesbeat" // Unlocks after beating every challenge in world 2
    case World2AllStarsEarned = "com.mm.achieve.world2allstarsearned" // All stars from world 2 are earned. Does not inlude superstars
    case World2AllSuperstarsEarned = "com.mm.achieve.world2allsuperstarsearned" // All superstars from world 2 are earned
    
    case World3AllChallengesBeat = "com.mm.achieve.world3allchallengesbeat" // Unlocks after beating every challenge in world 3
    case World3AllStarsEarned = "com.mm.achieve.world3allstarsearned" // All stars from world 3 are earned. Does not inlude superstars
    case World3AllSuperstarsEarned = "com.mm.achieve.world3allsuperstarsearned" // All superstars from world 3 are earned
    
    case World4AllChallengesBeat = "com.mm.achieve.world4allchallengesbeat" // Unlocks after beating every challenge in world 4
    case World4AllStarsEarned = "com.mm.achieve.world4allstarsearned" // All stars from world 4 are earned. Does not inlude superstars
    case World4AllSuperstarsEarned = "com.mm.achieve.world4allsuperstarsearned" // All superstars from world 4 are earned
    
// Reach World 2
// Acquire by unlocking and playing World 2
// You reached World 2!
    case ReachWorld2 = "com.mm.achieve.reachworld2" // Unlocks at the start of a world 2 level
    case ReachWorld3 = "com.mm.achieve.reachworld3" // Unlocks at the start of a world 3 level
    case ReachWorld4 = "com.mm.achieve.reachworld4" // Unlocks at the start of a world 4 level
    
// Beat Chapter 1
// Acquire by collecting at least 2 stars on World 4 Level 16
// You beat Chapter 1!

// Beat Chapter 1 With 2 Characters
// Acquire by collecting at least 2 stars on World 4 Level 16 with 2 characters
// You beat Chapter 1 with 2 characters!
    case BeatChapter1World1To4 = "com.mm.achieve.beatchapter1world1to4" // Get at least 2 stars on World 4 level 16
    case BeatChapter1TwoCharacters = "com.mm.achieve.beatchapter1twocharacters" // Get at least 2 stars on World 4 level 16 on 2 characters
    case BeatChapter1ThreeCharacters = "com.mm.achieve.beatchapter1threecharacters" // Get at least 2 stars on World 4 level 16 on 3 characters
    case BeatChapter1FourCharacters = "com.mm.achieve.beatchapter1fourcharacters" // Get at least 2 stars on World 4 level 16 on 4 characters
    
// Complete a Level With 3 Health Remaining
// Acquire by completing a level with at least 3 health remaining
// You beat a level with 3 health remaining!
    case CompleteALevelWith3HealthRemaining = "com.mm.achieve.completealevelwith3healthremaining"
    case CompleteALevelWith4HealthRemaining = "com.mm.achieve.completealevelwith4healthremaining"
    case CompleteALevelWith5HealthRemaining = "com.mm.achieve.completealevelwith5healthremaining"
    case CompleteALevelWith6HealthRemaining = "com.mm.achieve.completealevelwith6healthremaining"
    case CompleteALevelWith7HealthRemaining = "com.mm.achieve.completealevelwith7healthremaining"
    case CompleteALevelWith8HealthRemaining = "com.mm.achieve.completealevelwith8healthremaining"
    
    static func allValues() -> Array<Achievements> {
        var achievements = Array<Achievements>()
        achievements.append(Achievements.Beat1Challenge)
        achievements.append(Achievements.Beat5Challenges)
        achievements.append(Achievements.Beat15Challenges)
        achievements.append(Achievements.Beat30Challenges)
        achievements.append(Achievements.Beat60Challenges)
        achievements.append(Achievements.Beat100Challenges)
        achievements.append(Achievements.Beat250Challenges)
        achievements.append(Achievements.Beat500Challenges)
        
        achievements.append(Achievements.ChallengeTypesBeat5)
        achievements.append(Achievements.ChallengeTypesBeat10)
        achievements.append(Achievements.ChallengeTypesBeat15)
        achievements.append(Achievements.ChallengeTypesBeat20)
        achievements.append(Achievements.ChallengeTypesBeat25)
        achievements.append(Achievements.ChallengeTypesBeat30)
        
        achievements.append(Achievements.Earn1SuperStar)
        achievements.append(Achievements.Earn5SuperStars)
        achievements.append(Achievements.Earn10SuperStars)
        achievements.append(Achievements.Earn25SuperStars)
        achievements.append(Achievements.Earn50SuperStars)
        achievements.append(Achievements.Earn100SuperStars)
        achievements.append(Achievements.Earn250SuperStars)
        achievements.append(Achievements.Earn500SuperStars)
        achievements.append(Achievements.Earn1000SuperStars)
        achievements.append(Achievements.Earn2500SuperStars)
        achievements.append(Achievements.Earn5000SuperStars)
        
        achievements.append(Achievements.Earn1Star)
        achievements.append(Achievements.Earn10Stars)
        achievements.append(Achievements.Earn25Stars)
        achievements.append(Achievements.Earn50Stars)
        achievements.append(Achievements.Earn100Stars)
        achievements.append(Achievements.Earn200Stars)
        achievements.append(Achievements.Earn350Stars)
        achievements.append(Achievements.Earn500Stars)
        achievements.append(Achievements.Earn750Stars)
        achievements.append(Achievements.Earn1000Stars)
        
        achievements.append(Achievements.UnlockACharacter)
        achievements.append(Achievements.Unlock2Characters)
        achievements.append(Achievements.UpgradeASkillFully)
        achievements.append(Achievements.UnlockEverySkillOnACharacter)
        achievements.append(Achievements.UpgradeEverySkillFullyOnACharacter)
        
        achievements.append(Achievements.Collect5GemsAccumulative)
        achievements.append(Achievements.Collect15GemsAccumulative)
        achievements.append(Achievements.Collect25GemsAccumulative)
        achievements.append(Achievements.Collect50GemsAccumulative)
        achievements.append(Achievements.Collect100GemsAccumulative)
        achievements.append(Achievements.Collect250GemsAccumulative)
        achievements.append(Achievements.Collect500GemsAccumulative)
        achievements.append(Achievements.Collect1000GemsAccumulative)
        achievements.append(Achievements.Collect2500GemsAccumulative)
        achievements.append(Achievements.Collect5000GemsAccumulative)
        achievements.append(Achievements.Collect10000GemsAccumulative)
        
        achievements.append(Achievements.World1AllChallengesBeat)
        achievements.append(Achievements.World1AllStarsEarned)
        achievements.append(Achievements.World1AllSuperstarsEarned)
        achievements.append(Achievements.World2AllChallengesBeat)
        achievements.append(Achievements.World2AllStarsEarned)
        achievements.append(Achievements.World2AllSuperstarsEarned)
        achievements.append(Achievements.World3AllChallengesBeat)
        achievements.append(Achievements.World3AllStarsEarned)
        achievements.append(Achievements.World3AllSuperstarsEarned)
        achievements.append(Achievements.World4AllChallengesBeat)
        achievements.append(Achievements.World4AllStarsEarned)
        achievements.append(Achievements.World4AllSuperstarsEarned)
        
        achievements.append(Achievements.ReachWorld2)
        achievements.append(Achievements.ReachWorld3)
        achievements.append(Achievements.ReachWorld4)
        achievements.append(Achievements.BeatChapter1World1To4)
        achievements.append(Achievements.BeatChapter1TwoCharacters)
        achievements.append(Achievements.BeatChapter1ThreeCharacters)
        achievements.append(Achievements.BeatChapter1FourCharacters)
        
        achievements.append(Achievements.CompleteALevelWith3HealthRemaining)
        achievements.append(Achievements.CompleteALevelWith4HealthRemaining)
        achievements.append(Achievements.CompleteALevelWith5HealthRemaining)
        achievements.append(Achievements.CompleteALevelWith6HealthRemaining)
        achievements.append(Achievements.CompleteALevelWith7HealthRemaining)
        achievements.append(Achievements.CompleteALevelWith8HealthRemaining)
        
        return achievements
    }
}