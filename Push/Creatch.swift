//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Creatch)
class Creatch : Enemy {
    var savedPlayer: Player?
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "creatch_000", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.walkAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.spiritAtlas, texturesNamed: "creatch", frameStart: 0, frameEnd: 15), timePerFrame: 0.04, resize: true, restore: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.7, height: self.size.height * 0.85), center: CGPoint(x: self.size.width * 0, y: self.size.height * -0.075))
        
        setDefaultPhysicsBodyValues()
        
        // Physics overrides
        self.moveSpeed = 200
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Circle of range for disable jump
        let rangeCircle = SKShapeNode(circleOfRadius: self.lineOfSight)
        rangeCircle.strokeColor = MerpColors.pauseBackgroundNoAlpha
        rangeCircle.glowWidth = 1.0
        rangeCircle.fillColor = MerpColors.pauseBackground
        rangeCircle.zPosition = self.zPosition - 1
        self.addChild(rangeCircle)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        if savedPlayer == nil {
            self.savedPlayer = player
        }
        
        // The player is in sight of the enemy
        if self.isAlive && abs(self.position.x - player.position.x) < self.lineOfSight + player.size.width * 1.5 {
            self.setPlayerJumpDisabled(disabled: true)
        } else {
            self.setPlayerJumpDisabled(disabled: false)
        }
    }
    
    override func checkHealth() {
        super.checkHealth()
        
        if !self.isAlive {
            self.setPlayerJumpDisabled(disabled: false)
        }
    }
    
    func setPlayerJumpDisabled(disabled: Bool) {
        if savedPlayer != nil {
            savedPlayer!.jumpDisabled = disabled
        }
    }
}
