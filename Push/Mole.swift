//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Mole)
class Mole : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "moley_000", textureAtlas: GameTextures.sharedInstance.earthAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "moley", frameStart: 0, frameEnd: 15), timePerFrame: 0.075, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.9), center: CGPoint(x: self.size.width * 0.1, y: self.size.height * -0.05))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 120
        //self.defaultYPosition = self.defaultYPosition - self.size.height // Start right below the ground
        
        // We dont want to collide with the ground to start
        self.physicsBody!.collisionBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory
        
        // We dont want the enemy falling since it isnt on the ground
        self.physicsBody!.affectedByGravity = false
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Attacks
        self.numberOfAttacks = 1
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        if self.justInitialized {
            // Move the Y position down to start underground
            self.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height / 1.2)
            self.justInitialized = false
        }
        
        super.update(timeSinceLast, withPlayer: player)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // If the player wasn't colliding with the ground but is now above the ground, collide
        if self.position.y - self.size.height / 2 > self.groundYPosition && self.physicsBody!.collisionBitMask == GameScene.playerProjectileCategory | GameScene.playerCategory {
            self.physicsBody!.collisionBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory | GameScene.groundCategory
        }
        
        // The player is in sight of the enemy
        if (self.position.x - player.position.x) < self.lineOfSight && self.isFloating == false && self.numberOfAttacks > 0 {
            self.isFloating = true
            self.numberOfAttacks -= 1
            
            // Random number from 3000 to 6500
            //self.physicsBody?.applyImpulse(CGVectorMake(0, CGFloat(arc4random_uniform(3501)) + 3000))
            
            // We want gravity now
            self.physicsBody!.affectedByGravity = true
            
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 7000))
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Surprise)
        }
    }
}
