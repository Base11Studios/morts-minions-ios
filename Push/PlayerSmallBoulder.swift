//
//  PlayerArrow.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class PlayerSmallBoulder: PlayerProjectile {
    init(gameScene: GameScene) {
        let texture = GameTextures.sharedInstance.playerWarriorAtlas.textureNamed("smallboulder")
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        self.setDefaultPhysicsBodyValues()
        
        self.isFlying = false
        self.physicsBody!.affectedByGravity = true
    }
}
