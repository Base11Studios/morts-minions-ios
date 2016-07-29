//
//  FallingBomb.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(FallingBomb)
class FallingBomb : Projectile {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "fireball_000", textureAtlas: GameTextures.sharedInstance.projectilesAtlas, frameSpeed: 0.15, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.projectilesAtlas, texturesNamed: "fireball", frameStart: 0, frameEnd: 1), timePerFrame: 0.15, resize: true, restore: false))
        
        //self.run(self.walkAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.8), center: CGPoint(x: self.size.width * -0.05, y: self.size.height * 0.0))
        self.setDefaultPhysicsBodyValues()
        
        // Physics Overrides
        self.physicsBody!.affectedByGravity = true // FALLS
        self.physicsBody!.mass = 5.0
        self.velocityRate = 0.2
        self.physicsBody!.restitution = 0.75
        
        self.moveSpeed = 120
        self.walkSpeed = 120
        
        // Flag Overrides
        self.isFlying = false
        self.isFalling = true
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 0
    }
}
