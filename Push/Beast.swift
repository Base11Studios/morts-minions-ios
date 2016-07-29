//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Beast)
class Beast : Enemy {
    var fly1: Fly?
    var fly2: Fly?
    var flyYAdjust: CGFloat
    var flyXAdjust: CGFloat
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        // Create the flies
        self.flyXAdjust = 0
        self.flyYAdjust = 15 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        super.init(scalar: scalar, imageName: "beast_000", textureAtlas: GameTextures.sharedInstance.earthAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "beast", frameStart: 0, frameEnd: 15), timePerFrame: 0.075, resize: true, restore: false))
        
        // Create flies
        self.fly1 = Fly(scalar: 1.0, defaultYPosition: defaultYPosition, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
        self.fly2 = Fly(scalar: 1.0, defaultYPosition: defaultYPosition, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
        
        self.fly1!.position = CGPoint(x: defaultXPosition, y: defaultYPosition)
        self.fly2!.position = CGPoint(x: defaultXPosition, y: defaultYPosition)
        
        self.fly1!.nextPosition = CGPoint(x: defaultXPosition, y: defaultYPosition)
        self.fly2!.nextPosition = CGPoint(x: defaultXPosition, y: defaultYPosition)
        
        self.gameScene!.addEnvironmentObject(environmentObject: self.fly1!)
        self.gameScene!.addEnvironmentObject(environmentObject: self.fly2!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.9), center: CGPoint(x: self.size.width * -0.05, y: self.size.height * -0.05))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 70
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 575 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // move the fly randomly within the range
        /*
        let fly1y = (CGFloat(arc4random_uniform(3)) + -1) * 2
        let fly1x = (CGFloat(arc4random_uniform(3)) + -1) * 2
        
        let fly2y = (CGFloat(arc4random_uniform(3)) + -1) * 2
        let fly2x = (CGFloat(arc4random_uniform(3)) + -1) * 2
        
        self.fly1Adjust.x += fly1x
        self.fly1Adjust.y += fly1y
        self.fly2Adjust.x += fly2x
        self.fly2Adjust.y += fly2y
        
        // If anything over range, reset it
        if self.fly1Adjust.x > self.flyMaxXDistance + flyXAdjust {
            self.fly1Adjust.x = self.flyMaxXDistance + flyXAdjust
        } else if self.fly1Adjust.x < 0 - self.flyMaxXDistance + flyXAdjust {
            self.fly1Adjust.x = 0 - self.flyMaxXDistance + flyXAdjust
        }
        
        if self.fly1Adjust.y > self.flyMaxYDistance + flyYAdjust {
            self.fly1Adjust.y = self.flyMaxYDistance + flyYAdjust
        } else if self.fly1Adjust.y < 0 - self.flyMaxYDistance + flyYAdjust {
            self.fly1Adjust.y = 0 - self.flyMaxYDistance + flyYAdjust
        }
        
        // If anything over range, reset it
        if self.fly2Adjust.x > self.flyMaxXDistance + flyXAdjust {
            self.fly2Adjust.x = self.flyMaxXDistance + flyXAdjust
        } else if self.fly2Adjust.x < 0 - self.flyMaxXDistance + flyXAdjust {
            self.fly2Adjust.x = 0 - self.flyMaxXDistance + flyXAdjust
        }
        
        if self.fly2Adjust.y > self.flyMaxYDistance + flyYAdjust {
            self.fly2Adjust.y = self.flyMaxYDistance + flyYAdjust
        } else if self.fly2Adjust.y < 0 - self.flyMaxYDistance + flyYAdjust {
            self.fly2Adjust.y = 0 - self.flyMaxYDistance + flyYAdjust
        }
        
        self.fly1!.nextPosition = CGPointMake(self.position.x + self.fly1Adjust.x + self.flyXAdjust, self.position.y + self.fly1Adjust.y + self.flyYAdjust)
        self.fly2!.nextPosition = CGPointMake(self.position.x + self.fly2Adjust.x + self.flyXAdjust, self.position.y + self.fly2Adjust.y + self.flyYAdjust)
        */
        
        self.fly1!.nextPosition = CGPoint(x: self.position.x + (5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*4)) + self.flyXAdjust, y: self.position.y + (10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*4)) + self.flyYAdjust)
        self.fly2!.nextPosition = CGPoint(x: self.position.x + (5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*4)) + self.flyXAdjust, y: self.position.y + (10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*4)) + self.flyYAdjust)
        
        super.update(timeSinceLast, withPlayer: player)
        
        // Update flies
        self.fly1!.update(timeSinceLast, withPlayer: player)
        self.fly2!.update(timeSinceLast, withPlayer: player)
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
        
        // Update flies
        self.fly1!.updateAfterPhysics()
        self.fly2!.updateAfterPhysics()
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.fly1!.stopPositionAdjustment == false && (self.position.x - player.position.x) < self.lineOfSight {
            // Launch fly 1 at the enemy
            self.fly1!.physicsBody!.applyImpulse(CGVector(dx: -5000, dy: 0))
            self.fly1!.stopPositionAdjustment = true
            self.fly1!.defaultYPosition = self.position.y + self.flyYAdjust
            self.fly1!.startingYPosition = self.fly1!.defaultYPosition
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Zoom)
        }
        
        // The player is in sight of the enemy
        if self.fly2!.stopPositionAdjustment == false && (self.position.x - player.position.x) < self.lineOfSight - (180 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)) {
            // Launch fly 2 at the enemy
            self.fly2!.physicsBody!.applyImpulse(CGVector(dx: -5000, dy: 0))
            self.fly2!.stopPositionAdjustment = true
            self.fly2!.defaultYPosition = self.position.y + self.flyYAdjust
            self.fly2!.startingYPosition = self.fly2!.defaultYPosition
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Zoom)
        }
    }
}
