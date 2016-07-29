//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Shark)
class Shark : Enemy {
    var speedUp: Bool = true
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "shark_000", textureAtlas: GameTextures.sharedInstance.waterAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.waterAtlas, texturesNamed: "shark", frameStart: 0, frameEnd: 15), timePerFrame: 0.075, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.5), center: CGPoint(x: self.size.width * -0.00, y: self.size.height * 0.1))
        
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        // Position overrides
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Boost it a little
        self.collisionRebound *= 1.3
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if self.attackCooldown <= 0.0 {
            if self.speedUp {
                self.moveSpeed = self.moveSpeed * 3
                self.attackCooldown = 0.15
                //SoundHelper.sharedInstance.playSound(self, sound: SoundType.Lunge)
            } else {
                self.moveSpeed = self.moveSpeed / 3
                self.attackCooldown = 0.50
            }
            
            self.speedUp = !self.speedUp
        }
        
        super.attack(timeSinceLast, player: player)
    }
}
