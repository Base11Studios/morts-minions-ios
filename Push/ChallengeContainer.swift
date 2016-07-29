//
//  HeartBoostContainer.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/1/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class ChallengeContainer : SKNode {
    // Challenges
    var challenges: Array<LevelChallenge>
    var challengeDisplays: Array<DisplayChallenge> = Array<DisplayChallenge>()
    
    // Scene
    weak var dbScene: DBScene?
    
    // Buffer
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    // True width - accounts for word space not used
    var trueWidth: CGFloat = 0.0
    
    init(scene: DBScene, challenges: Array<LevelChallenge>) {
        // Init
        self.dbScene = scene
        self.challenges = challenges
        
        super.init()
        
        // For each challenge, create a display
        for challenge in challenges {
            let display = DisplayChallenge(scene: self.dbScene!, challenge: challenge)
            self.trueWidth = display.trueWidth
            challengeDisplays.append(display)
        }
        
        // Calculate our total height
        var totalHeight: CGFloat = 0.0
        for display in challengeDisplays {
            totalHeight += display.calculateAccumulatedFrame().size.height
        }
        
        // Set position and add to self
        // This will be our anchor
        var anchor: CGFloat = totalHeight / 2
        
        for display in challengeDisplays {
            // Set position
            display.position = CGPoint(x: 0, y: anchor - display.calculateAccumulatedFrame().size.height / 2)
            
            anchor = anchor - (display.calculateAccumulatedFrame().size.height)
            
            // Add
            self.addChild(display)
        }
    }
    
    func justUnlockedChallenge() -> Bool {
        var unlocked = false
        
        for challengeDisplay: DisplayChallenge in challengeDisplays {
            if challengeDisplay.isHighlighted {
                unlocked = true
            }
        }
        
        return unlocked
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
