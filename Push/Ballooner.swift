//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Ballooner)
class Ballooner : Enemy {
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "ballooner_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
 
        self.walkingAnimatedFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "ballooner", frameStart: 0, frameEnd: 15)
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: self.walkingAnimatedFrames, timePerFrame: 0.03, resize: true, restore: false))
        
        // Create all the balloons
        for _ in 1...Int(self.value2) {
            // Create projectile
            let projectile: Balloon = Balloon(scalar: 1.0, defaultYPosition: defaultYPosition + self.size.height/2 - 9.0, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.isHidden = true
            
            projectile.position = CGPoint(x: defaultXPosition, y: defaultYPosition)
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.gameScene!.addEnvironmentObject(environmentObject: projectile)
            
            projectiles.append(projectile)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.55, height: self.size.height * 0.6), center: CGPoint(x: self.size.width * -0.05, y: self.size.height * -0.2))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 200
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && (self.position.x - player.position.x) < self.lineOfSight && projectiles.count > 0 {
            // Get a balloon and release it
            let projectile: Balloon = self.projectiles.popLast() as! Balloon
            projectile.position = CGPoint(x: self.position.x + self.size.width / 4.0, y: self.position.y + self.size.height / 4.0)
            projectile.defaultYPosition = self.position.y + self.size.height / 4.0
            projectile.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            // Change the name back to default so it receives updates
            projectile.resetName()
            
            // Unhide it
            projectile.isHidden = false
            
            // Set physics body back
            projectile.physicsBody!.categoryBitMask = GameScene.projectileCategory
            
            // Set the cooldown
            self.attackCooldown = self.value1

            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Action)
        }
    }
}
