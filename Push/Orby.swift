//
//  Fireball.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc (Orby)
class Orby : Enemy {
    var stopPositionAdjustment: Bool = false
    var flyUpwardsFirst: Bool
    var flightPath: CGFloat = 1
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        self.flyUpwardsFirst = true
        
        super.init(scalar: scalar, imageName: "orby_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "orby", frameStart: 0, frameEnd: 15), timePerFrame: 0.01, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.65, height: self.size.height * 0.8), center: CGPoint(x: self.size.width * -0.0, y: self.size.height * 0.0))
        
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value2) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 0
        
        self.moveSpeed = 135
        
        // Sine wave
        self.startingYPosition = self.defaultYPosition
        
        if !self.flyUpwardsFirst {
            self.flightPath = -1
        }
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        self.defaultYPosition = self.startingYPosition + (30 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive) * CGFloat(self.value1))) * flightPath
        
        super.update(timeSinceLast, withPlayer: player)
    }
}
