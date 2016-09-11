//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Sqworm)
class Sqworm : Enemy {
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "smallworm_000", textureAtlas: GameTextures.sharedInstance.earthAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        // Setup animations/actions
        // TODO make this into shared function
        let animateWalk: SKAction = SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "smallworm", frameStart: 9, frameEnd: 15), timePerFrame: 0.025, resize: true, restore: false)
        let endWalkAction: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.isWalking = false
                self?.isCoiling = true
                self?.updateAnimation()
            }
            })
        let animateCoil: SKAction = SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.earthAtlas, texturesNamed: "smallworm", frameStart: 0, frameEnd: 8), timePerFrame: 0.05, resize: true, restore: false)
        let endCoilAction: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.isWalking = true
                self?.isCoiling = false
                self?.updateAnimation()
            }
            })
        self.walkAction = SKAction.sequence([animateWalk, endWalkAction])
        self.coilAction = SKAction.sequence([animateCoil, endCoilAction])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.80, height: self.size.height * 0.6), center: CGPoint(x: self.size.width * -0.1, y: self.size.height * -0.2))
        /*
         let offsetX: CGFloat = self.frame.size.width * self.anchorPoint.x
         let offsetY: CGFloat = self.frame.size.height * self.anchorPoint.y
         
         let path: CGMutablePathRef = CGPathCreateMutable()
         
         CGPathMoveToPoint(path, nil, 58 - offsetX, 0 - offsetY)
         CGPathAddLineToPoint(path, nil, 58 - offsetX, 11 - offsetY)
         CGPathAddLineToPoint(path, nil, 23 - offsetX, 24 - offsetY)
         CGPathAddLineToPoint(path, nil, 0 - offsetX, 24 - offsetY)
         CGPathAddLineToPoint(path, nil, -1 - offsetX, 0 - offsetY)
         CGPathAddLineToPoint(path, nil, 58 - offsetX, 0 - offsetY)
         
         CGPathCloseSubpath(path);
         
         self.physicsBody = SKPhysicsBody(polygonFromPath: path)
         */
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 300
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
    }
}
