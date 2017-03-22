//
//  PlayerEagle.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class PlayerFairy: PlayerProjectile {
    var nextPosition: CGPoint
    var stopPositionAdjustment: Bool = false
    var flyUpwardsFirst: Bool
    var minimumHeight: CGFloat = 0
    var maxYChangeWhenHoming: CGFloat = 5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var lastAdjustedYPosition: CGFloat = 0.0
    var range: CGFloat = 0
    var homingObject: EnvironmentObject?
    var projectiles = Array<PlayerProjectile>()
    
    // Attached skills
    weak var attachedSkill: CharacterSkillDetails?
    
    init(attachedSkill: CharacterSkillDetails, gameScene: GameScene, range: CGFloat) {
        self.range = range
        self.flyUpwardsFirst = true
        nextPosition = CGPoint(x: 0, y: 0)
        
        // Attach to skill
        self.attachedSkill = attachedSkill
        
        let texture = GameTextures.sharedInstance.projectilesAtlas.textureNamed("fairy_000")
        
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.projectilesAtlas, texturesNamed: "fairy", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false))
        
        self.run(self.walkAction)
        
        // Set scale
        self.setScale(CGFloat(attachedSkill.value))
        
        // Create shootbacks
        for _ in 0 ..< Int(self.attachedSkill!.secondaryValue) * 8 {
            // Create projectile
            let projectile: PlayerFairyBolt = PlayerFairyBolt(gameScene: self.gameScene!)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.type = EnvironmentObjectType.Ignored
            projectile.isHidden = true
            
            // Set up initial location of projectile
            projectile.position = CGPoint(x: 0, y: 0)
            
            projectile.zPosition = 9
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            gameScene.worldView.addChild(projectile)
            
            self.projectiles.append(projectile)
        }
    }
    
    override func setupTraits() {
        // Add physics
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.4, height: self.size.height * 1.0), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        
        self.setDefaultPhysicsBodyValues()
        
        // Movement speed
        self.walkSpeed = 475.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.runSpeed = 475.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.moveSpeed = self.walkSpeed
        
        // Acceleration
        self.velocityRate = 1.0 // used for movement calculation
    }
    
    override func setDefaultCollisionMasks() {
        // Collisions
        self.physicsBody!.categoryBitMask = GameScene.playerPetCategory
        self.physicsBody!.contactTestBitMask = GameScene.enemyCategory | GameScene.obstacleCategory | GameScene.projectileCategory | GameScene.transparentEnemyCategory
        self.physicsBody!.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateAfterPhysics() {
        if !self.attachedSkill!.cooldownInProgress {
            super.updateAfterPhysics()
            
            /*
            if !self.needsToExecuteDeath {
                // Home existing target, or look for one
                if self.homingObject != nil && self.homingObject!.isAlive {
                    if !self.isFlying {
                        self.isFlying = true
                        self.defaultYPosition = self.position.y
                    }
                    
                    if self.defaultYPosition - self.homingObject!.position.y > self.maxYChangeWhenHoming {
                        self.defaultYPosition -= self.maxYChangeWhenHoming
                    } else if self.defaultYPosition - self.homingObject!.position.y < -self.maxYChangeWhenHoming {
                        self.defaultYPosition += self.maxYChangeWhenHoming
                    } else {
                        self.defaultYPosition = self.homingObject!.position.y
                    }
                } else {
                    // Try to find a new guy to home
                    self.findATarget()
                }
              
                // If not target, move in circle
                if self.homingObject == nil {
                    self.setFlyPosition()
                }
            }*/
            
            self.setFlyPosition()
        }
    }
    
    func setFlyPosition() {
        // Set fly positions
        self.position = CGPoint(x: self.nextPosition.x, y: self.nextPosition.y)
        self.lastAdjustedYPosition = self.nextPosition.y
        self.physicsBody!.velocity = CGVector()
    }
    
    /*
    func findATarget() {
        var closestObject: EnvironmentObject?
        
        // Iterate through all enemies to find someone close
        for object in self.gameScene!.worldViewEnvironmentObjects {
            if (object.type == EnvironmentObjectType.Enemy ||
                object.type == EnvironmentObjectType.Obstacle) && object.isAlive && !object.isBeingTargeted && object.playerCanDamage {
                if closestObject == nil {
                    if object.position.x - (50 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)) > self.position.x && abs(self.position.y - object.position.y) <= self.range && abs(self.position.x - object.position.x) < self.range {
                        closestObject = object
                    }
                } else {
                    if object.position.x - (50 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)) > self.position.x && object.position.x < closestObject!.position.x && abs(self.position.y - object.position.y) <= (self.range * ScaleBuddy.sharedInstance.getGameScaleAmount(false)) {
                        closestObject = object
                    }
                }
            }
        }
        
        // If we found something to attack, let's do it
        if closestObject != nil {
            self.homingObject = closestObject
            self.homingObject!.isBeingTargeted = true
        }
    }*/
    
    override func executeDeath() {
        if self.physicsBody!.categoryBitMask != GameScene.deathCategory {
            // Hide it
            self.isHidden = true
            self.numberOfContacts = 0
            self.homingObject = nil
            self.removeAllActions()
            
            // Set bool back to go back to where we need to be
            self.stopPositionAdjustment = false
            self.needsToExecuteDeath = false
            
            // Set physics colls
            self.physicsBody!.categoryBitMask = GameScene.deathCategory
            self.physicsBody!.contactTestBitMask = 0
            self.physicsBody!.collisionBitMask = 0
            
            if !self.attachedSkill!.cooldownInProgress {
                self.putSkillOnCooldown()
            }
            
            // Shoot back
            for i in 0 ..< Int(self.attachedSkill!.secondaryValue) {
                let arrow: PlayerFairyBolt = self.projectiles.popLast() as! PlayerFairyBolt
                
                arrow.position = CGPoint(x: self.position.x, y: self.position.y)
                
                // Change the name back to default so it receives updates
                arrow.resetName()
                
                // Unhide it
                arrow.isHidden = false
                
                // Set physics body back
                arrow.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
                
                self.gameScene!.worldViewPlayerProjectiles.append(arrow)
                
                arrow.physicsBody!.applyImpulse(CGVector(dx: 8000.0, dy: 2000.0 * CGFloat(i)))
                
                self.playActionSound(action: SoundHelper.sharedInstance.projectileThrow)
            }
        }
    }
    
    func reset() {
        // Unhide
        self.isHidden = false
        self.numberOfContacts = 1
        
        // Reset position
        self.setFlyPosition()
        
        // Animation
        self.run(self.walkAction)
        
        // Bring back collision
        self.setDefaultCollisionMasks()
    }
    
    func putSkillOnCooldown() {
        // Set the skill to cooldown
        self.attachedSkill!.cooldownInProgress = true
        self.attachedSkill!.previouslyCoolingDown = true
        
        // This is how long until it can be used again
        self.attachedSkill!.activeCooldownCount = self.attachedSkill!.maxCooldownCount
    }
}
