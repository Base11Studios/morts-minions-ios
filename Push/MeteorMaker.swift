//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MeteorMaker)
class MeteorMaker : Obstacle {
    
    var projectiles = Array<Projectile>()
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "1x1trans", textureAtlas: GameTextures.sharedInstance.spiritAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        let numProjectiles = 1
        
        for _ in 1...numProjectiles {
            // Create projectile
            let projectile: Meteor = Meteor(scalar: 1.0, defaultYPosition: defaultYPosition, defaultXPosition: defaultXPosition, parent: parent, value1: 0, value2: 0, scene: scene)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.type = EnvironmentObjectType.Ignored
            projectile.isHidden = true
            
            projectile.position = CGPoint(x: defaultXPosition, y: defaultYPosition + 300)
            
            self.gameScene!.addEnvironmentObject(environmentObject: projectile)
            
            projectiles.append(projectile)
        }
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
        
        // Damage
        self.damage = 0
        self.damageToShields = 0
        
        self.lineOfSight = 225//CGFloat(self.value1)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if self.attackCooldown <= 0.0 && self.projectiles.count > 0 && (self.position.x - player.position.x) < self.lineOfSight {
            let meteor: Meteor = self.projectiles.popLast() as! Meteor
            
            meteor.position = CGPoint(x: self.position.x, y: self.position.y + 350 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            meteor.defaultYPosition = self.position.y
            
            // Change the name back to default so it receives updates
            meteor.resetName()
            
            // Unhide it
            meteor.isHidden = false
            
            self.attackCooldown = 1000
            
            self.playActionSound(action: SoundHelper.sharedInstance.projectileThrow)
        }
        
        super.attack(timeSinceLast, player: player)
    }
}
