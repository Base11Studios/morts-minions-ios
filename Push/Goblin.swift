//
//  Goblin.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Goblin)
class Goblin : Enemy {
    
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        // Initialize the attributes
        super.init(scalar: scalar, imageName: "goblinstanding_000", textureAtlas: GameTextures.sharedInstance.earthAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.setScale(self.xScale * 0.925)
        
        // Setup animations for walking only
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "goblinstanding", frameStart: 0, frameEnd: 15), timePerFrame: 0.06, resize: true, restore: false))
        
        for _ in 1...2 {
            // Create projectile
            let projectile: Arrow = Arrow(scalar: 1.0, defaultYPosition: defaultYPosition + self.size.height/2 - 9.0, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.type = EnvironmentObjectType.Ignored
            projectile.isHidden = true
            
            projectile.position = CGPoint(x: defaultXPosition, y: defaultYPosition)
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.gameScene!.addEnvironmentObject(environmentObject: projectile)
            
            projectiles.append(projectile)
        }
        
        // ** Create an action to attack **
        // At the end, create the projectile
        let actionOpenProjectile: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                let arrow: Arrow = self?.projectiles.popLast() as! Arrow
        
                arrow.position = CGPoint(x: self!.position.x - 15.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), y: self!.position.y - 3.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                arrow.defaultYPosition = self!.position.y - 3.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
                
                // Change the name back to default so it receives updates
                arrow.resetName()
                
                // Unhide it
                arrow.isHidden = false
                
                // Set physics body back
                arrow.physicsBody!.categoryBitMask = GameScene.projectileCategory
                
                self?.playActionSound()
            }
        })
        
        // At the end, switch back to walking and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.isFighting = false
                self?.isWalking = true
                
                // Start cooldown back over
                self?.attackCooldown = (self?.maxAttackCooldown)!
                
                // Update the animations
                self?.updateAnimation()
            }
        })
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "goblinshooting", frameStart: 0, frameEnd: 15), timePerFrame: 0.025, resize: true, restore: false), actionOpenProjectile, actionEndAttack]) // TODO this frame speed should be multiplied by the difference of the enemy speed or something
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.50, height: self.size.height), center: CGPoint(x: self.size.width * 0.15, y: 0))
        
        setDefaultPhysicsBodyValues()
        
        //Physics overrides
        self.physicsBody!.mass = self.defaultMass * 10
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 630 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Attacking
        self.maxAttackCooldown = 1.2
        self.attackCooldown = 0.0
        
        // Don't move
        self.moveSpeed = 0
        self.velocityRate = 0
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.ProjectileThrow.rawValue, waitForCompletion: false)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && (self.position.x - player.position.x) < self.lineOfSight && self.projectiles.count > 0 {
            // Set move speed to 0 to stop movement
            self.moveSpeed = 0
            
            // Set the cooldown really high, this will be reset when the attack finishes
            self.attackCooldown = 100.0
            
            // Set to fighting
            self.isFighting = true
            self.isWalking = false
            
            // Update the animations
            self.updateAnimation()
        }
    }
}
