//
//  BombBat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//



import Foundation

@objc(Firebomber)
class Firebomber : Enemy {
    
    var bomb: FallingBomb?
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "firebomber_000", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        // Create projectile
        self.bomb = FallingBomb(scalar: 1.0, defaultYPosition: self.position.y - self.size.height / 2.0, defaultXPosition: self.position.x, parent: parent, value1: 0, value2: 0, scene: scene)
        
        // We dont want this to get updated by gamescene so change the name which is the selector
        self.bomb!.name = "proj_dont_update"
        self.bomb!.isHidden = true
        
        self.bomb!.position = CGPoint(x: self.position.x - self.size.width / 2, y: self.position.y - self.size.height / 2.0)
        
        // Override
        self.bomb!.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
        
        self.gameScene!.addEnvironmentObject(environmentObject: self.bomb!)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "firebomber", frameStart: 0, frameEnd: 15), timePerFrame: 0.02, resize: true, restore: false))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 2, height: self.size.height / 4), center: CGPoint(x: -(self.size.width / 4.0), y: self.size.height / 22.0))
        
        self.setDefaultPhysicsBodyValues()
        
        // ** OVERRIDE ** - This is a flying object
        self.setFlyingObjectProperties()
        self.defaultYPosition = self.defaultYPosition + 150.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.ProjectileThrow.rawValue, waitForCompletion: false)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        super.attack(timeSinceLast, player: player)
        
        if self.attackCooldown <= 0.0 && (self.position.x - player.position.x) < self.lineOfSight {
            self.bomb!.position = CGPoint(x: self.position.x - self.size.width / 4.0, y: self.position.y - self.size.height / 4.0)
            self.bomb!.defaultYPosition = self.position.y - self.size.height / 4.0
            self.bomb!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            // Change the name back to default so it receives updates
            self.bomb!.resetName()
            
            // Unhide it
            self.bomb!.isHidden = false
            
            // Set physics body back
            self.bomb!.physicsBody!.categoryBitMask = GameScene.projectileCategory
            
            self.attackCooldown = 100.0
            
            self.playActionSound()
        }
    }
}
