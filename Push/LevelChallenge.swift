//
//  LevelChallenge.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/12/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

public class LevelChallenge {
    var challengeType: ChallengeType
    var completed: Bool
    var reward: Int
    
    init(challengeType: ChallengeType, completed: Bool, reward: Int) {
        self.challengeType = challengeType
        self.completed = completed
        self.reward = reward
    }
    
    func getDescription() -> String {
        return challengeType.getDescription()
    }
}