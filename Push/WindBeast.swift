//
//  Sqworm.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(WindBeast)
class WindBeast : Enemy {
    
    var weaponFrames = Array<SKTexture>()
    var weapon: SKSpriteNode = SKSpriteNode()
    var weaponStartPosition: CGPoint = CGPoint()
    
    var shouldAttack: Bool = false
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        super.init(scalar: scalar, imageName: "windbeast_000", textureAtlas: GameTextures.sharedInstance.airAtlas, defaultYPosition: defaultYPosition, value1: value1, value2: value2, scene: scene)
        
        self.startWalkingAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.startWalking()
            }
        })
        self.walkingAnimatedFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "windbeast", frameStart: 0, frameEnd: 15)
        self.walkAction = SKAction.sequence([self.startWalkingAction, SKAction.repeatForever(SKAction.animate(with: self.walkingAnimatedFrames, timePerFrame: 0.06, resize: true, restore: false))])
        
        // Create the weapon and weapon animation (put it in the frames)
        self.weapon = SKSpriteNode(texture: GameTextures.sharedInstance.airAtlas.textureNamed("windbeast_attack_000"))
        
        self.weaponFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.airAtlas, texturesNamed: "windbeast_attack", frameStart: 0, frameEnd: 15)
        self.weaponAction = SKAction.sequence([SKAction.animate(with: self.weaponFrames, timePerFrame: 0.08, resize: true, restore: false), SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.weapon.removeAction(forKey: "weapon_fighting")
            }
        })])
        self.addChild(self.weapon)
        
        // Update the weapon position
        self.weaponStartPosition = CGPoint(x: self.weaponStartPosition.x - 35, y: self.weaponStartPosition.y - 8)
        self.weapon.position = self.weaponStartPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startWalking() {
        self.moveSpeed = 100
        self.isFighting = false
        self.isWalking = true
    }
    
    func stopWalking() {
        self.removeAction(forKey: "enemyWalking")
        self.texture = self.walkingAnimatedFrames[0]
        self.moveSpeed = 0
        self.isWalking = false
    }
    
    override func setupTraitsWithScalar(_ scalar: Double) {
        // Add physics to the enemy
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 1.0), center: CGPoint(x: self.size.width * -0.05, y: self.size.height * 0.0))
        
        setDefaultPhysicsBodyValues()
      
        // Attributes
        self.maxHealth = 1
        self.health = self.maxHealth
        self.lineOfSight = 300 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Damage
        self.damage = 1
        self.damageToShields = 1
        
        // Rewards
        self.experience = 1
        
        // Sound
        self.actionSound = SKAction.playSoundFileNamed(SoundType.Wind.rawValue, waitForCompletion: true)
    }
    
    override func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        super.update(timeSinceLast, withPlayer: player)
        
        // Update weapon positioning
        self.updateWeapon()
    }
    
    func updateWeapon() { // TODO match these up with beast animation frame numbers
        let scalar: CGFloat = 1.0  * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        for i in 0 ..< self.walkingAnimatedFrames.count {
            if self.texture!.isEqual(self.walkingAnimatedFrames[i]) {
                switch i {
                case 0, 8: // First Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y)
                case 1, 7, 9, 15: // Second Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 1 * scalar)
                case 2, 6, 10, 14: // Third Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 2 * scalar)
                case 3, 5, 11, 13: // Fourth Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 3 * scalar)
                case 4, 12: // Lowest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 4 * scalar)
                default:
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y)
                }
            }
        }
    }
    
    override func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        // Call the super attack (reduces attack cooldown)
        super.attack(timeSinceLast, player: player)
        
        // The player is in sight of the enemy
        if self.attackCooldown <= 0 && (self.position.x - player.position.x) < self.lineOfSight {
            // Stop walking
            self.stopWalking()
            
            // Set the cooldown
            self.attackCooldown = 1
            
            // Set to fighting
            self.isFighting = true
            
            // Start the weapon animation
            self.weapon.run(self.weaponAction, withKey: "weapon_fighting")
            
            self.playActionSound()
        }
        
        if self.isFighting && self.weapon.texture!.isEqual(self.weaponFrames[9]) {
            // Check for player colls
            if player.position.y - player.size.height / 2 < self.position.y + self.size.height / 2 && self.position.x - player.position.x < self.lineOfSight && self.position.x - player.position.x > 0 {
                player.knockBackwards(self, modifier: nil)
                player.frontEngageWithEnvironmentObject(self)
            }
            
            self.isFighting = false
        }
    }
    
    override func clearOutActions() {
        super.clearOutActions()
        self.weapon.removeAction(forKey: "weapon_fighting")
        self.weapon.removeAllActions()
    }
}
