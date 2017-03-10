//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(PulseOrb)
class PulseOrb : Obstacle {

    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "pulseorb_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
            
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "pulseorb", frameStart: 0, frameEnd: 15), timePerFrame: 0.125, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.75)
        
        // Determine interactions with player
        self.collidesWithPlayer = true
        self.playerCanDamage = true
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()

        // Damage
        self.damage = 2
        self.damageToShields = 1
        
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.startingYPosition = self.defaultYPosition
    
        // Health
        self.health = 1
        self.maxHealth = 1
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
        
        self.defaultYPosition = self.startingYPosition + (40 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*4))
    }
}
