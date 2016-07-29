//
//  Charger.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Bomber)
class Bomber : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "bomber_000", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "bomber", frameStart: 0, frameEnd: 15), timePerFrame: 0.040, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/1.3, height: self.size.height/1.3), center: CGPoint(x: -(self.size.width/11.0), y: -self.size.height/14.0))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = CGFloat(self.value1)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 3
    }
}
