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
    
    var action = SKAction.playSoundFileNamed(SoundType.Action.rawValue, waitForCompletion: true)
    var action2 = SKAction.playSoundFileNamed(SoundType.Action2.rawValue, waitForCompletion: true)
    var air = SKAction.playSoundFileNamed(SoundType.Air.rawValue, waitForCompletion: true)
    var bubble = SKAction.playSoundFileNamed(SoundType.Bubble.rawValue, waitForCompletion: true)
    var burn = SKAction.playSoundFileNamed(SoundType.Burn.rawValue, waitForCompletion: true)
    var buzz = SKAction.playSoundFileNamed(SoundType.Buzz.rawValue, waitForCompletion: true)
    var celebrate = SKAction.playSoundFileNamed(SoundType.Celebrate.rawValue, waitForCompletion: true)
    var charge = SKAction.playSoundFileNamed(SoundType.Charge.rawValue, waitForCompletion: true)
    var click = SKAction.playSoundFileNamed(SoundType.Click.rawValue, waitForCompletion: true)
    var collision = SKAction.playSoundFileNamed(SoundType.Collision.rawValue, waitForCompletion: true)
    var contact = SKAction.playSoundFileNamed(SoundType.Contact.rawValue, waitForCompletion: true)
    var crash = SKAction.playSoundFileNamed(SoundType.Crash.rawValue, waitForCompletion: true)
    var crash2 = SKAction.playSoundFileNamed(SoundType.Crash2.rawValue, waitForCompletion: true)
    var defeat = SKAction.playSoundFileNamed(SoundType.Defeat.rawValue, waitForCompletion: true)
    var drink = SKAction.playSoundFileNamed(SoundType.Drink.rawValue, waitForCompletion: true)
    var explode = SKAction.playSoundFileNamed(SoundType.Explode.rawValue, waitForCompletion: true)
    var flame = SKAction.playSoundFileNamed(SoundType.Flame.rawValue, waitForCompletion: true)
    var hurt = SKAction.playSoundFileNamed(SoundType.Hurt.rawValue, waitForCompletion: true)
    var jump = SKAction.playSoundFileNamed(SoundType.Jump.rawValue, waitForCompletion: true)
    var jumpedOnObject = SKAction.playSoundFileNamed(SoundType.JumpedOnObject.rawValue, waitForCompletion: true)
    var lunge = SKAction.playSoundFileNamed(SoundType.Lunge.rawValue, waitForCompletion: true)
    var ogre = SKAction.playSoundFileNamed(SoundType.Ogre.rawValue, waitForCompletion: true)
    var pew = SKAction.playSoundFileNamed(SoundType.Pew.rawValue, waitForCompletion: true)
    var pow = SKAction.playSoundFileNamed(SoundType.Pow.rawValue, waitForCompletion: true)
    var projectileThrow = SKAction.playSoundFileNamed(SoundType.ProjectileThrow.rawValue, waitForCompletion: true)
    var surprise = SKAction.playSoundFileNamed(SoundType.Surprise.rawValue, waitForCompletion: true)
    var victory = SKAction.playSoundFileNamed(SoundType.Victory.rawValue, waitForCompletion: true)
    var victorySecondary = SKAction.playSoundFileNamed(SoundType.VictorySecondary.rawValue, waitForCompletion: true)
    var wind = SKAction.playSoundFileNamed(SoundType.Wind.rawValue, waitForCompletion: true)
    var zoom = SKAction.playSoundFileNamed(SoundType.Zoom.rawValue, waitForCompletion: true)
    
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
