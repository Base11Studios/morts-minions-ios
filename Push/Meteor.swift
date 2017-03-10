//
//  Arrow.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Meteor : Projectile {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "obsmeteor", textureAtlas: GameTextures.sharedInstance.spiritAtlas, frameSpeed: 0.15, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.setDefaultPhysicsBodyValues()
        
        // Physics Overrides
        self.physicsBody!.affectedByGravity = true // FALLS
        self.physicsBody!.mass = 5.0
        self.velocityRate = 0.2
        self.physicsBody!.restitution = 0.5
        
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
