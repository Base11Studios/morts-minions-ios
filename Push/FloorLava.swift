//
//  Bat.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(FloorLava)
class FloorLava : Obstacle {
    var hasHarmedPlayer: Bool = false
    var readyToAttack: Bool = false
    var state: Int = 0
    var originalGroundColor: SKColor?
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "floorlava", textureAtlas: GameTextures.sharedInstance.fireAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
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
        
        // Hide it... this is merely a spotholder
        self.physicsBody!.contactTestBitMask = GameScene.harmlessObjectCategory
        self.isHidden = true
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if !self.readyToAttack && (self.position.x - player.position.x) < self.lineOfSight {
            self.readyToAttack = true
        }
        
        if self.attackCooldown <= 0.0 && self.readyToAttack {
            switch self.state {
            case 0:
                // Turn on alert
                self.originalGroundColor = (self.scene as! GameScene).ground.color // Save prev color
                (self.scene as! GameScene).ground.color = MerpColors.fireGroundAlert
                self.state = self.state + 1
                self.attackCooldown = self.value1
            case 1:
                // Turn on warn
                (self.scene as! GameScene).ground.color = MerpColors.fireGroundWarn
                self.state = self.state + 1
                self.attackCooldown = self.value1
            case 2:
                // Turn on lava
                (self.scene as! GameScene).ground.color = MerpColors.fireGroundLava
                self.state = self.state + 1
                self.attackCooldown = self.value1
                SoundHelper.sharedInstance.playSound(self, sound: SoundType.Burn)
            case 3:
                // Turn off lava
                (self.scene as! GameScene).ground.color = self.originalGroundColor!
                self.state = self.state + 1
                self.attackCooldown = 100
                self.removeObjectFromParent()
            default:
                self.state = self.state + 1
                self.attackCooldown = 100
            }
        }
        
        if self.readyToAttack && self.state == 3 && player.isOnGround && !self.hasHarmedPlayer {
            // Take damage
            player.frontEngageWithEnvironmentObject(self)
            
            self.hasHarmedPlayer = true
        }
        
        super.attack(timeSinceLast, player: player)
    }
}
