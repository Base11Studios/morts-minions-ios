//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(ExpandyCloud)
class ExpandyCloud : Obstacle {
    var originalScale: CGFloat = 0.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var currentScale: CGFloat = 0.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var maxScale: CGFloat = 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "expandycloud_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
            
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "expandycloud", frameStart: 0, frameEnd: 15), timePerFrame: 0.125, resize: true, restore: false) )
        
        self.setScale(self.originalScale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.7, height: self.size.height * 0.875), center: CGPoint(x: 0, y: self.size.height * -0.0))
        
        // Determine interactions with player
        self.collidesWithPlayer = false
        self.playerCanDamage = false
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        // LOS
        self.lineOfSight = 100 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        self.defaultYPosition = self.defaultYPosition + CGFloat(self.value1) * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        self.setScale(self.currentScale * self.maxScale)
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        if abs(self.position.x - player.position.x) < self.lineOfSight {
            let distance = self.lineOfSight - (abs(self.position.x - player.position.x))
            self.currentScale = (((distance / self.lineOfSight) * (1 - self.originalScale)) + self.originalScale) * self.maxScale
            
            if self.currentScale > ScaleBuddy.sharedInstance.getGameScaleAmount(false) {
                self.setScale(ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            }
            
            self.setScale(self.currentScale)
        }
        
        super.update(timeSinceLast, withPlayer: player)
    }
}
