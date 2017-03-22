//
//  Enemy.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Enemy)
class Enemy : EnvironmentObject {
    var hasVerticalVelocity: Bool = false
    
    static func getHealth(_ enemyClass: AnyClass) -> Int {
        // If the class has more than 1 HP, have to add it here, otherwise 1 is default
        if enemyClass is Crab.Type || enemyClass is Prowler.Type || enemyClass is KingTempus.Type  {
            return 2
        }
        
        return 1
    }
    
    // Physics
    var velocityRate: CGFloat = 0.2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    // Attributes
    var lineOfSight: CGFloat = 0.0
    
    func setupTraitsWithScalar(_ scalar: Double) {
        preconditionFailure("This method must be overriden by the subclass")
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    init(scalar : Double, imageName: String, textureAtlas: SKTextureAtlas, defaultYPosition: CGFloat, value1: Double, value2: Double, scene: GameScene) {
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
        self.name = "environmentobject_enemy_\(UUID().uuidString)"
        self.type = EnvironmentObjectType.Enemy
    }

    func initializeAttributes() {
        resetName()
        
        // Enemy specific
        self.hasHeartsToCollect = true
        
        // ** Environment Object **
        self.isWalking = true
        self.isRunning = false
        self.isFighting = false
        self.isAlive = true
        self.isFlying = false
        self.isJumping = false
        self.isCoiling = false
        self.isContinuouslyJumping = false
        self.collidesWithPlayer = true
        
        // Set default attributes for enemies all to 1
        self.health = 1
        self.maxHealth = 1
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = self.maxHealth
    }
    
    func setDefaultPhysicsBodyValues() {
        self.physicsBody!.isDynamic = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.usesPreciseCollisionDetection = OptimizerBuddy.sharedInstance.usePreciseCollisionDetection()
        self.physicsBody!.affectedByGravity = true
        
        // Collisions
        self.physicsBody!.categoryBitMask = GameScene.enemyCategory
        self.physicsBody!.contactTestBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory | GameScene.groundCategory | GameScene.transparentPlayerCategory | GameScene.playerPetCategory
        self.physicsBody!.collisionBitMask = GameScene.playerProjectileCategory | GameScene.playerCategory | GameScene.groundCategory | GameScene.playerPetCategory
        
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
            // Collision movement
            if self.justCollidedWithPlayer {
                //NSLog("Enemy Collided: X %f, Y %f, PREVX %f, PREXY %f, PREVPREVX %f, PREVPREVY %f, WID %f, HEIGHT %f", self.position.x, self.position.y, self.previousPosition.x, self.previousPosition.y, self.previousPreviousPosition.x, self.previousPreviousPosition.y, self.size.width, self.size.height)
                
                // The X velocity is about 0, we're not moving forward, we collided with something in front of us
                //if self.physicsBody!.velocity.dx >= -0.1 && self.previousVelocity.dx != 0 {  // we're moving backwards
                if self.needsToBeKnockedBack {
                    self.physicsBody!.applyImpulse(CGVector(dx: self.collisionRebound * self.physicsBody!.mass, dy: 0.0))
                }
                
                self.justCollidedWithPlayer = false
                self.needsToBeKnockedBack = false
                
                // Check to see if player changed directions #BUG_FIX when a collision can happen on corners and player doesn't change direction due to restitution but enemy was getting damaged ~ 7/1/2015
                // 4/2/2016 - this is causing issues when enemy and player are both moving up. Want to only enforce the just changed directions check if player velocity has negative Y
                // 7/9/2016 - this was causing issues for player landing on flamey when flamey is going back down. Added check to see if downward velocity is slower now
                //NSLog("prev: \(player.previousVelocity.dy)")
                //NSLog("now: \(player.physicsBody!.velocity.dy)")
                if player.justChangedDirections || self.hasVerticalVelocity { //player.physicsBody!.velocity.dy >= 0 || (player.previousVelocity.dy - player.physicsBody!.velocity.dy) < 0 {
                    self.takeDamageFromPlayer(player)
                }
            }
            
            self.checkHealth()
            
            // Attack
            self.attack(timeSinceLast, player: player)
            
            if self.isAlive {
                // Move the enemy
                self.move(player)
            }
        }
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
    }
    
    func move(_ player: SKSpriteNode) {
        // Set the enemy velocity. This is opposite of the player to keep them moving forward.
        let relativeVelocity: CGVector = CGVector(dx: -(self.moveSpeed + self.physicsBody!.velocity.dx), dy: 0)
        
        var moveX: Bool = true
        
        // Don't move the X in these circumstances
        if (self.isJumping || self.isCoiling) && self.physicsBody!.velocity.dx < 0 {
            moveX = false
        }
        
        let isFloating = NSNumber(value: self.isFloating)
        let intMoveX = NSNumber(value: moveX)
        
        self.physicsBody!.velocity = CGVector(dx: (self.physicsBody!.velocity.dx + relativeVelocity.dx * self.velocityRate) * CGFloat(intMoveX), dy: (self.physicsBody!.velocity.dy + relativeVelocity.dy * self.velocityRate) * CGFloat(isFloating))
    }
}
