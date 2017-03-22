//
//  Ghost.swift
//  Push
//
//  Created by Dan Bellinski on 10/15/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Ghost)
class Ghost : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "ghost_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "ghost", frameStart: 0, frameEnd: 1), timePerFrame: 0.02, resize: true, restore: false) )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size) // TODO modify for hat
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.85, height: self.size.height * 0.85), center: CGPoint(x: self.size.width * -0.075, y: self.size.height * 0))
        
        self.setDefaultPhysicsBodyValues()
        
        // Physics overrides to miss contact
        self.physicsBody!.categoryBitMask = GameScene.transparentEnemyCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.collisionBitMask = 0
        
        // Flying attrs
        self.setFlyingObjectProperties()
        
        // Other overrides
        self.playerCanBlock = false
        self.playerCanDamage = false
        
        // Physics overrides
        self.moveSpeed = 60
        
        // Position overrides
        self.defaultYPosition = self.defaultYPosition + 60.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Sine wave
        self.startingYPosition = self.defaultYPosition
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // Match the player's y position
        //self.position = CGPointMake(self.position.x, player.position.y)
        
        // TODO defaultYPosition needs to be static.. ehy is it being used in ongoing height calculation?
        self.defaultYPosition = self.startingYPosition + (50 * sin(CGFloat(self.timeAlive)*5)) // TODOSCALE
        
        super.update(timeSinceLast, withPlayer: player)
    }
}
