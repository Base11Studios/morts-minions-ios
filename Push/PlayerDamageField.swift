//
//  PlayerArrow.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class PlayerDamageField: PlayerProjectile {
    init(size: Int, gameScene: GameScene) {
        var texture: SKTexture
        
        if size == 1 {
            texture = GameTextures.sharedInstance.playerMonkAtlas.textureNamed("damagefield")
        } else if size == 2 {
            texture = GameTextures.sharedInstance.playerMonkAtlas.textureNamed("damagefielddouble")
        } else {
            texture = GameTextures.sharedInstance.playerMonkAtlas.textureNamed("damagefieldtriple")
        }
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        self.setDefaultPhysicsBodyValues()
        
        self.isFlying = false
        
        self.numberOfContacts = 1000
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // For now we don't do anything, just don't want to have parent update called
    }
    
    func setToHarmless(_ removingActive: Bool) {
        self.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
        
        if removingActive {
            self.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.hide()]))
        } else {
            self.isHidden = true
        }
    }
    
    func resetToHarmful() {
        self.alpha = 1.0
        self.setDefaultCollisionMasks()
        self.isHidden = false
    }
    
    override func setDefaultCollisionMasks() {
        // Collisions
        self.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
        self.physicsBody!.contactTestBitMask = GameScene.enemyCategory | GameScene.obstacleCategory | GameScene.projectileCategory
        self.physicsBody!.collisionBitMask = GameScene.enemyCategory | GameScene.obstacleCategory | GameScene.projectileCategory
    }
}
