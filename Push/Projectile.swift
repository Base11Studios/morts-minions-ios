//
//  Projectile.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Projectile)
class Projectile : EnvironmentObject {
    // Move it
    var moveObject: Bool = true
    
    // Physics
    var velocityRate : CGFloat = 0.2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    // Texture arrays
    var movingAnimatedFrames = Array<SKTexture>()
    
    func setupTraitsWithScalar(_ scalar: Double) {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(scalar: Double, imageName: String, textureAtlas: SKTextureAtlas, frameSpeed: TimeInterval, defaultYPosition: CGFloat, value1: Double, value2: Double, scene: GameScene) {
        super.init(imageName: imageName, textureAtlas: textureAtlas, scene: scene)
        
        self.initializeAttributes()
        
        // Passed in values
        self.value1 = value1
        self.value2 = value2
        
        // Scaling // TODOSCALE remove once new images
        self.setScale(ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        self.defaultYPosition = defaultYPosition + self.size.height / 2
        
        self.setupTraitsWithScalar(scalar)
    }

    required init(scalar: Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        fatalError("init(scalar:defaultYPosition:) has not been implemented")
    }
    
    func resetName() {
        self.name = "environmentobject_projectile_\(UUID().uuidString)"
        // Type
        self.type = EnvironmentObjectType.Projectile
    }
    
    func initializeAttributes() {
        resetName()
        
        // ** Environment Object **
        self.isWalking = true
        self.isRunning = false
        self.isAlive = true
        self.isFlying = true // All projectiles are flying
        self.collidesWithPlayer = false
        
        // Physics
        self.defaultRestitution = 0.85
        
        // Movement speed
        self.walkSpeed = 275.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.runSpeed = self.walkSpeed// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.moveSpeed = self.walkSpeed
        
        // Acceleration
        self.velocityRate = 1.0 // used for movement calculation
    }
    
    func setDefaultPhysicsBodyValues() {
        self.physicsBody!.isDynamic = true
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.usesPreciseCollisionDetection = OptimizerBuddy.sharedInstance.usePreciseCollisionDetection()
        self.physicsBody!.affectedByGravity = false
        
        // Collisions
        self.physicsBody!.categoryBitMask = GameScene.projectileCategory
        self.physicsBody!.contactTestBitMask = GameScene.playerCategory | GameScene.groundCategory | GameScene.transparentPlayerCategory | GameScene.playerPetCategory
        self.physicsBody!.collisionBitMask = GameScene.groundCategory
        
        // Physics Body settings
        self.physicsBody!.restitution = self.defaultRestitution
        self.physicsBody!.mass = self.defaultMass
        self.physicsBody!.friction = self.defaultFriction
        self.physicsBody!.linearDamping = self.defaultLinearDamping
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        super.update(timeSinceLast, withPlayer: player)
        if self.isAlive {
            if self.justCollidedWithPlayer { // TODO this if statement logic needs to be implemented in the obstacle too
                self.takeDamageFromPlayer(player)
                
                self.justCollidedWithPlayer = false
            }
            
            // Move the enemy
            if self.moveObject {
                self.move(player)
            }
            self.checkHealth()
        }
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
    }
    
    func move(_ player: SKSpriteNode) {
        // TODO - need to factor in anything for timeSinceLast??
        
        // Set the enemy velocity. This is opposite of the player to keep them moving forward.
        let relativeVelocity: CGVector = CGVector(dx: -(self.moveSpeed + self.physicsBody!.velocity.dx), dy: self.physicsBody!.velocity.dy)
        
        // Enemies don't jump (or at least not yet) so Y won't change
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx + relativeVelocity.dx * self.velocityRate, dy: self.physicsBody!.velocity.dy)
    }
}
