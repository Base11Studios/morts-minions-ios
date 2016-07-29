//
//  Mimic.swift
//  Push
//
//  Created by Dan Bellinski on 10/15/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Mimic)
class Mimic : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "smallworm_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "smallworm", frameStart: 0, frameEnd: 15), timePerFrame: 0.075, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width/1.3, height: self.size.height/1.3), center: CGPoint(x: -(self.size.width/11.0), y: -self.size.height/14.0))
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.setFlyingObjectProperties()
        self.isFloating = true
        
        // Attributes
        self.maxHealth = 2
        self.health = self.maxHealth
        
        // Rewards
        self.experience = self.maxHealth
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // Match the player's y position
        //self.position = CGPointMake(self.position.x, player.position.y)
        self.defaultYPosition = player.position.y - ((player.size.height - self.size.height) / 2.0)
        
        super.update(timeSinceLast, withPlayer: player)
    }
}
