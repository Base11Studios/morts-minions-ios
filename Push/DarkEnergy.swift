//
//  BombBat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//



import Foundation

@objc(DarkEnergy)
class DarkEnergy : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "darkenergy_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        let animArray = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "darkenergy", frameStart: 0, frameEnd: 15)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: animArray, timePerFrame: 0.03, resize: true, restore: false))
        
        // Set the walking frames for animation
        self.walkingAnimatedFrames = animArray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 2, height: self.size.height / 4), center: CGPoint(x: 0, y: 0))
        
        self.setDefaultPhysicsBodyValues()
        
        // ** OVERRIDE ** - This is a flying object
        self.setFlyingObjectProperties()
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.startingYPosition = self.defaultYPosition
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = CGFloat(self.value2) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        self.alpha = 0.0
        
        // Rewards
        self.experience = 1
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }

    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        let scalar: CGFloat = 2.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        for i in 0 ..< self.walkingAnimatedFrames.count {
            if self.texture!.isEqual(self.walkingAnimatedFrames[i]) {
                switch i {
                case 0, 1, 2, 3, 4, 5, 6, 7:
                    self.defaultYPosition = self.self.startingYPosition + (CGFloat(i) * 1.5 * scalar)
                case 8, 9, 10, 11, 12, 13, 14, 15:
                    self.defaultYPosition = self.self.startingYPosition + (((22.5) - CGFloat(i) * 1.5) * scalar)
                default:
                    self.defaultYPosition = self.startingYPosition
                }
            }
        }
        
        super.update(timeSinceLast, withPlayer: player)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && (self.position.x - player.position.x) < self.lineOfSight{
            self.alpha = 1
            
            // Set the cooldown really high, this will be reset when the attack finishes
            self.attackCooldown = 100.0
        }
    }
    
    override func checkHealth() {
        super.checkHealth()
        
        if !self.isAlive {
            self.alpha = 1
        }
    }
}
