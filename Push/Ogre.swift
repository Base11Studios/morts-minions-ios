//
//  Ogre.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Ogre)
class Ogre : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "ogre_000", textureAtlas: GameTextures.sharedInstance.earthAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "ogre", frameStart: 0, frameEnd: 15), timePerFrame: 0.075, resize: true, restore: false))
        
        self.setScale(self.xScale * 0.945)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        //self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width / 1.6, self.size.height / 1.05), center: CGPointMake((self.size.width / 6.0), 0.0))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.625, height: self.size.height * 0.95), center: CGPoint(x: self.size.width / 6.0, y: self.size.height * -0.025))
        
        setDefaultPhysicsBodyValues()
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 3
        
        self.attackCooldown = 3
        self.maxAttackCooldown = 3
        
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.Ogre.rawValue, waitForCompletion: false)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        super.attack(timeSinceLast, player: player)
        
        if self.attackCooldown <= 0 {
            self.attackCooldown = self.maxAttackCooldown
            
            self.playActionSound()
        }
    }
}
