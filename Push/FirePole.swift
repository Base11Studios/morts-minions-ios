//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(FirePole)
class FirePole : Obstacle {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "firepole_000", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "firepole", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.8, height: self.size.height * 1), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        
        // Determine interactions with player
        self.collidesWithPlayer = true
        self.playerCanDamage = true
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Health
        self.health = 1
        self.maxHealth = 1
    }
}
