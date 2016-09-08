//
//  SoundHelper.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 4/16/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation
class SoundHelper {
    static let sharedInstance = SoundHelper()
    
    func playSound(_ object: SKNode, sound: SoundType) {
        if GameData.sharedGameData.preferenceSoundEffects {
            object.run(SKAction.playSoundFileNamed(sound.rawValue, waitForCompletion: true))
        }
    }
    
    func playSoundAction(_ object: SKNode, action: SKAction) {
        if GameData.sharedGameData.preferenceSoundEffects {
            object.run(action)
        }
    }
}
