//
//  Goblin.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(PrinceTempus)
class PrinceTempus : Enemy {
    
    var followPlayer: Bool = false
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        // Initialize the attributes
        super.init(scalar: scalar, imageName: "kingtempus_floating_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.setScale(self.xScale * 0.625)
        
        // Setup animations for walking only
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "kingtempus_floating", frameStart: 0, frameEnd: 15), timePerFrame: 0.06, resize: true, restore: false))
        
        var numProjectiles: Int = 30/* Int(self.value1)
        if numProjectiles == 0 {
            numProjectiles = 30
        }*/
        
        for _ in 1...numProjectiles {
            // Create projectile
            let projectile: PrinceBolt = PrinceBolt(scalar: 1.0, defaultYPosition: defaultYPosition + self.size.height/2 - 9.0, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
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
                let bolt: PrinceBolt = self?.projectiles.popLast() as! PrinceBolt
                
                bolt.position = CGPoint(x: self!.position.x - 15.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), y: self!.position.y - 3.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                bolt.defaultYPosition = self!.position.y - 3.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
                
                // Bolt direction
                bolt.yGrowth = CGFloat((Double(arc4random_uniform(201) + 1) / 100.0) - 1.0)
                
                // Change the name back to default so it receives updates
                bolt.resetName()
                
                // Unhide it
                bolt.isHidden = false
                
                // Set physics body back
                bolt.physicsBody!.categoryBitMask = GameScene.projectileCategory
                
                self?.playActionSound(action: SoundHelper.sharedInstance.projectileThrow)
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
        self.fightAction = SKAction.sequence([SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "kingtempus_attacking", frameStart: 0, frameEnd: 15), timePerFrame: 0.025, resize: true, restore: false), actionOpenProjectile, actionEndAttack]) // TODO this frame speed should be multiplied by the difference of the enemy speed or something
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
        self.lineOfSight = 350 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Attacking
        self.maxAttackCooldown = 1.2
        self.attackCooldown = 0.0
        
        // Don't move
        self.moveSpeed = -40
        self.velocityRate = 0.2
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        if (self.position.x - player.position.x) < self.lineOfSight {
            self.followPlayer = true
            //self.moveSpeed = 0
        }
        
        if self.followPlayer && (self.position.x - player.position.x) < self.lineOfSight {
            self.position.x = player.position.x + self.lineOfSight
        }
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && self.followPlayer && self.projectiles.count > 0 {
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
