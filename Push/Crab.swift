//
//  Ogre.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Crab)
class Crab : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "crab_000", textureAtlas: GameTextures.sharedInstance.waterAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.waterAtlas, texturesNamed: "crab", frameStart: 0, frameEnd: 15), timePerFrame: 0.025, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.9), center: CGPoint(x: self.size.width * -0.05, y: self.size.height * -0.05))
        
        setDefaultPhysicsBodyValues()
        
        // Attributes
        self.lineOfSight = 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        self.maxHealth = 2
        self.health = self.maxHealth
    }
}
