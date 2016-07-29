//
//  Fireball.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc (Fly)
class Fly : Projectile {
    var nextPosition: CGPoint
    var stopPositionAdjustment: Bool = false
    var flyUpwardsFirst: Bool
    var flightPath: CGFloat = 1
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        self.flyUpwardsFirst = true
        
        nextPosition = CGPoint(x: 0, y: 0)
        
        super.init(scalar: scalar, imageName: "fly_000", textureAtlas: GameTextures.sharedInstance.projectilesAtlas, frameSpeed: 0.15, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.projectilesAtlas, texturesNamed: "fly", frameStart: 0, frameEnd: 15), timePerFrame: 0.01, resize: true, restore: false))
        
        //self.run(self.walkAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.25, height: self.size.height * 0.33), center: CGPoint(x: self.size.width * -0.125, y: self.size.height * 0.167))
        
        self.setDefaultPhysicsBodyValues()
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 0
        
        // Sine wave
        self.startingYPosition = self.defaultYPosition
        
        if !self.flyUpwardsFirst {
            self.flightPath = -1
        }
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()

        if !self.isFrozen {
            if self.stopPositionAdjustment == false {
                // Set fly positions
                self.position = CGPoint(x: self.nextPosition.x, y: self.nextPosition.y)
            } else {
                self.defaultYPosition = self.startingYPosition + (20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*3)) * flightPath
            }
        }
    }
}
