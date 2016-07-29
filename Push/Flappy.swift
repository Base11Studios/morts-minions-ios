//
//  Seahorse.swift
//  Push
//
//  Created by Dan Bellinski on 10/18/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Flappy)
class Flappy : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "flappy_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "flappy", frameStart: 0, frameEnd: 15), timePerFrame: 0.015, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.35, height: self.size.height * 0.3), center: CGPoint(x: -self.size.width * 0.3, y: self.size.height * 0.025))
        self.setDefaultPhysicsBodyValues()
        
        // Flying attrs
        self.setFlyingObjectProperties()
        
        // Position overrides
        self.defaultYPosition = self.defaultYPosition + 120.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Sine wave
        self.startingYPosition = self.defaultYPosition
        
        self.maxHealth = 1
        self.health = self.maxHealth
        
        //self.physicsBody!.mass = 100
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // Match the player's y position
        self.defaultYPosition = player.position.y + (self.defaultYPosition - player.position.y) * CGFloat(self.value1)
        
        super.update(timeSinceLast, withPlayer: player)
    }
}
