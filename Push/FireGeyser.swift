//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(FireGeyser)
class FireGeyser : Obstacle {
    var flame: Flame?
    var flameCooldown: Double = 100
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "firegeyser_base", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        // Create the flame
        self.flame = Flame(scalar: 1.0, defaultYPosition: defaultYPosition, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
        // We dont want this to get updated by gamescene so change the name which is the selector
        flame!.name = "proj_dont_update"
        flame!.type = EnvironmentObjectType.Ignored
        flame!.isHidden = true
            
        flame!.position = CGPoint(x: defaultXPosition, y: defaultYPosition - 300)
        
        flame!.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
        self.gameScene!.addEnvironmentObject(environmentObject: self.flame!)
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
        
        self.lineOfSight = 200 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Set physics
        self.setDefaultPhysicsBodyValues()
        
        // Damage
        self.damage = 0
        self.damageToShields = 0
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        self.flameCooldown -= timeSinceLast
        
        if self.attackCooldown <= 0.0 && (self.position.x - player.position.x) < self.lineOfSight && (self.position.x - player.position.x) > -self.size.width {
            flame!.position = CGPoint(x: self.position.x, y: self.position.y + self.flame!.size.height * 0.4)
            flame!.defaultYPosition = self.position.y + self.flame!.size.height * 0.4
            
            // Change the name back to default so it receives updates
            flame!.resetName()
            
            // Unhide it
            flame!.isHidden = false
            
            flame!.physicsBody!.categoryBitMask = GameScene.projectileCategory
            
            self.flameCooldown = self.value2
            
            self.attackCooldown = self.value1
            
            self.playActionSound(action: SoundHelper.sharedInstance.flame)
        }
        
        if self.flameCooldown <= 0.0 {
            flame!.name = "proj_dont_update"
            flame!.type = EnvironmentObjectType.Ignored
            flame!.isHidden = true
            flame!.position = CGPoint(x: self.position.x, y: self.position.y - 300)
            self.flameCooldown = 100.0
            flame!.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
        }
        
        super.attack(timeSinceLast, player: player)
    }
}
