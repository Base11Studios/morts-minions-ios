//
//  Arrow.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Lightning : Projectile {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "lightningcloud_lightning", textureAtlas: GameTextures.sharedInstance.projectilesAtlas, frameSpeed: 0.15, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        self.setDefaultPhysicsBodyValues()
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Physics
        self.moveSpeed = 0
        self.velocityRate = 0
        
        // Rewards
        self.experience = 0
        
        // Dont move it 
        self.moveObject = false
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        self.defaultYPosition -= 2.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        super.update(timeSinceLast, withPlayer: player)
    }
}
