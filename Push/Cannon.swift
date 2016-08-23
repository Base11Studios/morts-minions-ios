//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Cannon)
class Cannon : Obstacle {
    
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "cannon_000", textureAtlas: GameTextures.sharedInstance.waterAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        // Create some bubbles
        for _ in 1...6 {
            // Create projectile
            let projectile: CannonBall = CannonBall(scalar: 1.0, defaultYPosition: defaultYPosition, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
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
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.waterAtlas, texturesNamed: "cannon_idle", frameStart: 0, frameEnd: 1), timePerFrame: 1.0, resize: true, restore: false) )
        
        // ** Create an action to attack **
        // At the beginning, create the projectile
        let actionOpenProjectile: SKAction = SKAction.run({
            let ball: CannonBall = self.projectiles.popLast() as! CannonBall
            
            ball.position = CGPoint(x: self.position.x, y: self.position.y + self.size.height * 2/3)
            ball.defaultYPosition = self.position.y
            ball.physicsBody!.velocity = CGVector(dx: 0,dy: 0)
            
            // Change the name back to default so it receives updates
            ball.resetName()
            
            // Unhide it
            ball.isHidden = false
            
            self.attackCooldown = self.value1
            
            ball.physicsBody!.applyImpulse(CGVector(dx: 0, dy: CGFloat(self.value2)))
            
            // Set physics body back
            ball.physicsBody!.categoryBitMask = GameScene.projectileCategory
            
            self.playActionSound()
        })
        
        // At the end, switch back to nothing and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            self.isFighting = false
            self.isWalking = true
            
            // Start cooldown back over
            self.attackCooldown = self.maxAttackCooldown
            
            // Update the animations
            self.updateAnimation()
            
        })
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([actionOpenProjectile, SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.waterAtlas, texturesNamed: "cannon", frameStart: 0, frameEnd: 15), timePerFrame: 0.025, resize: false, restore: false), actionEndAttack]) // TODO this frame speed should be multiplied by the difference of the enemy speed or something
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.45, height: self.size.height * 0.65), center: CGPoint(x: self.size.width * 0.2, y: self.size.height * -0.175))
        
        // Determine interactions with player
        self.collidesWithPlayer = true
        self.playerCanDamage = true
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        
        // Damage
        self.damage = 0
        self.damageToShields = 0
        
        self.maxAttackCooldown = self.value1
        self.lineOfSight = 450 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        //self.physicsBody!.restitution = 0.15
        
        // Don't move
        self.moveSpeed = 0
        
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.Action.rawValue, waitForCompletion: false)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if self.attackCooldown <= 0.0 && self.projectiles.count > 0 && (self.position.x - player.position.x) < self.lineOfSight  {
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
        
        super.attack(timeSinceLast, player: player)
    }
}
