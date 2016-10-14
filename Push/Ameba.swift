//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Ameba)
class Ameba : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "ameba_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "ameba", frameStart: 0, frameEnd: 15), timePerFrame: 0.04, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.7), center: CGPoint(x: self.size.width * -0.05, y: self.size.height * -0.15))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 100
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 450 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        self.numberOfAttacks = Int(self.value1)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if (self.position.x - player.position.x) < self.lineOfSight && self.isFloating == false && self.numberOfAttacks > 0 {
            self.isFloating = true
            self.numberOfAttacks -= 1
            
            // Random number from 3000 to 6500
            //self.physicsBody?.applyImpulse(CGVectorMake(0, CGFloat(arc4random_uniform(3501)) + 3000))
            
            // We want gravity now
            self.physicsBody!.affectedByGravity = true
            
            self.physicsBody!.applyImpulse(CGVector(dx:-6500, dy: 6500))
            
            self.playActionSound(action: SoundHelper.sharedInstance.surprise)
        }
    }
}
