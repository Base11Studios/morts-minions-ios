//
//  BombBat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//



import Foundation

@objc(Motherhen)
class Motherhen : Enemy {
    
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "motherhen_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        for _ in 1...Int(self.value1) {
            // Create projectile
            let projectile: Egg = Egg(scalar: 1.0, defaultYPosition: defaultYPosition + self.size.height/2 - 9.0, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.isHidden = true
            
            projectile.position = CGPoint(x: defaultXPosition, y: defaultYPosition)
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.gameScene!.addEnvironmentObject(environmentObject: projectile)
            
            projectiles.append(projectile)
        }
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "motherhen", frameStart: 0, frameEnd: 15), timePerFrame: 0.035, resize: true, restore: false))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        //self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width / 2, self.size.height / 4), center: CGPointMake(-(self.size.width / 4.0), self.size.height / 22.0))
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.3, height: self.size.height * 0.2), center: CGPoint(x: -self.size.width * 0.35, y: self.size.height * 0.015))
        
        self.setDefaultPhysicsBodyValues()
        
        // ** OVERRIDE ** - This is a flying object
        self.setFlyingObjectProperties()
        self.defaultYPosition = self.defaultYPosition + 150.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 380 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        super.attack(timeSinceLast, player: player)
            
        if self.attackCooldown <= 0.0 && (self.position.x - player.position.x) < self.lineOfSight && self.projectiles.count > 0 {
            let projectile: Egg = self.projectiles.popLast() as! Egg
            projectile.position = CGPoint(x: self.position.x - self.size.width / 4.0, y: self.position.y - self.size.height / 4.0)
            projectile.defaultYPosition = self.position.y - self.size.height / 4.0
            projectile.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            // Change the name back to default so it receives updates
            projectile.resetName()
            
            // Unhide it
            projectile.isHidden = false
            
            // Set physics body back
            projectile.physicsBody!.categoryBitMask = GameScene.projectileCategory
            
            self.attackCooldown = self.value2
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.ProjectileThrow)
        }
    }
}
