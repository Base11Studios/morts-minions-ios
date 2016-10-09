//
//  Seahorse.swift
//  Push
//
//  Created by Dan Bellinski on 10/18/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Starfish)
class Starfish : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "starfish_000", textureAtlas: GameTextures.sharedInstance.waterAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.waterAtlas, texturesNamed: "starfish", frameStart: 0, frameEnd: 31), timePerFrame: 0.025, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.6, height: self.size.height * 0.6), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * 0.0))
        self.setDefaultPhysicsBodyValues()
        
        // Flying attrs
        self.setFlyingObjectProperties()
        
        // Physics overrides
        self.moveSpeed = 300// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Position overrides
        self.defaultYPosition = self.defaultYPosition + 60.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Sine wave
        self.startingYPosition = self.defaultYPosition
        
        self.maxHealth = 1
        self.health = self.maxHealth
        
        self.physicsBody!.mass = 100// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // Match the player's y position
        //self.position = CGPointMake(self.position.x, player.position.y)
        
        // TODO defaultYPosition needs to be static.. ehy is it being used in ongoing height calculation?
        self.defaultYPosition = self.startingYPosition + (20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * sin(CGFloat(self.timeAlive)*4))
        
        super.update(timeSinceLast, withPlayer: player)
    }
}