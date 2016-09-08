//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Lungey)
class Lungey : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "lungey_running_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "lungey_running", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false))
        
        self.floatAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "lungey_jumping", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.3, height: self.size.height * 0.85), center: CGPoint(x: -self.size.width * 0.4, y: self.size.height * -0.075))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 120
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Attacks
        self.numberOfAttacks = 1
        
        // This is for collision detection
        self.hasVerticalVelocity = true
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.Lunge.rawValue, waitForCompletion: true)
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        if self.justCollidedWithGround {
            self.isWalking = true
            self.isFloating = false
            self.updateAnimation()
            
            self.justCollidedWithGround = false
        }
        
        super.update(timeSinceLast, withPlayer: player)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if (self.position.x - player.position.x) < self.lineOfSight && self.isFloating == false && self.numberOfAttacks > 0 {
            self.isFloating = true
            self.isWalking = false
            
            self.numberOfAttacks -= self.numberOfAttacks
            
            self.physicsBody!.applyImpulse(CGVector(dx: -20000, dy: 5000))
            
            self.updateAnimation()
            
            self.playActionSound()
        }
    }
}
