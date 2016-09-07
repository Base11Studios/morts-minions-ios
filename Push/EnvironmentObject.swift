//
//  EnvironmentObject.swift
//  Push
//
//  Created by Dan Bellinski on 10/4/15.
//  Copyright (c) 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(EnvironmentObject)
class EnvironmentObject : SKSpriteNode {
    // Type
    var type: EnvironmentObjectType = EnvironmentObjectType.Ignored
    
    // Physics
    var collisionRebound: CGFloat = 1600.0 / ScaleBuddy.sharedInstance.getGameScaleAmount(false) // The amount this object should get knocked back on collision
    var playerCollisionRebound: CGFloat = -1600.0 / ScaleBuddy.sharedInstance.getGameScaleAmount(false) // The amount the player should get knocked back on collision
    
    // Physics Defaults
    var defaultRestitution: CGFloat = 1.0
    var defaultMass: CGFloat = 11.0
    var defaultFriction: CGFloat = 0.0
    var defaultLinearDamping: CGFloat = 0.0
    
    // Freeze
    var isFrozen: Bool = false
    var justFrozen: Bool = false
    
    // Actions
    var deathAction = SKAction()
    var walkAction = SKAction()
    var fightAction = SKAction()
    var floatAction = SKAction()
    var jumpAction = SKAction()
    var coilAction = SKAction()
    var extraAction: SKAction = SKAction()
    var weaponAction: SKAction = SKAction()
    var startWalkingAction: SKAction = SKAction()
    
    // Texture arrays
    var walkingAnimatedFrames = Array<SKTexture>()
    var fightingAnimatedFrames = Array<SKTexture>()
    var jumpingAnimatedFrames = Array<SKTexture>()
    var floatingAnimatedFrames = Array<SKTexture>()
    
    // Position
    var defaultYPosition: CGFloat = CGFloat()
    var groundYPosition: CGFloat = CGFloat()
    var startingYPosition: CGFloat = 0.0
    
    // Jumping
    var isActiveJumping: Bool = false
    var isFloating: Bool = false
    var isJumping: Bool = false
    var isFighting: Bool = false
    var justStartedFloating: Bool = false
    var needToResetYPosition: Bool = false
    var isContinuouslyJumping: Bool = false
    var justCollidedWithGround: Bool = false
    
    // Previous
    var previousPosition: CGPoint = CGPoint()
    var previousPreviousPosition: CGPoint = CGPoint()
    var previousVelocity: CGVector = CGVector()
    var previousSpeed: CGFloat = CGFloat()
    
    // Interaction
    var collidesWithPlayer: Bool = true
    
    // Collisions
    var justCollidedWithPlayer: Bool = false
    
    // Category Name
    var categoryName: String = ""
    
    // Movement
    var isWalking: Bool = true
    var isRunning: Bool = false
    var isFlying: Bool = false
    var isCoiling: Bool = false
    var isFalling: Bool = false
    var readyToBeDestroyed = false
    
    // Basic Attributes
    var moveSpeed: CGFloat = 100.0 //* ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    // Attributes
    var walkSpeed: CGFloat = 100.0 //* ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var runSpeed: CGFloat = 120.0 //* ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var health: Int = 0
    var maxHealth: Int = 0
    var isAlive: Bool = true
    var damage: Int = 0
    var damageToShields: Int = 0
    var timeAlive: Double = 0.0
    
    // Damage cooldown
    var damageCooldown: Double = 0
    var maxDamageCooldown: Double = 2
    var previousDamage: Int = 0
    
    // Player interaction
    var playerCanBlock = true
    var playerCanDamage = true
    var playerContacted = false
    
    // Rewards
    var experience: Int = 0
    var heartsCollected: Bool = false
    var hasHeartsToCollect: Bool = false
    
    // Actions
    var numberOfAttacks: Int = 0
    
    // Actions to take right after initialization
    var justInitialized: Bool = true
    
    // Attacking
    var maxAttackCooldown : Double = 0.0;
    var attackCooldown : Double = 0.0;
    
    // PAssed in values
    var value1: Double = 0
    var value2: Double = 0
    
    // Knockback and stuff
    var needsToBeKnockedBack: Bool = false
    
