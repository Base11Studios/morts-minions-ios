//
//  PlayerArrow.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class PlayerMeteor: PlayerProjectile {
    var collidesWithGround: Bool = false
    
    var meteors = Array<PlayerProjectile>()
    
    init(gameScene: GameScene, groundCollision: Bool) {
        self.collidesWithGround = groundCollision
        let texture = GameTextures.sharedInstance.playerMageAtlas.textureNamed("meteor")
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
        
        // Create the small meteors
        for i in 0 ..< 3 {
            // Create projectile
            let projectile: PlayerSmallMeteor = PlayerSmallMeteor(gameScene: self.gameScene!)
            projectile.physicsBody!.velocity = CGVector()
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.isHidden = true
            
            // Set up initial location of projectile
            projectile.position = CGPoint(x: self.position.x, y: self.gameScene!.groundPositionY)
            
            projectile.zPosition = 9
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.gameScene!.worldView.addChild(projectile)
            self.meteors.append(projectile)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        self.setDefaultPhysicsBodyValues()
        if self.collidesWithGround {
            self.physicsBody!.contactTestBitMask = GameScene.enemyCategory | GameScene.obstacleCategory | GameScene.groundCategory
        }
        
        self.isFlying = false
        self.physicsBody!.affectedByGravity = true
    }
    
    override func contactWithGround() {
        // create 3 small projectiles, add to scene, go off in different directions
        self.createSmallMeteor(velocity: CGVector(dx: -750, dy: 7300))
        self.createSmallMeteor(velocity: CGVector(dx: 0, dy: 8500))
        self.createSmallMeteor(velocity: CGVector(dx: 750, dy: 7300))
    }
    
    func createSmallMeteor(velocity: CGVector) {
        let meteor: PlayerSmallMeteor = self.meteors.popLast() as! PlayerSmallMeteor
        
        meteor.position = CGPoint(x: self.position.x, y: self.gameScene!.groundPositionY)
        
        // Change the name back to default so it receives updates
        meteor.resetName()
        
        // Unhide it
        meteor.isHidden = false
        
        // Set physics body back
        meteor.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
        
        self.gameScene!.worldViewPlayerProjectiles.append(meteor)
        
        meteor.physicsBody!.applyImpulse(velocity)
    }
}
