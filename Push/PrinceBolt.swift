//
//  Arrow.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class PrinceBolt : Projectile {
    var yGrowth: CGFloat = 0
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {

        super.init(scalar: scalar, imageName: "mage_energy_000", textureAtlas: GameTextures.sharedInstance.projectilesAtlas, frameSpeed: 0.15, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.projectilesAtlas, texturesNamed: "mage_energy", frameStart: 0, frameEnd: 15), timePerFrame: 0.005, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        self.setDefaultPhysicsBodyValues()
        self.velocityRate = 0.25
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        
        self.walkSpeed = 300
        self.runSpeed = self.walkSpeed
        self.moveSpeed = self.walkSpeed
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 0
        
        self.startingYPosition = self.defaultYPosition
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
        
        self.defaultYPosition = self.defaultYPosition + (self.yGrowth * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * 1.5)
    }
}