    // Homing stuff needs this
    var isBeingTargeted: Bool = false
    
    // Sound action
    var actionSound: SKAction?
    
    weak var gameScene: GameScene?
    
    init(imageName: String, textureAtlas: SKTextureAtlas, scene: GameScene) {
        let texture = textureAtlas.textureNamed(imageName)
        
        super.init(texture: texture, color: UIColor.clear(), size: texture.size())
        
        // Get the scene
        self.gameScene = scene
        
        // Group actions to do in parallel
        self.deathAction = SKAction.sequence([SKAction.group([SKAction.rotate(byAngle: 360, duration: 1.0), SKAction.fadeOut(withDuration: 1.0), SKAction.scale(to: 0, duration: 1.0)]), SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.readyToBeDestroyed = true
            }
        })])
    }
    
    required init(scalar : Double, defaultYPosition: CGFloat, defaultXPosition: CGFloat, parent: SKNode, value1: Double, value2: Double, scene: GameScene) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func engageWithPlayer(_ player: Player) {
        //NSLog("Environment object just collided with player")
        
        // Record that the player just collided with the object
        self.justCollidedWithPlayer = true

        // TODO MAKE THIS SO ONLY DAMAGE IS TAKEN IF THIS ISN'T A COLLS IN THE BACK
        // TODO Proabaly move to the update phase
        //self.takeDamageFromPlayer(player)
        
        // TODO need to implement damage taking in the environment objects and projectiles
    }
    
    func takeDamageFromPlayer(_ player: Player) {
        if player.isBlocking {
            self.takeDamage(player.shieldDamage)
        }
        else {
            self.takeDamage(player.damage)
        }
    }
    
    func takeDamage(_ damage: Int) {
        self.health = self.health - damage
    }
    
    func checkHealth() {
        // If the enemy has no more health
        if self.health <= 0 && self.isAlive {
            // Remove the physics body to prevent collisions
            //self.physicsBody = nil;
            self.physicsBody!.categoryBitMask = GameScene.deathCategory
            self.physicsBody!.collisionBitMask = GameScene.groundCategory
            self.physicsBody!.contactTestBitMask = GameScene.groundCategory
            
            // Set the indicator that the enemy is dead
            self.isAlive = false
            self.updateAnimation()
        }
    }
    
    deinit {
        //self.removeAllActions()
    }
    
    func clearOutActions() {
        self.removeAllNonDeathActions() // walk fight float jump coil
        self.removeAction(forKey: "enemyDieing") //deathAction

        //self.removeAction(forKey: "extraAction") //extraAction = SKAction() The Slanky remove this himself bc it is on his range indicator
        //self.removeAction(forKey: "weaponAction") //weaponAction = SKAction() WindBeast removes this himself
        //self.removeAction(forKey: "startWalkingAction") //startWalkingAction = SKAction() Doesnt run on it's own. Part of walkAction
    }
    
    func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // Calc time alive
        self.timeAlive += timeSinceLast
        
        // Set previous positions
        self.previousPreviousPosition = CGPoint(x: self.previousPosition.x, y: self.previousPosition.y)
        self.previousPosition = CGPoint(x: self.position.x, y: self.position.y)
        self.previousVelocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: self.physicsBody!.velocity.dy)
        self.previousSpeed = self.speed
        
        // Damage changes
        if self.damageCooldown > 0 {
            self.damageCooldown -= timeSinceLast
            
            if self.damageCooldown <= 0 {
                self.damageCooldown = 0
                self.damage = self.previousDamage
            }
        }
    }
    
    func updateAfterPhysics() {
        if self.isAlive {
            if self.isFlying { // TODO do we need this? If update hs isFloating and sets velocity of Y to 0, is this needed? Check on collisions what happens
                // Set the Y to the right level
                self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0.0)
                self.position = CGPoint(x: self.position.x, y: self.defaultYPosition)
            }
            // Reset the Y position. Commonly used when something jumping hits the ground
            if self.needToResetYPosition {
                self.position = CGPoint(x: self.position.x, y: self.defaultYPosition)
                self.needToResetYPosition = false
            }
        }
        else {
            self.position = CGPoint(x: self.previousPosition.x, y: self.previousPosition.y)
        }
        
        // Frozen logic
        if self.isFrozen {
            self.position = self.previousPosition
            self.physicsBody!.velocity = CGVector(dx: 0.0, dy: 0.0)
            if self.justFrozen {
                self.removeAllNonDeathActions()
                self.attackCooldown = 1000
                self.maxAttackCooldown = 1000
                self.justFrozen = false
            }
        }
    }
    
    // Default attack function
    func attack(_ timeSinceLast: CFTimeInterval, player: Player) {
        if self.attackCooldown > 0 {
            self.attackCooldown = self.attackCooldown - timeSinceLast
        }
    }
    
    func setFlyingObjectProperties() {
        self.physicsBody!.affectedByGravity = false // Flies so no gravity
        self.physicsBody!.mass = self.physicsBody!.mass * 50 // We want a high mass so that when the player lands on the top of a flying enemy they get the restitution we want
        self.isFlying = true
    }
    
    func removeObjectFromParent() {
        self.removeFromParent()
        
        // Remove from worldView array
        /*
        var count = 0
        for envObject in self.gameScene!.worldViewEnvironmentObjects {
            if envObject === self {
                self.gameScene!.worldViewEnvironmentObjects.remove(at: count)
                break
            }
            
            count += 1
        }*/
        
        self.gameScene!.worldViewEnvironmentObjects.remove(at: self.gameScene!.worldViewEnvironmentObjects.index(of: self)!)
    }
    
    func removeAllNonDeathActions() {
        // Remove the old action
        self.removeAction(forKey: "enemyWalking")
        self.removeAction(forKey: "enemyFloating")
        self.removeAction(forKey: "enemyJumping")
        self.removeAction(forKey: "enemyCoiling")
        self.removeAction(forKey: "enemyFighting")
    }
    
    func updateAnimation() {
        self.removeAllActions()
        
        if !self.isAlive {
            // Remove the old action
            self.removeAllNonDeathActions()
            
            // Start the new action
            self.run(self.deathAction, withKey: "enemyDieing")
        }
        else if self.isJumping {
            // Remove the old action
            self.removeAction(forKey: "enemyWalking")
            self.removeAction(forKey: "enemyFloating")
            
            // Start the new action
            self.run(self.jumpAction, withKey: "enemyJumping")
        }
        else if self.isFloating {
            // Remove the old action
            self.removeAction(forKey: "enemyWalking")
            self.removeAction(forKey: "enemyJumping")
            
            // Start the new action
            self.run(self.floatAction, withKey: "enemyFloating")
        }
        else if self.isFighting {
            // Remove the old action
            self.removeAction(forKey: "enemyWalking")
            
            // Start the new action
            self.run(self.fightAction, withKey: "enemyFighting")
        }
        else if self.isWalking {
            // Remove the old action
            self.removeAction(forKey: "enemyFighting")
            self.removeAction(forKey: "enemyCoiling")
            
            // Start the new action
            self.run(self.walkAction, withKey: "enemyWalking")
        }
        else if self.isCoiling {
            // Remove the old action
            self.removeAction(forKey: "enemyWalking")
            
            // Start the new action
            self.run(self.coilAction, withKey: "enemyCoiling")
        }
    }
    
    // Function to start a damage cooldown so no damage is done until the cooldown is over
    func putDamageOnCooldown() {
        self.previousDamage = self.damage
        self.damage = 0
        self.damageCooldown = self.maxDamageCooldown
    }
    
    func collisionWithGround() {
        // If the object was jumping, stop the jump
        if self.isContinuouslyJumping && !self.isJumping && self.isFloating && !self.justStartedFloating {
            self.isJumping = true
        } else if !self.isContinuouslyJumping && self.isFloating {
            self.needToResetYPosition = true
            self.isFloating = false
            self.justCollidedWithGround = true
        }
    }
    
    func playerContactWithoutDamage() {
        self.playerContacted = true
    }
    
    func runAnimation() {
        // Start walking
        self.run(self.walkAction, withKey: "enemyWalking")
    }
    
    func freezeEnemy() {
        self.isFrozen = true
        self.justFrozen = true
    }
    
    func playActionSound() {
        SoundHelper.sharedInstance.playSoundAction(self, action: self.actionSound!)
    }
}
