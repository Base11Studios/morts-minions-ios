//
//  PlayerEagle.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class PlayerEagle: PlayerProjectile {
    var nextPosition: CGPoint
    var stopPositionAdjustment: Bool = false
    var flyUpwardsFirst: Bool
    var minimumHeight: CGFloat = 0
    var maxYChangeWhenHoming: CGFloat = 4 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var keepTryingToHome: Bool = true
    var lastAdjustedYPosition: CGFloat = 0.0
    
    var homingObject: EnvironmentObject?
    
    // Attached skills
    weak var attachedSkill: CharacterSkillDetails?
    
    init(attachedSkill: CharacterSkillDetails, gameScene: GameScene) {
        self.flyUpwardsFirst = true
        nextPosition = CGPoint(x: 0, y: 0)
        
        // Attach to skill
        self.attachedSkill = attachedSkill
        
        let texture = GameTextures.sharedInstance.playerArcherAtlas.textureNamed("archereagleflapping_000")
        
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.playerArcherAtlas, texturesNamed: "archereagleflapping", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false))
        
        self.run(self.walkAction)
    }
    
    override func setupTraits() {
        // Add physics
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.2, height: self.size.height * 0.2), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        
        self.setDefaultPhysicsBodyValues()
        
        // Movement speed
        self.walkSpeed = 475.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.runSpeed = 475.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.moveSpeed = self.walkSpeed
        
        // Acceleration
        self.velocityRate = 1.0 // used for movement calculation
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()

        if self.stopPositionAdjustment == false {
            // Set fly positions
            self.position = CGPoint(x: self.nextPosition.x, y: self.nextPosition.y)
            self.lastAdjustedYPosition = self.nextPosition.y
            self.physicsBody!.velocity = CGVector()
        } else {
            if self.keepTryingToHome {
                if self.homingObject != nil {
                    if self.defaultYPosition - self.homingObject!.position.y > self.maxYChangeWhenHoming {
                        self.defaultYPosition -= self.maxYChangeWhenHoming
                    } else if self.defaultYPosition - self.homingObject!.position.y < -self.maxYChangeWhenHoming {
                        self.defaultYPosition += self.maxYChangeWhenHoming
                    } else {
                        self.defaultYPosition = self.homingObject!.position.y
                    }
                } else {
                    self.defaultYPosition = self.lastAdjustedYPosition
                    self.keepTryingToHome = false
                }
            }
        }
    }
    
    override func executeDeath() {
        // Hide it
        self.isHidden = true
        
        // Set bool back to go back to where we need to be
        self.keepTryingToHome = true
        self.stopPositionAdjustment = false
        
        // Set physics colls
        self.physicsBody!.categoryBitMask = GameScene.deathCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.collisionBitMask = 0
        
        if !self.attachedSkill!.cooldownInProgress {
            self.putSkillOnCooldown()
        }
    }
    
    func resetEagle() {
        // Unhide
        self.isHidden = false
        
        // TODO consider fading in.
        
        // Bring back collision
        self.setDefaultCollisionMasks()
    }
    
    func putSkillOnCooldown() {
        // Set the skill to cooldown
        self.attachedSkill!.cooldownInProgress = true
        self.attachedSkill!.previouslyCoolingDown = true
        
        // This is how long until it can be used again
        self.attachedSkill!.activeCooldownCount = self.attachedSkill!.maxCooldownCount
        
        // Make the button go to cooldown
        self.gameScene!.getButtonWithSkill(self.attachedSkill!.upgrade)!.createCooldownButtonForCooldown()
    }
}
