//
//  Enemy.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Obstacle)
class Obstacle : EnvironmentObject {
    // Attributes
    var lineOfSight : CGFloat = 0.0;
    
    func setupTraitsWithScalar(_ scalar: Double) {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    init(scalar: Double, imageName: String, textureAtlas: SKTextureAtlas, defaultYPosition: CGFloat, value1: Double, value2: Double, scene: GameScene) {
        // Initialize with superclass
        super.init(imageName: imageName, textureAtlas: textureAtlas, scene: scene)
        
        // Initialize the attributes
        self.initializeAttributes()
        
        // Passed in values
        self.value1 = value1
        self.value2 = value2
        
        // Scaling // TODOSCALE remove once new images
        self.setScale(ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        // Get the ground position
        self.groundYPosition = defaultYPosition
        
        // Set the Y position
        self.defaultYPosition = defaultYPosition + self.size.height / 2
        
        self.setupTraitsWithScalar(scalar)
    }
    
    func resetName() {
        self.name = "environmentobject_obstacle_\(UUID().uuidString)"
        // Type
        self.type = EnvironmentObjectType.Obstacle
    }
    
    func initializeAttributes() {
        resetName()
        
        // Obstacle specific
        self.hasHeartsToCollect = false
        
        // ** Environment Object **
        self.isAlive = true
        
        self.collidesWithPlayer = true
        self.playerCanDamage = true
        
        // Set default attributes for enemies all to 1
        self.health = 1
        self.maxHealth = 1
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 0
    }
    
    func setDefaultPhysicsBodyValues() {
        self.physicsBody!.isDynamic = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.usesPreciseCollisionDetection = OptimizerBuddy.sharedInstance.usePreciseCollisionDetection()
        self.physicsBody!.affectedByGravity = true
        
        // Collisions
        if self.collidesWithPlayer {
            self.physicsBody!.categoryBitMask = GameScene.obstacleCategory
            self.physicsBody!.collisionBitMask = GameScene.playerProjectileCategory | GameScene.playerPetCategory | GameScene.playerCategory | GameScene.groundCategory /*| GameScene.transparentPlayerCategory*/
            self.physicsBody!.contactTestBitMask = GameScene.playerCategory | GameScene.groundCategory | GameScene.transparentPlayerCategory
        } else {
            self.physicsBody!.categoryBitMask = GameScene.transparentObstacleCategory
            self.physicsBody!.collisionBitMask = GameScene.groundCategory
            self.physicsBody!.contactTestBitMask = GameScene.groundCategory
        }
        
        // Physics Body settings
        self.physicsBody!.restitution = self.defaultRestitution
        self.physicsBody!.mass = self.defaultMass
        self.physicsBody!.friction = self.defaultFriction
        self.physicsBody!.linearDamping = self.defaultLinearDamping
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        super.update(timeSinceLast, withPlayer: player)
        
        // Check to see if the enemy is still alive
        if self.isAlive {
            // Check to see if player changed directions #BUG_FIX when a collision can happen on corners and player doesn't change direction due to restitution but enemy was getting damaged
            if self.justCollidedWithPlayer && self.collidesWithPlayer && player.justChangedDirections {
                self.justCollidedWithPlayer = false
                
                // Check to see if player changed directions #BUG_FIX when a collision can happen on corners and player doesn't change direction due to restitution but enemy was getting damaged
                if player.justChangedDirections {
                    self.takeDamageFromPlayer(player)
                }
            }
            
            self.justCollidedWithPlayer = false
            
            self.checkHealth()
            
            // Attack
            self.attack(timeSinceLast, player: player)
        }
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
    }
}
