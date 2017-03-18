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
    
    init(gameScene: GameScene, groundCollision: Bool) {
        self.collidesWithGround = groundCollision
        let texture = GameTextures.sharedInstance.playerMageAtlas.textureNamed("meteor")
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        self.setDefaultPhysicsBodyValues()
        if self.collidesWithGround {
            self.physicsBody!.contactTestBitMask = GameScene.enemyCategory | GameScene.obstacleCategory | GameScene.groundCategory | GameScene.transparentEnemyCategory
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
        let meteor = PlayerSmallMeteor(gameScene: self.gameScene!)
        meteor.physicsBody!.velocity = CGVector()
        meteor.position = CGPoint(x: self.position.x, y: self.gameScene!.groundPositionY)
        self.gameScene!.worldView.addChild(meteor)
        self.gameScene!.worldViewPlayerProjectiles.append(meteor)
        meteor.physicsBody!.applyImpulse(velocity)
    }
}
