//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Trampoline)
class Trampoline : Obstacle {    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "trampoline_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.fightingAnimatedFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "trampoline", frameStart: 0, frameEnd: 15)
        self.fightAction = SKAction.sequence([SKAction.animate(with: self.fightingAnimatedFrames, timePerFrame: 0.025, resize: true, restore: false), SKAction.run({
                self.texture = self.fightingAnimatedFrames[0]
        })])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 1.0, height: self.size.height * 0.15), center: CGPoint(x: 0, y: self.size.height * -0.475))
        
        // Determine interactions with player
        self.collidesWithPlayer = false
        self.playerCanDamage = false
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        
        // Damage
        self.damage = 0
        self.damageToShields = 0
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.Action.rawValue, waitForCompletion: false)
    }
    
    override func runAnimation() {
        // Don't do anything to start
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if self.attackCooldown <= 0.0 && self.playerContacted {
            // Launch player
            player.applyUpwardImpulseFromObject(7000)
            
            // Wait before attacking again
            self.attackCooldown = 3.0
            
            // Play animation
            self.run(self.fightAction)
            
            self.playActionSound()
        }
        
        self.playerContacted = false
        
        super.attack(timeSinceLast, player: player)
    }
    
    // TODO function override contact wiht plaeyr and setes a flag
}
