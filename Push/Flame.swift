//
//  Arrow.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Flame : Projectile {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "geyserfire_000", textureAtlas: GameTextures.sharedInstance.projectilesAtlas, frameSpeed: 0.15, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.projectilesAtlas, texturesNamed: "geyserfire", frameStart: 0, frameEnd: 15), timePerFrame: 0.025, resize: true, restore: false))
        
        //self.run(self.walkAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.8), center: CGPoint(x: self.size.width * 0, y: self.size.height * -0.1))
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
}
