//
//  Goblin.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Slanky)
class Slanky : Enemy {
    var applyImpulseToPlayer: Bool = false
    var animationAdjuster: CGFloat = 5.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var rangeIndicator: SKSpriteNode = SKSpriteNode()
    var attackAction: SKAction = SKAction()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        // Initialize the attributes
        super.init(scalar: scalar, imageName: "slanky_standing_000", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        // Setup animations for walking only
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "slanky_standing", frameStart: 0, frameEnd: 15), timePerFrame: 0.10, resize: true, restore: false))
        
        // Set the fighting frames for animation
        self.fightingAnimatedFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "slanky_pounding", frameStart: 0, frameEnd: 15)
        
        // ** Create an action to attack **
        
        // At the end, switch back to walking and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            self.isFighting = false
            self.isWalking = true
            self.position = CGPoint(x: self.position.x - self.animationAdjuster, y: self.position.y)
            
            // Start cooldown back over
            self.attackCooldown = self.maxAttackCooldown
            
            // Update the animations
            self.updateAnimation()
            
        })
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "slanky_pounding", frameStart: 0, frameEnd: 15), timePerFrame: 0.04, resize: true, restore: false), actionEndAttack]) // TODO this frame speed should be multiplied by the difference of the enemy speed or something
        
        // Animate ground pounding
        self.rangeIndicator = SKSpriteNode(texture: nil, color: MerpColors.fireGroundWarn, size: CGSize(width: self.lineOfSight*2, height: 2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.rangeIndicator.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height / 2)
        self.rangeIndicator.zPosition = 3
        parent.addChild(self.rangeIndicator)
        
        // Group actions to do in parallel
        self.attackAction = SKAction.sequence([
            SKAction.run({
                self.rangeIndicator.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height / 2)
                self.rangeIndicator.alpha = 1.0
            }),
            SKAction.move(by: CGVector(dx: 0, dy: 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)), duration: 0.05),
            SKAction.group([SKAction.move(by: CGVector(dx: 0, dy: -15 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)), duration: 0.25),
                SKAction.fadeOut(withDuration: 0.25)]),
            SKAction.run({
                //self.rangeIndicator.alpha = 0
            })])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.45, height: self.size.height * 0.95), center: CGPoint(x: self.size.width * 0.15, y: self.size.height * -0.05))
        
        setDefaultPhysicsBodyValues()
        
        //Physics overrides
        self.physicsBody!.mass = self.defaultMass * 10
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 410 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Attacking
        self.maxAttackCooldown = self.value1
        self.attackCooldown = 0.0
        
        // Don't move
        self.moveSpeed = 0
        self.velocityRate = 0
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && (self.position.x - player.position.x) < self.lineOfSight {
            // Set move speed to 0 to stop movement
            self.moveSpeed = 0
            
            // Set the cooldown really high, this will be reset when the attack finishes
            self.attackCooldown = 100.0
            
            // Set to fighting
            self.isFighting = true
            self.isWalking = false
            self.position = CGPoint(x: self.position.x + self.animationAdjuster, y: self.position.y)
            
            // Update the animations
            self.updateAnimation()
        }
        
        if self.isFighting && self.texture!.isEqual(self.fightingAnimatedFrames[11]) {
            self.rangeIndicator.run(self.attackAction)
            
            // Check for player colls
            if player.isOnGround && abs(self.position.x - player.position.x) < self.lineOfSight {
                player.applyUpwardImpulseFromObject(5000)
                player.frontEngageWithEnvironmentObject(self)
            }
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Crash)
        }
    }
}
