//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(LightningCloud)
class LightningCloud : Obstacle {
    
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "lightningcloud_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        // Create some bubbles
        for _ in 1...6 {
            // Create projectile
            let projectile: Lightning = Lightning(scalar: 1.0, defaultYPosition: defaultYPosition, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.isHidden = true
            
            projectile.position = CGPoint(x: defaultXPosition, y: defaultYPosition - 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            self.gameScene!.addEnvironmentObject(environmentObject: projectile)
            
            projectiles.append(projectile)
        }
        
        self.walkingAnimatedFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "lightningcloud", frameStart: 0, frameEnd: 15)
        self.walkAction = SKAction.animate(with: self.walkingAnimatedFrames, timePerFrame: 0.1, resize: true, restore: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        // Determine interactions with player
        self.collidesWithPlayer = false
        self.playerCanDamage = false
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        self.setFlyingObjectProperties()
        
        self.defaultYPosition = self.defaultYPosition + 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 0
        self.damageToShields = 0
    }
    
    override func runAnimation() {
        // Don't do anything to start
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if self.attackCooldown <= 0.0 && self.projectiles.count > 0 {
            self.isFighting = true

            // Run action for fighting
            self.run(self.walkAction)
            
            self.attackCooldown = self.value1
        }
        
        if self.isFighting && self.texture!.isEqual(self.walkingAnimatedFrames[4]) {
            let lightning: Lightning = self.projectiles.popLast() as! Lightning
            
            lightning.position = CGPoint(x: self.position.x, y: self.position.y)
            lightning.defaultYPosition = self.position.y
            
            // Change the name back to default so it receives updates
            lightning.resetName()
            
            // Unhide it
            lightning.isHidden = false
            
            self.isFighting = false
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Pew)
        }
        
        super.attack(timeSinceLast, player: player)
    }
}
