//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Teleporter)
class Teleporter : Obstacle {
    
    var hasResetPlayer: Bool = false
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "teleport_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkingAnimatedFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "teleport", frameStart: 0, frameEnd: 15)
        self.walkAction = SKAction.animate(with: self.walkingAnimatedFrames, timePerFrame: 0.1, resize: true, restore: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 0.8), center: CGPoint(x: 0, y: self.size.height * 0.0))
        
        // Determine interactions with player
        self.collidesWithPlayer = false
        self.playerCanDamage = false
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 0
        self.damageToShields = 0
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        super.update(timeSinceLast, withPlayer: player)
        
        if self.playerContacted && !self.hasResetPlayer {
            player.resetYToGround = true
            self.hasResetPlayer = true
        }
    }
}
