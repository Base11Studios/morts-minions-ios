//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(HummingBird)
class HummingBird : Enemy {
    var dropLow: Bool = false
    var dropCount: Int = 0
    var maxDropCount: Int = 0
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "bat_000", textureAtlas: GameTextures.sharedInstance.earthAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "bat", frameStart: 0, frameEnd: 15), timePerFrame: 0.02, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 2, height: self.size.height / 3), center: CGPoint(x: -(self.size.width / 4.0), y: self.size.height / 16.0))
        
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        // Position overrides
        self.defaultYPosition = self.defaultYPosition + 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.moveSpeed = self.moveSpeed * 0.8
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Attacking
        self.maxAttackCooldown = 0.35
        self.attackCooldown = 0.0
        
        // Custom
        self.dropCount = 4
        self.maxDropCount = 4
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        if self.attackCooldown <= 0 {
            if self.dropLow {
                self.defaultYPosition -= 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            } else {
                self.defaultYPosition += 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            }
            
            self.dropCount -= 1
            
            if self.dropCount == 0 {
                self.dropCount = self.maxDropCount
                
                // Reverse direction
                self.dropLow = !self.dropLow
                
                // Set the cooldown back to start again
                self.attackCooldown = self.maxAttackCooldown
            }
            
            //SoundHelper.sharedInstance.playSound(self, sound: SoundType.Buzz)
        }
    }
}
