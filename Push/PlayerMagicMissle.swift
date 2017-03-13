//
//  PlayerArrow.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class PlayerMagicMissle: PlayerProjectile {
    var maxYChangeWhenHoming: CGFloat = 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var range: CGFloat = 0
    var homingObject: EnvironmentObject?
    
    init(gameScene: GameScene, range: CGFloat) {
        self.range = range
        let texture = GameTextures.sharedInstance.playerMageAtlas.textureNamed("magicmissle")
        super.init(texture: texture, color: SKColor(), size: texture.size(), scene: gameScene)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        self.setDefaultPhysicsBodyValues()
        
        self.isFlying = false
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
        
        if self.range > 0 {
            // There is something to home and it is still alive
            if self.homingObject != nil && self.homingObject!.isAlive {
                if !self.isFlying {
                    self.isFlying = true
                    self.defaultYPosition = self.position.y
                }
                
                if self.defaultYPosition - self.homingObject!.position.y > self.maxYChangeWhenHoming {
                    self.defaultYPosition -= self.maxYChangeWhenHoming
                } else if self.defaultYPosition - self.homingObject!.position.y < -self.maxYChangeWhenHoming {
                    self.defaultYPosition += self.maxYChangeWhenHoming
                } else {
                    self.defaultYPosition = self.homingObject!.position.y
                }
            } else {
                // Try to find a new guy to home
                self.findATarget()
            }
        }
    }
    
    func findATarget() {
        var closestObject: EnvironmentObject?
        
        // Iterate through all enemies to find someone close
        for object in self.gameScene!.worldViewEnvironmentObjects {
            if (object.type == EnvironmentObjectType.Enemy ||
                object.type == EnvironmentObjectType.Obstacle) && object.isAlive && !object.isBeingTargeted && object.playerCanDamage {
                if closestObject == nil {
                    if object.position.x - 20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) > self.position.x && abs(self.position.y - object.position.y) <= self.range && abs(self.position.x - object.position.x) < (400 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)) {
                        closestObject = object
                    }
                } else {
                    if object.position.x - 20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) > self.position.x && object.position.x < closestObject!.position.x && abs(self.position.y - object.position.y) <= self.range {
                        closestObject = object
                    }
                }
            }
        }
        
        // If we found something to attack, let's do it
        if closestObject != nil {
            self.homingObject = closestObject
            self.homingObject!.isBeingTargeted = true
        }
    }
}
