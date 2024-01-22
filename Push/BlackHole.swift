//
//  Mimic.swift
//  Push
//
//  Created by Dan Bellinski on 10/15/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(BlackHole)
class BlackHole : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "blackhole_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "blackhole", frameStart: 0, frameEnd: 15), timePerFrame: 0.03, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.2, height: self.size.height * 0.2), center: CGPoint(x: 0, y: 0))
        setDefaultPhysicsBodyValues()
        
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        // Position overrides
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 280 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        
        // Rewards
        self.experience = self.maxHealth
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if (self.position.x - player.position.x) < self.lineOfSight && self.attackCooldown <= 0 {
            self.moveSpeed *= 4
            self.velocityRate *= 5
            
            // Move in direction of player
            self.isFloating = true
            self.isFlying = false
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: (player.position.y - self.position.y) * 1200 / ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            
            // Remove ground collision
            self.physicsBody!.collisionBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory | GameScene.playerPetCategory
            self.physicsBody!.contactTestBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory | GameScene.playerPetCategory
            
            self.attackCooldown = 100
            
            self.playActionSound(action: SoundHelper.sharedInstance.lunge)
        }
    }
}