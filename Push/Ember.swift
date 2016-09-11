//
//  Charger.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Ember)
class Ember : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "ember_000", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "ember", frameStart: 0, frameEnd: 15), timePerFrame: 0.040, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.6, height: self.size.height * 0.6), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        
        setDefaultPhysicsBodyValues()
        
        // ** OVERRIDE ** - This is a flying object
        self.setFlyingObjectProperties()
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value2) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Physics overrides
        self.moveSpeed = 0
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 250 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 3
        
        // Attacking
        self.maxAttackCooldown = 1.0
        self.attackCooldown = 0.0
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && (self.position.x - player.position.x) < self.lineOfSight {
            // Set move speed to 0 to stop movement
            self.moveSpeed = CGFloat(self.value1)
            self.velocityRate *= 5
            
            // Move in direction of player
            self.isFloating = true
            self.isFlying = false
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: (player.position.y - self.position.y) * 1200 / ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            
            // Remove ground collision
            self.physicsBody!.collisionBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory
            self.physicsBody!.contactTestBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory
            
            // Set the cooldown really high, this will be reset when the attack finishes
            self.attackCooldown = 100.0
            
            self.playActionSound(action: SoundHelper.sharedInstance.lunge)
        }
    }
}
