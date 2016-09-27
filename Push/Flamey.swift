//
//  Jumper.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(Flamey)
class Flamey : Enemy {
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "flamey_floating_000", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
    
        // Setup action for floating
        self.floatAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "flamey_floating", frameStart: 0, frameEnd: 15), timePerFrame: 0.06, resize: true, restore: false) )
        
        // Start an animation - execute the jumping animation, then do block that sets isJumping to true and send an impulse and sets animation back to regular
        let actionLandJump: SKAction = SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.fireAtlas, texturesNamed: "flamey_jumping", frameStart: 0, frameEnd: 15), timePerFrame: 0.01, resize: false, restore: false)  // TODO this frame speed should be multiplied by the difference of the enemy speed or something
        
        // At the end, switch back to walking and update the animation
        let actionJump: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.isFloating = true // Start jumping again
                self?.isJumping = false
                self?.justStartedFloating = true
                
                // Apply an impulse upward on object to simulate jump
                self?.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: self!.value1))
                
                // Update the animations
                self?.updateAnimation()
            }
            })
        // Set the appropriate fight action
        self.jumpAction = SKAction.sequence([actionLandJump, actionJump])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func runAnimation() {
        self.run(self.floatAction)
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.90, height: self.size.height * 0.75), center: CGPoint(x: 0, y: self.size.height * -0.125))
        
        self.setDefaultPhysicsBodyValues()
        
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 3
        
        // ** OVERRIDE
        self.isFloating = true
        self.isJumping = true
        self.isWalking = false
        self.isContinuouslyJumping = true
        
        // This is for collision detection
        self.hasVerticalVelocity = true
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        super.attack(timeSinceLast, player: player)
        
        // This prevents collisions right when we try to leave the ground
        if self.justStartedFloating {
            self.justStartedFloating = false
        }
        
        if self.isFloating && self.isJumping { // TODO start this object out with both to true so jump starts
            // Now we stop the jump
            self.isFloating = false
            self.needToResetYPosition = true
            
            self.updateAnimation()
        }
    }
}
