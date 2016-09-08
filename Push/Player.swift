//
//  Player.swift
//  Push
//
//  Created by Dan Bellinski on 10/13/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import AudioToolbox

class Player : SKSpriteNode {
    // States/Positions
    var defaultPositionY: CGFloat = 0
    var isActiveJumping: Bool = false
    var isJumping: Bool = false
    var isStoppingJump: Bool = false
    var isBlocking: Bool = false
    var isShooting: Bool = false
    var isAlive: Bool = true
    var isHiding: Bool = false
    var isTeleporting: Bool = false
    var isComingOutOfHiding: Bool = false
    var isComingOutOfTeleport: Bool = false
    var justReceivedUpwardImpulseFromEnvironment: Bool = false
    
    var isOnGround: Bool = true
    
    // World view
    weak var worldView: SKNode?
    
    // For colls detection
    var justChangedDirections: Bool = false
    var justHitHeadOnEnvironmentObject: Bool = false
    
    // Jump extensions
    var additionalJumps = 0
    var maxAdditionalJumps = 0
    var allowDoubleJump = false
    
    var skill1Details = CharacterSkillDetails(upgrade: CharacterUpgrade.None)
    var skill2Details = CharacterSkillDetails(upgrade: CharacterUpgrade.None)
    var skill3Details = CharacterSkillDetails(upgrade: CharacterUpgrade.None)
    var skill4Details = CharacterSkillDetails(upgrade: CharacterUpgrade.None)
    var skill5Details = CharacterSkillDetails(upgrade: CharacterUpgrade.None)
    
    /*
    // Skill range indicator
    var skillRangeIndicator: SKNode?
    */
    
    var previousPosition: CGPoint = CGPoint()
    var previousPreviousPosition: CGPoint = CGPoint()
    var previousVelocity: CGVector = CGVector()
    var previousSpeed: CGFloat = 0
    
    // Animations
    var walkingFrames = Array<SKTexture>()
    var weaponFrames = Array<SKTexture>()
    
    // Fight Action
    var fightAction: SKAction = SKAction()
    
    // Attacking
    var maxAttackCooldown: Double = 0
    var attackCooldown: Double = 0
    var attacksInSuccession: Int = 0
    
    // Graphics
    var shield: SKSpriteNode = SKSpriteNode()
    var shieldStartPosition: CGPoint = CGPoint()
    var weapon: SKSpriteNode = SKSpriteNode()
    var weaponStartPosition: CGPoint = CGPoint()
    var redFlash: SKSpriteNode = SKSpriteNode()
    var blueFlash: SKSpriteNode = SKSpriteNode()
    
    // Acceleration
    var velocityRate: CGFloat = 0
    
    // Attributes
    var health: Int = 0
    var maxHealth: Int = 0
    var goldHearts: Int = 0
    var healthRegenerationTime: Double = 0
    var healthRegenerationTimeSpent: Double = 0
    var healthRegenerationAmount: Int = 0
    var maxSpeed: CGFloat = 0
    var damage: Int = 0
    var originalDamage: Int = 0
    var shieldDamage: Int = 0
    var enemyDamageReduction: Int = 0
    var obstacleDamageReduction: Int = 0
    var projectileDamageReduction: Int = 0
    
    // Jumping skill
    var jumpForce: CGFloat = 0
    var jumpCooldown: Double = 0.0
    
    // Collected Rewards
    var gold: Int = 0
    var experience: Int = 0
    
    // Archer skill - Later use for pets?
    var protectorOfTheSky: PlayerEagle?
    var protectorXAdjust: CGFloat = 0
    var protectorYAdjust: CGFloat = 0
    
    // Scene
    weak var gameScene: GameScene?
    
    // Skills
    var damageField: PlayerDamageField?
    var verticalVelocityToReset: CGFloat = 0
    var isHovering: Bool = false
    var hoveringVerticalPosition: CGFloat = 0
    var damageAvoided: Int = 0
    var spriteOverlay: SKSpriteNode?
    var spriteOverlay2: SKSpriteNode?
    var spriteOverlay2Action: SKAction = SKAction()
    
    // Hovering / Teleport
    var autoHoverStop: Bool = false
    var autoHoverStopCountdown: Double = 0
    var maxAutoHoverStopCountdown: Double = 0
    var teleportCount: Int = 0
    
    // Challenge counters
    var challengeHurtByObstacle: Bool = false
    var challengeTouchedAnObstacle: Bool = false
    var challengeHurtByProjectile: Bool = false
    var challengeTouchedAProjectile: Bool = false
    var challengeHurtByEnemy: Bool = false
    var challengeTouchedAnEnemy: Bool = false
    var challengeKilledByEnemy: Bool = false
    var challengeKilledByObstacle: Bool = false
    var challengeKilledByProjectile: Bool = false
    
    // Skill touch recording
    var touchedAnEnemyThisFrame: Bool = false
    var touchedAnObstacleThisFrame: Bool = false
    var touchedAProjectileThisFrame: Bool = false
    
    // Sounds
    var playedEngageSound: Bool = false
    
    // Grace damage
    var isGraceDamagePeriod: Bool = false
    var graceDamagePeriodCount: Double = 0.0
    
    // Perf
    var projectiles = Array<PlayerProjectile>()
    var projectiles2 = Array<PlayerProjectile>()
    
    // Sound actions
    var actionSoundSkill1: SKAction = SKAction()
    var actionSoundSkill2: SKAction = SKAction()
    var actionSoundSkill3: SKAction = SKAction()
    var actionSoundSkill4: SKAction = SKAction()
    var actionSoundSkill5: SKAction = SKAction()
    var actionSoundHurt: SKAction = SKAction()
    var actionSoundContact: SKAction = SKAction()
    var actionSoundCollision: SKAction = SKAction()
    var actionSoundJumpedOnObject: SKAction = SKAction()
    
    // Other actions
    var actionGroup1: SKAction = SKAction()
    var actionGroup2: SKAction = SKAction()
    var actionGroup3: SKAction = SKAction()
    var actionGroup4: SKAction = SKAction()
    
    // Alphs
    var forcedAlpha: CGFloat = 1.0
    
    // Range
    var rangeInd: SKSpriteNode?
    
    init() {
        super.init(texture: SKTexture(), color: UIColor.clear(), size: CGSize())
    }
    
    init(atlas: SKTextureAtlas, textureArrayName: String, worldView: SKNode?, gameScene: GameScene) {
        self.worldView = worldView
        self.gameScene = gameScene
        
        let texture = atlas.textureNamed(textureArrayName + ("_000"))
        
        super.init(texture: texture, color: UIColor.clear(), size: texture.size())
        
        // Set the walking frames for animation
        self.walkingFrames = SpriteKitHelper.getTextureArrayFromAtlas(atlas, texturesNamed: textureArrayName, frameStart: 0, frameEnd: 15)
        
        // Start player walking anim
        self.startPlayerWalkingAnimation()
        
        // Initialize attributes
        self.initializeAttributes()
        
        // Add the shield
        self.initializeShield()
        
        // Initialize skills
        self.initializeSkills()
        
        // Create the weapon
        self.initializeWeapon()
        
        // Initialize sounds
        //self.initSounds() We are going to do this on gameScene movement
        
        // Initialize class specific traits
        self.setupTraits()
        
        // Init player damage
        self.initPlayerDamaged()
        
        // Init skill flashes
        self.initSkillUsed()
        
        // Update the weapon position
        self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y)
        self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y)
        
        // Scaling // TODOSCALE remove once new images
        self.setScale(ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        // Update skill availability
        self.updateSkillsBasedOnPlayerPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeWeapon() {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    func setupTraits() {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    func createPhysicsBody() {
        preconditionFailure("This method must be overriden by the subclass")
    }
    
    func setPlayerAttachmentPositions(_ defaultYPosition: CGFloat, position: CGPoint) {
    }
    
    func initSounds() {
        if GameData.sharedGameData.preferenceSoundEffects {
            self.actionSoundHurt = SKAction.playSoundFileNamed(SoundType.Hurt.rawValue, waitForCompletion: true)
            self.actionSoundContact = SKAction.playSoundFileNamed(SoundType.Contact.rawValue, waitForCompletion: true)
            self.actionSoundCollision = SKAction.playSoundFileNamed(SoundType.Collision.rawValue, waitForCompletion: true)
            self.actionSoundJumpedOnObject = SKAction.playSoundFileNamed(SoundType.JumpedOnObject.rawValue, waitForCompletion: true)
        }
    }
    
    func initPlayerDamaged() {
        self.redFlash = SKSpriteNode(color: MerpColors.merpRed, size: CGSize(width: self.gameScene!.size.width, height: self.gameScene!.size.height))
        
        redFlash.zPosition = 11
        redFlash.alpha = 0.0
        redFlash.isUserInteractionEnabled = false
        redFlash.position = CGPoint(x: self.gameScene!.size.width / 2, y: self.gameScene!.size.height / 2)
        
        self.gameScene!.addChild(redFlash)
    }
    
    func initSkillUsed() {
        self.blueFlash = SKSpriteNode(color: MerpColors.merpBlue, size: CGSize(width: self.gameScene!.size.width, height: self.gameScene!.size.height))
        
        blueFlash.zPosition = 11
        blueFlash.alpha = 0.0
        blueFlash.isUserInteractionEnabled = false
        blueFlash.position = CGPoint(x: self.gameScene!.size.width / 2, y: self.gameScene!.size.height / 2)
        
        self.gameScene!.addChild(blueFlash)
    }
    
    func startPlayerWalkingAnimation() {
        // Create the run action
        self.run(SKAction.repeatForever(SKAction.animate(with: self.walkingFrames, timePerFrame: 0.05, resize: false, restore: true)), withKey: "playerWalking")
    }
    
    func initializeAttributes() {
        // Set the physics
        self.createPhysicsBody()

        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.restitution = 1.0
        self.physicsBody!.mass = (10.05)
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.friction = 0.0
        
        // Setup collision details for player
        self.resetContactBitMasks()
        
        // Jump booleans
        self.isJumping = false
        self.isStoppingJump = false
        
        // Velocity Rate
        self.velocityRate = 0.2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) // TODOSCALE want to scale this?
        
        // Attributes
        self.goldHearts = GameData.sharedGameData.getSelectedCharacterData().goldHearts
        self.maxHealth = 3
        self.health = 3
        self.damage = 1
        self.originalDamage = 1
        self.shieldDamage = 1
        self.healthRegenerationTime = 5.0
        self.healthRegenerationAmount = 0
        self.healthRegenerationTimeSpent = 0
        self.maxSpeed = 160 //* ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Collected rewards
        self.gold = 0
        self.experience = 0
        
        // Attacking
        self.maxAttackCooldown = 1.0
        self.attackCooldown = 0.0
    }
    
    func resetContactBitMasks() -> Void {
        // Setup collision details for player
        self.physicsBody!.categoryBitMask = GameScene.playerCategory
        self.physicsBody!.collisionBitMask = GameScene.groundCategory | GameScene.enemyCategory | GameScene.obstacleCategory
        self.physicsBody!.contactTestBitMask = GameScene.groundCategory | GameScene.enemyCategory | GameScene.transparentObstacleCategory | GameScene.projectileCategory | GameScene.transparentEnemyCategory
    }
    
    func initializeShield() {
        self.shield = SKSpriteNode(texture: GameTextures.sharedInstance.playerWarriorAtlas.textureNamed("playershield"))
        self.shield.size = CGSize(width: self.shield.size.width / 1.7, height: self.shield.size.height / 1.7)
        self.addChild(self.shield)
        self.shieldStartPosition = CGPoint(x: 16, y: -10)
        self.shield.position = self.shieldStartPosition
        self.shield.alpha = 0.0
    }
    
    // Character skills
    func initializeSkills() {
        for unlockedUpgrade in GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades {
            let upgrade = CharacterSkillDetails(upgrade: CharacterUpgrade(rawValue: unlockedUpgrade as! String)!)
            
            // If this is a boost, boost the skill it modifies
            if upgrade.type == .Boost || upgrade.type == .Enhancement {
                // Get the player skill that matches the parent
                let skill: CharacterSkillDetails = self.getSkill(upgrade.targetSkill)!
                
                // Now boost the skill according to the details
                skill.value += upgrade.value
                skill.secondaryValue += upgrade.secondaryValue
                skill.tertiaryValue += upgrade.tertiaryValue
                
                skill.range += upgrade.range
                skill.secondaryRange += upgrade.secondaryRange
                
                skill.skillCountRegeneration -= upgrade.skillCountRegeneration
                skill.activeSkillCountRegeneration = skill.skillCountRegeneration
                
                skill.skillCount += upgrade.skillCount
                skill.activeSkillCount = skill.skillCount
                
                skill.maxCooldownCount -= upgrade.maxCooldownCount
                skill.activeCooldownCount = skill.maxCooldownCount
                
                skill.maxActiveLength += upgrade.maxActiveLength
                skill.activeLength = skill.maxActiveLength
                
                skill.chargeCount += upgrade.chargeCount
                skill.chargeRecoup += upgrade.chargeRecoup
                skill.maxChargeCount += upgrade.chargeCount
                
                // If this is an enhancement, need to modify the skill or player in some way
            }
            if upgrade.type == UpgradeType.Enhancement {
                if upgrade.upgrade == CharacterUpgrade.DoubleJump || upgrade.upgrade == CharacterUpgrade.TripleJump || upgrade.upgrade == CharacterUpgrade.DoubleTeleport || upgrade.upgrade == CharacterUpgrade.TripleTeleport {
                    self.additionalJumps += 1
                    self.maxAdditionalJumps += 1
                }
            }
        }
        
        // Lets add the passive skills
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.FirstAidKit) {
            self.boostHealthWithSkill(CharacterUpgrade.FirstAidKit)
            
            // Regen time
            self.healthRegenerationTime = self.getSkill(CharacterUpgrade.FirstAidKit)!.skillCountRegeneration
            
            // Regen amount
            self.healthRegenerationAmount = Int(self.getSkill(CharacterUpgrade.FirstAidKit)!.secondaryValue)
        }
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.HealthPotion) {
            self.boostHealthWithSkill(CharacterUpgrade.HealthPotion)
        }
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.KiShield) {
            self.boostHealthWithSkill(CharacterUpgrade.KiShield)
        }
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.ForceField) {
            self.boostHealthWithSkill(CharacterUpgrade.ForceField)
        }
    }
    
    func boostHealthWithSkill(_ skill: CharacterUpgrade) {
        // Max HP boost
        self.maxHealth += Int(self.getSkill(skill)!.value)
        self.health += Int(self.getSkill(skill)!.value)
    }
    
    // Default attack function
    func attack(_ timeSinceLast: CFTimeInterval) {
        // The player is in sight of the enemy
        if self.attackCooldown > 0 {
            // Set move speed to 0 to stop movement
            //self.moveSpeed = 0; // TODO REMOVE?? Always move speed 0??
            
            // Set the cooldown really high, this will be reset when the attack finishes
            self.attackCooldown = self.attackCooldown - timeSinceLast
        }
        if self.attackCooldown <= 0 {
            self.attackCooldown = 100.0
            
            // Set to fighting
            self.isShooting = true
            
            // Start the animation
            self.weapon.run(self.fightAction)
        }
    }
    
    /*
    func setDontTakeTeleportDamage() {
        self.dontTakeTeleportDamage = true
        self.dontTakeTeleportDamageCount = 1
    }
     */
    
    func update(_ timeSinceLast: CFTimeInterval) {
        if (self.isAlive) {
            // Check the player health
            checkHealth()
            
            /*
            // Teleporting stuff. Don't take damage
            if self.dontTakeTeleportDamage && self.dontTakeTeleportDamageCount == 1 {
                self.dontTakeTeleportDamageCount -= 1
            } else if self.dontTakeTeleportDamage {
                self.dontTakeTeleportDamage = false
            }
            */
        }
        
        if (self.isAlive) {
            // Grace damage period
            if self.isGraceDamagePeriod {
                self.graceDamagePeriodCount -= timeSinceLast
                
                if self.graceDamagePeriodCount <= 0 {
                    self.isGraceDamagePeriod = false
                    self.removeAction(forKey: "grace_period")
                    self.alpha = self.forcedAlpha
                }
            }
            
            if self.justHitHeadOnEnvironmentObject {
                // Try to reset the velocity
                self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
                
                self.justHitHeadOnEnvironmentObject = false
            }
            
            // Check for teleporting
            if self.isTeleporting {
                self.teleportCount -= 1
                
                if self.teleportCount <= 0 {
                    self.stopTeleport()
                }
            }
            
            // Automatically stop hover if requested
            if self.autoHoverStop {
                self.autoHoverStopCountdown -= timeSinceLast
                
                if self.autoHoverStopCountdown <= 0 || self.touchedAnObstacleThisFrame || self.touchedAnEnemyThisFrame || self.touchedAProjectileThisFrame {
                    self.stopHovering()
                }
            }
            
            // Reduce jump cooldown
            if self.jumpCooldown > 0 {
                self.jumpCooldown -= timeSinceLast
            }
            
            if self.isStoppingJump {
                // Try to reset the velocity for the player
                self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
            }
            
            // Update skills if needed
            self.updateSkills(timeSinceLast)
            
            // Move the player
            self.move()
            
            // Calculate the previous positions
            self.previousPreviousPosition = CGPoint(x: self.previousPosition.x, y: self.previousPosition.y)
            self.previousPosition = CGPoint(x: self.position.x, y: self.position.y)
            self.previousVelocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: self.physicsBody!.velocity.dy)
            self.previousSpeed = self.speed
            
            // Regenerate health
            if self.health < self.maxHealth {
                self.healthRegenerationTimeSpent += timeSinceLast
            }
            else {
                self.healthRegenerationTimeSpent = 0
            }
            
            // If we've reached regeneration
            if self.healthRegenerationTimeSpent >= self.healthRegenerationTime {
                self.healthRegenerationTimeSpent = self.healthRegenerationTimeSpent - self.healthRegenerationTime
                self.health += self.healthRegenerationAmount
                
                // If we went over max health, bring it back down
                if self.health > self.maxHealth {
                    self.health = self.maxHealth
                }
            }
            // Attack
            self.attack(timeSinceLast)
            
            // We need to work through the transparent player stuff here
            if self.physicsBody!.categoryBitMask == GameScene.transparentPlayerCategory {
                if self.isComingOutOfHiding || self.isComingOutOfTeleport {
                    // If there are things we're colliding with, take damage and stay hiding
                    if self.gameScene!.transparentEnemyContacts.count > 0 {
                        for enemy: Enemy in self.gameScene!.transparentEnemyContacts {
                            // We havent already taken damage for this
                            if !self.gameScene!.transparentObjectsAlreadyDamagedPlayer.contains(enemy.name!) && enemy.health > 0 {
                                //Challenge tracking
                                self.recordTouchFromObject(enemy)
                                
                                if !self.isComingOutOfTeleport || !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.TeleportDamageImmunity) {
                                    // Take damage from the object
                                    self.frontEngageWithEnvironmentObject(enemy)
                                }
                                
                                // Add it to the list
                                self.gameScene!.transparentObjectsAlreadyDamagedPlayer.append(enemy.name!)
                                
                                // Only deal damage to the enemy if we came out of a teleport
                                if self.isComingOutOfTeleport {
                                    // Damage the projectile now
                                    enemy.takeDamageFromPlayer(self)
                                }
                            }
                            
                            if enemy.health <= 0 {
                                self.gameScene!.removeFromTransparentEnemyContacts(enemy)
                            }
                        }
                    }
                    if self.gameScene!.transparentObstacleContacts.count > 0 {
                        for obstacle: Obstacle in self.gameScene!.transparentObstacleContacts {
                            // We havent already taken damage for this
                            if !self.gameScene!.transparentObjectsAlreadyDamagedPlayer.contains(obstacle.name!) && obstacle.health > 0 {
                                //Challenge tracking
                                self.recordTouchFromObject(obstacle)
                                
                                if !self.isComingOutOfTeleport || !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.TeleportDamageImmunity) {
                                    // Take damage from the object
                                    self.frontEngageWithEnvironmentObject(obstacle)
                                }
                                
                                // Add it to the list
                                self.gameScene!.transparentObjectsAlreadyDamagedPlayer.append(obstacle.name!)
                                
                                // Only deal damage to the enemy if we came out of a teleport
                                if self.isComingOutOfTeleport {
                                    // Damage the projectile now
                                    obstacle.takeDamageFromPlayer(self)
                                }
                            }
                            
                            if obstacle.health <= 0 {
                                self.gameScene!.removeFromTransparentObstacleContacts(obstacle)
                            }
                        }
                    }
                    if self.gameScene!.transparentProjectileContacts.count > 0 {
                        for projectile: Projectile in self.gameScene!.transparentProjectileContacts {
                            // We havent already taken damage for this
                            if !self.gameScene!.transparentObjectsAlreadyDamagedPlayer.contains(projectile.name!) && projectile.health > 0 {
                                //Challenge tracking
                                self.recordTouchFromObject(projectile)
                                
                                if !self.isComingOutOfTeleport || !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.TeleportDamageImmunity) {
                                    // Take damage from the object
                                    self.frontEngageWithEnvironmentObject(projectile)
                                }
                                
                                // Add it to the list
                                self.gameScene!.transparentObjectsAlreadyDamagedPlayer.append(projectile.name!)
                                
                                // Damage the projectile now
                                projectile.takeDamageFromPlayer(self)
                            }
                            
                            if projectile.health <= 0 {
                                self.gameScene!.removeFromTransparentProjectileContacts(projectile)
                            }
                        }
                    }
                    // For teleporting only, we
                    
                    // All empty, let's come out of transparency
                    if self.gameScene!.transparentEnemyContacts.count == 0 && self.gameScene!.transparentObstacleContacts.count == 0 && self.gameScene!.transparentProjectileContacts.count == 0 {
                        self.resetContactBitMasks()
                    }
                }
            }
        }
    }
    
    func updateMaxHearts(_ hearts: Int) {
        self.health = self.health + hearts
        self.maxHealth = self.maxHealth + hearts
    }
    
    func updateAfterPhysics() {
        // If the player is hovering, don't let their y velocity change
        if self.isHovering {
            self.position = CGPoint(x: self.position.x, y: self.hoveringVerticalPosition)
            self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
        }

        // determine if the player changed directions in some way
        if (self.previousVelocity.dx > 0 && self.physicsBody?.velocity.dx <= 0.1) || (self.previousVelocity.dy > 0 && self.physicsBody?.velocity.dy <= 0.1) ||
            (self.previousVelocity.dx < 0 && self.physicsBody?.velocity.dx >= -0.1) || (self.previousVelocity.dy < 0 && self.physicsBody?.velocity.dy >= -0.1) {
            self.justChangedDirections = true
        } else {
            self.justChangedDirections = false
        }
        
        if self.justReceivedUpwardImpulseFromEnvironment {
            // We don't want to do this again
            self.justReceivedUpwardImpulseFromEnvironment = false
            
            self.isStoppingJump = false
        }
        
        if (self.isAlive) {
            // If the player is in the process of stopping a jump, then stop it // TODO integrate with new skill system
            if self.isStoppingJump {
                self.stopJumping()
                
                // Try to reset the velocity for the player
                //self.physicsBody!.velocity = CGVectorMake(self.physicsBody!.velocity.dx, 0)
            }
            else {
                if self.isActiveJumping && !self.isJumping && self.jumpCooldown <= 0 {  // If the player is activeJumping, and not jumping, then jump // TODO integate with new skill system
                    self.startJumping(self.jumpForce)
                }
            }
            
            // Move the weapon with the player animation
            self.updateWeapon() // TODO can move this into didEvaluateActions
        }
        
        /*
        // Update the skill range indicator
        if self.skillRangeIndicator != nil {
            self.skillRangeIndicator?.position = CGPointMake(0, self.defaultPositionY - self.position.y - self.size.height/2 - 1)
        }
        */
        
        // Remove touches this frame
        self.clearTouchesFromObjectsThisFrame()
        
        // Keep the player and follower together
        self.damageField?.position = self.position
    }
    
    func updateAfterConstraints() {
        // Keep the player and follower together
        self.damageField?.position = self.position
    }
    
    func checkHealth() {
        // If the enemy has no more health
        if self.health <= 0 && self.isAlive {
            self.executeDeath()
        }
    }
    
    func executeDeath() {
        // Set the indicator that the player is dead
        self.isAlive = false
        
        // Remove the physics body to prevent collisions
        //self.physicsBody = nil;
        self.physicsBody!.categoryBitMask = GameScene.deathCategory
        self.physicsBody!.collisionBitMask = GameScene.groundCategory
        self.physicsBody!.contactTestBitMask = GameScene.groundCategory
        
        // Group actions to do in parallel
        self.actionGroup1 = SKAction.group([SKAction.rotate(byAngle: 360, duration: 1.0), SKAction.fadeOut(withDuration: 2.0), SKAction.scale(to: 0, duration: 2.0)])
        
        self.removeAction(forKey: "playerWalking")
        
        // Start the new action
        self.run(SKAction.sequence([self.actionGroup1]), withKey: "playerDieing")
    }
    
    func rejuvPlayer(position: CGPoint, numberOfHearts: Int) {
        //NSLog("\(self.position.x), y \(self.position.y)")
        self.removeAllActions()
        self.position = position
        self.health = numberOfHearts
        self.goldHearts = numberOfHearts
        //GameData.sharedGameData.getSelectedCharacterData().goldHearts = self.goldHearts
        //GameData.sharedGameDxata.save()
        
        self.isAlive = true
        self.alpha = 1.0
        self.setScale(ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        //self.runAction(SKAction.fadeInWithDuration(1))
        self.zRotation = 0
        self.physicsBody!.velocity = CGVector()
        
        // Reset player attributes
        self.isJumping = false
        self.isStoppingJump = false
        self.isBlocking = false
        self.isTeleporting = false
        self.isHovering = false
        self.isShooting = false
        self.isComingOutOfHiding = false
        self.isActiveJumping = false
        
        self.startHiding() // Set all the bit masks so we don't get placed on top of something
        self.stopHiding() // Leave hiding but don't pop out until past everything
        self.startGracePeriod(1.5) // Don't take damage for 1.2 seconds
        self.startPlayerWalkingAnimation() // Start walk animation again
    }
    
    func completeLevel() {
        // Technically the player isn't dead but they completed the level so we don't want anything else to happen to them
        self.isAlive = false
        
        // Remove the physics body to prevent collisions
        //self.physicsBody = nil;
        self.physicsBody!.categoryBitMask = GameScene.deathCategory
        self.physicsBody!.collisionBitMask = GameScene.groundCategory
        self.physicsBody!.contactTestBitMask = GameScene.groundCategory
        
        // Group actions to do in parallel
        self.actionGroup2 = SKAction.group([SKAction.fadeOut(withDuration: 3.0), SKAction.scale(to: 3, duration: 3.0)])
        
        self.removeAction(forKey: "playerWalking")
        
        // Start the new action
        self.run(SKAction.sequence([self.actionGroup2]), withKey: "playerWinning")
    }
    
    func updateWeapon() {
        let scalar: CGFloat = 1.0
        for i in 0 ..< self.walkingFrames.count {
            if self.texture!.isEqual(self.walkingFrames[i]) {
                switch i {
                case 0, 8: // First Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y)
                    self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y)
                case 1, 7, 9, 15: // Second Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 1 * scalar)
                    self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y - 1 * scalar)
                case 2, 6, 10, 14: // Third Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 2 * scalar)
                    self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y - 2 * scalar)
                case 3, 5, 11, 13: // Fourth Highest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 3 * scalar)
                    self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y - 3 * scalar)
                case 4, 12: // Lowest
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y - 4 * scalar)
                    self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y - 4 * scalar)
                default:
                    self.weapon.position = CGPoint(x: self.weaponStartPosition.x, y: self.weaponStartPosition.y)
                    self.shield.position = CGPoint(x: self.shieldStartPosition.x, y: self.shieldStartPosition.y)
                }
            }
        }
    }
    
    func move() {
        // TODO - need to factor in anything for timeSinceLast??
        
        // Create the velocity vector to apply to the player's velocity
        let relativeVelocity: CGVector = CGVector(dx: self.maxSpeed - self.physicsBody!.velocity.dx, dy: 0.0)
        
        // Multiply the Y by the jumping boolen. If we aren't jumping, we don't want Y to move.
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx + relativeVelocity.dx * self.velocityRate, dy: (self.physicsBody!.velocity.dy + relativeVelocity.dy * self.velocityRate) * CGFloat(self.isJumping) * CGFloat(!self.isHovering))
    }
    
    func startActiveJumping() { // TODO replace with a check to see if the button is being pressed and if the skill is one that is activated on press instead of release
        self.isActiveJumping = true
    }
    
    func stopActiveJumping() {
        self.isActiveJumping = false
    }
    
    func applyUpwardImpulseFromObject(_ force: CGFloat) {
        self.justReceivedUpwardImpulseFromEnvironment = true
        self.startJumping(force)
    }
    
    func startJumping(_ force: CGFloat) {
        // Try to reset the velocity
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
        
        // Apply an impulse upward on player to simulate jump
        self.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: force))
        
        //Set the jumping flag
        self.isJumping = true
        
        // Not on ground anymore
        self.isOnGround = false
        
        // Stop active jumping NEW
        //self.isActiveJumping = false
        //self.gameScene!.getButtonWithSkill(CharacterUpgrade.Jump)!.releaseButton()
        self.jumpCooldown = 0.5
        
        // Don't allow double jumps until the button is pressed again
        self.allowDoubleJump = false
        
        self.updateSkillsBasedOnPlayerPosition()
        
        // Sound effect!
        self.playActionSound(action: self.actionSoundSkill1)
    }
    
    func startTeleport(_ position: CGFloat, fromDefaultPosition: Bool) {
        // Try to reset the velocity
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
        
        // teleport
        if fromDefaultPosition {
            self.position = CGPoint(x: self.position.x, y: self.defaultPositionY + position)
        } else {
            self.position = CGPoint(x: self.position.x, y: self.position.y + position)
        }
        
        //Set the jumping flag
        self.isJumping = true
        self.allowDoubleJump = false
        
        // Not on ground anymore
        self.isOnGround = false
        
        // Set teleport flag
        self.isTeleporting = true
        self.isComingOutOfTeleport = false
        
        // Dont want teleport to end until collisions can occur
        self.teleportCount = 2
        
        // Go invis
        self.startInvisibility()
        
        self.updateSkillsBasedOnPlayerPosition()
        
        self.playActionSound(action: self.actionSoundSkill1)
    }
    
    func stopTeleport() {
        // Not teleporting anymore
        self.isTeleporting = false
        
        // We need to use this to properly interact with objects we teleport into
        self.isComingOutOfTeleport = true
        
        // Stop invis
        self.stopInvisibility()
        
        // Now we want to hover for a bit
        self.startHovering()
        
        // Set the cooldown on the hover
        self.autoHoverStop = true
        self.autoHoverStopCountdown = self.maxAutoHoverStopCountdown
    }
    
    func updateSkillsBasedOnPlayerPosition() {
        // Loop through the player skills and disable any that are ground only. Enable any that are air only
        if (self.skill1Details.restriction == .Ground && !self.isOnGround) || (self.skill1Details.restriction == .Air && self.isOnGround) {
            self.skill1Details.isDisabled = true
        } else {
            self.skill1Details.isDisabled = false
        }
        
        if (self.skill2Details.restriction == .Ground && !self.isOnGround) || (self.skill2Details.restriction == .Air && self.isOnGround) {
            self.skill2Details.isDisabled = true
        } else {
            self.skill2Details.isDisabled = false
        }
        
        if (self.skill3Details.restriction == .Ground && !self.isOnGround) || (self.skill3Details.restriction == .Air && self.isOnGround) {
            self.skill3Details.isDisabled = true
        } else {
            self.skill3Details.isDisabled = false
        }
        
        if (self.skill4Details.restriction == .Ground && !self.isOnGround) || (self.skill4Details.restriction == .Air && self.isOnGround) {
            self.skill4Details.isDisabled = true
        } else {
            self.skill4Details.isDisabled = false
        }
        
        if (self.skill5Details.restriction == .Ground && !self.isOnGround) || (self.skill5Details.restriction == .Air && self.isOnGround) {
            self.skill5Details.isDisabled = true
        } else {
            self.skill5Details.isDisabled = false
        }
    }
    
    func stopJumping() {
        //NSLog("-----------Jump start")
        
        // Stop the jumping flag
        self.isJumping = false
        
        // We want to keep the X where it is but set the Y to the default so that the jump stops
        self.position = CGPoint(x: self.position.x, y: self.defaultPositionY)
        
        // No longer need to stop the jump
        self.isStoppingJump = false
        //NSLog("------------Jump end")
        
        // Don't allow double jumps until the button is pressed again
        self.allowDoubleJump = false
        
        // Reset the aditional jumps
        self.additionalJumps = self.maxAdditionalJumps
        
        // Loop through the player skills and disable any that are air only. Enable any that are ground only
        self.updateSkillsBasedOnPlayerPosition()
    }
    
    func startBlocking() {
        self.isBlocking = true
        self.shield.alpha = 1.0
    }
    
    func stopBlocking() {
        self.isBlocking = false
        self.shield.alpha = 0.0
    }
    
    func startHiding() {
        self.isHiding = true
        self.isComingOutOfHiding = false
        
        self.startInvisibility()
    }
    
    func startInvisibility() {
        self.alpha = 0.5
        self.forcedAlpha = 0.5
        
        // Setup collision details for player
        self.physicsBody!.categoryBitMask = GameScene.transparentPlayerCategory
        self.physicsBody!.collisionBitMask = GameScene.groundCategory //| GameScene.obstacleCategory
        self.physicsBody!.contactTestBitMask = GameScene.groundCategory | GameScene.obstacleCategory | GameScene.enemyCategory | GameScene.projectileCategory | GameScene.transparentObstacleCategory | GameScene.transparentEnemyCategory
    }
    
    func stopHiding() {
        self.isHiding = false
        self.isComingOutOfHiding = true
        
        self.stopInvisibility()
    }
    
    func stopInvisibility() {
        self.alpha = 1.0
        self.forcedAlpha = 1.0
        self.gameScene!.transparentObjectsAlreadyDamagedPlayer.removeAll()
    }
    
    func frontEngageWithEnvironmentObject(_ object: EnvironmentObject) {
        if (self.isAlive) && !self.isGraceDamagePeriod {
            // Determine how much damage this object can deal
            var objectDamage: Int = object.damage
            var objectShieldDamage: Int = object.damageToShields
            
            // Damage mitigation
            if object is Projectile {
                if objectDamage > 0 && self.projectileDamageReduction > 0 {
                    if objectDamage <= self.projectileDamageReduction {
                        self.damageAvoided = objectDamage
                    } else {
                        self.damageAvoided = objectDamage - self.projectileDamageReduction
                    }
                }
                objectDamage -= self.projectileDamageReduction
                objectShieldDamage -= self.projectileDamageReduction
            } else if object is Enemy {
                if objectDamage > 0 && self.enemyDamageReduction > 0 {
                    if objectDamage <= self.enemyDamageReduction {
                        self.damageAvoided = objectDamage
                    } else {
                        self.damageAvoided = objectDamage - self.enemyDamageReduction
                    }
                }
                objectDamage -= self.enemyDamageReduction
                objectShieldDamage -= self.enemyDamageReduction
            } else if object is Obstacle {
                if objectDamage > 0 && self.obstacleDamageReduction > 0 {
                    if objectDamage <= self.obstacleDamageReduction {
                        self.damageAvoided = objectDamage
                    } else {
                        self.damageAvoided = objectDamage - self.obstacleDamageReduction
                    }
                }
                objectDamage -= self.obstacleDamageReduction
                objectShieldDamage -= self.obstacleDamageReduction
            }
            
            if objectDamage < 0 {
                objectDamage = 0
            }
            
            if objectShieldDamage < 0 {
                objectShieldDamage = 0
            }
            
            // If the player is blocking, remove shields
            if object.playerCanBlock && self.isBlocking && getSkill(CharacterUpgrade.Block) != nil {
                // Get the block skill
                let skillDetails = getSkill(CharacterUpgrade.Block)!
                
                // Determine how many shields are left versus what the object impacts
                if objectShieldDamage >= skillDetails.activeSkillCount {
                    
                    // Damage player for difference
                    self.takeDamage(((objectShieldDamage - skillDetails.activeSkillCount) / objectShieldDamage) * objectDamage, object: object)
                    
                    // Now we need to zero the shields out
                    skillDetails.activeSkillCount = 0
                    
                    // The player is no longer blocking
                    self.stopBlocking()
                }
                else { // If the player is not blocking, take damage
                    skillDetails.activeSkillCount = skillDetails.activeSkillCount - objectShieldDamage
                }
            }
            else if objectDamage > 0 {
                self.takeDamage(objectDamage, object: object)
            }
            
            // Now check the player's health to see if they are stil alive
            checkHealth()
        }
    }
    
    func takeDamage(_ damage: Int, object: EnvironmentObject) {
        if damage > 0 {
            self.health = self.health - damage
            
            // Reduce gold hearts if any
            if self.goldHearts > 0 {
                self.goldHearts = self.goldHearts - damage
                GameData.sharedGameData.getSelectedCharacterData().goldHearts = self.goldHearts
                //GameData.sharedGameData.save()
            }
            
            self.animatePlayerDamaged()
            
            self.playActionSound(action: self.actionSoundHurt)
            
            // Vibrate
            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            self.playedEngageSound = true
            
            if object is Enemy {
                self.challengeHurtByEnemy = true
            } else if object is Obstacle {
                self.challengeHurtByObstacle = true
            } else if object is Projectile {
                self.challengeHurtByProjectile = true
            }
            
            if self.health <= 0 {
                if object is Enemy {
                    self.challengeKilledByEnemy = true
                } else if object is Obstacle {
                    self.challengeKilledByObstacle = true
                } else if object is Projectile {
                    self.challengeKilledByProjectile = true
                }
            }
            
            // Need to turn on grace period 
            self.startGracePeriod(1.2)
        }
    }
    
    func startGracePeriod(_ length: Double) {
        self.isGraceDamagePeriod = true
        self.graceDamagePeriodCount = length
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 0.125), SKAction.fadeIn(withDuration: 0.125)])), withKey: "grace_period")
    }
    
    func animatePlayerDamaged() {
        redFlash.alpha = 0.75
        redFlash.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25), SKAction.run({
                [weak self] in
                
                if self != nil {
                    self?.redFlash.alpha = 0.0
                }
            })]))
    }
    
    func animateSkillUsed() {
        blueFlash.alpha = 0.75
        blueFlash.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.2), SKAction.run({
                [weak self] in
                
                if self != nil {
                    self?.blueFlash.alpha = 0.0
                }
            })]))
    }
    
    func getSkill(_ upgrade: CharacterUpgrade) -> CharacterSkillDetails? {
        if self.skill1Details.upgrade == upgrade {
            return self.skill1Details
        } else if self.skill2Details.upgrade == upgrade {
            return self.skill2Details
        } else if self.skill3Details.upgrade == upgrade {
            return self.skill3Details
        } else if self.skill4Details.upgrade == upgrade {
            return self.skill4Details
        } else if self.skill5Details.upgrade == upgrade {
            return self.skill5Details
        } else {
            return nil
        }
    }
    
    func engageWithEnvironmentObject(_ object: EnvironmentObject) {
        self.contactOrCollisionMethods(object)
        
        // Stop hovering on any contact with enemy
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.Hover) && self.isHovering {
            // If the object is a projectile and the skill has a value left, ignore this and keep hovering.
            if object is Projectile && self.getSkill(CharacterUpgrade.Hover)!.value > 0 {
                self.getSkill(CharacterUpgrade.Hover)!.value -= 1 // Remove the block
                
                // TODO play a block like sound?
            } else {
                self.deactivateSkill(self.getSkill(CharacterUpgrade.Hover)!)
                self.performEngageLogic(object)
            }
        } else {
            self.performEngageLogic(object)
        }
    }
    
    func performEngageLogic(_ object: EnvironmentObject) {
        // Haven't played sound yet
        self.playedEngageSound = false
        
        // The X velocity is about 0, we're not moving forward, we collided with something in front of us
        if self.physicsBody!.velocity.dx <= 0.1 { // we're moving backwards
            
            if let charge = self.getSkill(CharacterUpgrade.Charge) {
                if charge.skillIsActive {
                    // Don't take damage yourself
                    // Damage the object any "excess" damage because our damage is going to get reset below
                    let excessDamage = self.damage - self.originalDamage
                    if excessDamage > 0 {
                        object.takeDamage(excessDamage)
                    }
                    
                    // Deactivate skill
                    charge.skillIsActive = false
                    charge.activeLength = charge.maxActiveLength
                    self.deactivateSkill(charge)
                    
                } else {
                    // Take Damage
                    self.frontEngageWithEnvironmentObject(object)
                }
            } else {
                // Take Damage
                self.frontEngageWithEnvironmentObject(object)
            }
            
            // Make sure the enemy goes backwards
            object.needsToBeKnockedBack = true
            
            if (self.isAlive) {
                // Move player backwards
                self.knockBackwards(object, modifier: nil)
            } else {
                // We only want a small rebound because the player won't be walking forward anymore
                self.knockBackwards(object, modifier: 200)
            }
        } else if self.position.y - self.size.height / 2 < object.position.y - object.size.height / 2 {
            // Player hit the bottom of the enemy
            self.justHitHeadOnEnvironmentObject = true
            
            // Take Damage
            self.frontEngageWithEnvironmentObject(object)
        } else if !(self.position.y > object.position.y) { // Player didn't jump on enemy but may have collided with his back
            // Take Damage
            self.frontEngageWithEnvironmentObject(object)
        } else {
            // We are assuming we jumped on the enemy
            self.playActionSound(action: self.actionSoundJumpedOnObject)
            self.playedEngageSound = true
        }
        
        if !self.playedEngageSound {
            self.playActionSound(action: self.actionSoundCollision)
            self.playedEngageSound = true
        }
    }
    
    func knockBackwards(_ object: EnvironmentObject, modifier: Int?) {
        if modifier != nil {
            self.physicsBody!.applyImpulse(CGVector(dx: object.playerCollisionRebound / CGFloat(modifier!) * self.physicsBody!.mass, dy: 0.0))
        } else {
            self.physicsBody!.applyImpulse(CGVector(dx: object.playerCollisionRebound * self.physicsBody!.mass, dy: 0.0))
        }
    }
    
    func contactWithEnvironmentObject(_ object: EnvironmentObject) {
        self.contactOrCollisionMethods(object)
        
        // Stop hovering on any contact with enemy
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.Hover) && self.isHovering {
            // If the object is a projectile and the skill has a value left, ignore this and keep hovering.
            if object is Projectile && self.getSkill(CharacterUpgrade.Hover)!.value > 0 {
                self.getSkill(CharacterUpgrade.Hover)!.value -= 1 // Remove the block
                
                // TODO play a block like sound?
            } else {
                self.deactivateSkill(self.getSkill(CharacterUpgrade.Hover)!)
                self.performEngageLogic(object)
            }
        } else {
            self.performContactLogic(object)
        }
        
        // Put the object's damage on cooldown TODO move this to the engage with player function and only trigger it if there is a boolean set to do so
        object.putDamageOnCooldown()
    }
    
    func performContactLogic(_ object: EnvironmentObject) {
        // Take Damage
        self.frontEngageWithEnvironmentObject(object)

        self.playActionSound(action: self.actionSoundContact)
    }
    
    func contactOrCollisionMethods(_ object: EnvironmentObject) {
        // Skill tracking
        self.recordTouchFromObjectThisFrame(object)
        
        // Challenge tracking
        self.recordTouchFromObject(object)
    }
    
    func recordTouchFromObject(_ object: EnvironmentObject) {
        if object is Enemy {
            self.challengeTouchedAnEnemy = true
        } else if object is Obstacle {
            self.challengeTouchedAnObstacle = true
        } else if object is Projectile {
            self.challengeTouchedAProjectile = true
        }
    }
    
    func recordTouchFromObjectThisFrame(_ object: EnvironmentObject) {
        if object is Enemy {
            self.touchedAnEnemyThisFrame = true
        } else if object is Obstacle {
            self.touchedAnObstacleThisFrame = true
        } else if object is Projectile {
            self.touchedAProjectileThisFrame = true
        }
    }
    
    func clearTouchesFromObjectsThisFrame() {
        self.touchedAnEnemyThisFrame = false
        self.touchedAnObstacleThisFrame = false
        self.touchedAProjectileThisFrame = false
    }
    
    func updateSkills(_ timeSinceLast: CFTimeInterval) {
        self.updateSkill(timeSinceLast, skill: self.skill1Details)
        self.updateSkill(timeSinceLast, skill: self.skill2Details)
        self.updateSkill(timeSinceLast, skill: self.skill3Details)
        self.updateSkill(timeSinceLast, skill: self.skill4Details)
        self.updateSkill(timeSinceLast, skill: self.skill5Details)
        self.updateSkillsBasedOnPlayerPosition()
    }
    
    func updateSkill(_ timeSinceLast: CFTimeInterval, skill: CharacterSkillDetails) {
        // If the skill is on a timer, reduce it
        if skill.skillIsActive {
            // Reduce the timer on the skill
            skill.activeLength -= timeSinceLast
            
            // Deactivate the skill
            if skill.activeLength <= 0 {
                skill.activeLength = skill.maxActiveLength
                self.deactivateSkill(skill)
            }
            // Inactive on ground
            else if skill.deactivatesOnGround && self.isOnGround {
                self.deactivateSkill(skill)
            }
            // Inactive due to contact
            else if skill.deactivatesOnObstacleContact && self.touchedAnObstacleThisFrame {
                self.deactivateSkill(skill)
            }
            else if skill.deactivatesOnProjectileContact && self.touchedAProjectileThisFrame {
                self.deactivateSkill(skill)
            }
            else if skill.deactivatesOnEnemyContact && self.touchedAnEnemyThisFrame {
                self.deactivateSkill(skill)
            }
        }
        
        if skill.skillIsUncharging {
            skill.chargeCount -= timeSinceLast

            // Deactivate the skill
            if skill.chargeCount <= 0 {
                skill.skillIsUncharging = false
                skill.activeLength = skill.maxActiveLength
                self.deactivateSkill(skill)
            }
            // Inactive on ground
            else if skill.deactivatesOnGround && self.isOnGround {
                self.deactivateSkill(skill)
            }
            // Inactive due to contact
            else if skill.deactivatesOnObstacleContact && self.touchedAnObstacleThisFrame {
                self.deactivateSkill(skill)
            }
            else if skill.deactivatesOnProjectileContact && self.touchedAProjectileThisFrame {
                self.deactivateSkill(skill)
            }
            else if skill.deactivatesOnEnemyContact && self.touchedAnEnemyThisFrame {
                self.deactivateSkill(skill)
            }
        }
        
        if skill.chargeRecoup > 0 && skill.chargeCount < skill.maxChargeCount {
            skill.chargeCount += timeSinceLast * skill.chargeRecoup
        }
        
        // If we were on cooldown but not anymore, reactivate skill
        if !skill.cooldownInProgress && skill.previouslyCoolingDown {
            // We're done with our cooldown
            skill.previouslyCoolingDown = false
            
            // Let's reactivate the skill
            self.reactivateSkill(skill)
        }
    }
    
    func launchRock(_ range: CGFloat, height: CGFloat, forwardMomentum: CGFloat) {
        let rock: PlayerRock = self.projectiles2.popLast() as! PlayerRock
        
        rock.physicsBody!.velocity = CGVector()
        
        rock.position = CGPoint(x: self.position.x + range, y: self.defaultPositionY - 30 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        // Change the name back to default so it receives updates
        rock.resetName()
        
        // Unhide it
        rock.isHidden = false
        
        // Set physics body back
        rock.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
        
        self.gameScene!.worldViewPlayerProjectiles.append(rock)
        rock.physicsBody!.applyImpulse(CGVector(dx: forwardMomentum, dy: height))
    }
    
    func launchMeteorFromSky(range: CGFloat, velocity: CGFloat, heightBoost: CGFloat) {
        let meteor: PlayerMeteor = self.projectiles2.popLast() as! PlayerMeteor
        
        meteor.physicsBody!.velocity = CGVector()
        
        meteor.position = CGPoint(x: self.position.x + range, y: self.gameScene!.size.height + heightBoost)
        
        // Change the name back to default so it receives updates
        meteor.resetName()
        
        // Unhide it
        meteor.isHidden = false
        
        // Set physics body back
        meteor.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
        
        self.gameScene!.worldViewPlayerProjectiles.append(meteor)
        meteor.physicsBody!.applyImpulse(CGVector(dx: 3250, dy: -velocity))
    }
    
    func startHovering() {
        // Record what the current y velocity is so we can resume there when stopping
        self.verticalVelocityToReset = self.physicsBody!.velocity.dy
        
        // Start hovering
        self.isHovering = true
        
        // Record what our y position is
        self.hoveringVerticalPosition = self.position.y
    }
    
    func stopHovering() {
        // Reset y velocity to what it was before hovering
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: self.verticalVelocityToReset)
        self.isHovering = false
        self.autoHoverStop = false
        self.autoHoverStopCountdown = 0
    }
    
    func activateSkill(_ skill: CharacterSkillDetails) { // TODO anything with a cooldown should inheirit the code to set cooldown and start it
        switch skill.upgrade {
        case .Block:
            // The player isn't blocking and they have shields
            if skill.activeSkillCount > 0 {
                
                // Start blocking
                self.startBlocking()
            }
        case .Jump:
            if !self.isHovering {
                // If the player is jumping and they have additionalJumps, set a flag that this could be a double jump when deactivated. Ensure that each time a jump starts the double jump flag is cleared
                if self.isJumping && self.additionalJumps > 0 {
                    self.allowDoubleJump = true
                }
                
                // The player isn't active jumping
                if self.isActiveJumping == false {
                    self.jumpForce = CGFloat(skill.value) // 2 ScaleBuddy.sharedInstance.getGameScaleAmount(false)
                    
                    // Start jumping
                    self.startActiveJumping()
                }
            }
        case .Teleport:
            // If the player is jumping and they have additionalJumps, set a flag that this could be a double jump when deactivated. Ensure that each time a jump starts the double jump flag is cleared
            if self.isJumping && self.additionalJumps > 0 {
                self.allowDoubleJump = true
            }
            
            if !self.isJumping {
                self.startTeleport(CGFloat(skill.value) * ScaleBuddy.sharedInstance.getGameScaleAmount(false), fromDefaultPosition: true)
            }
        /*case .Fireball:
            
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            // 2 - Set up initial location of projectile
            let projectile: PlayerProjectile = PlayerProjectile(texture: GameTextures.sharedInstance.playerAtlas.textureNamed("fireball_000"))
            projectile.name = "playerProjectile"
            projectile.damage = Int(skill.value)
            projectile.position = CGPoint(x: self.position.x, y: self.position.y)
            projectile.xScale = -1.0 // flip on horz axis
            
            // Setup physics for projectile
            projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
            projectile.physicsBody!.isDynamic = true
            projectile.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
            projectile.physicsBody!.contactTestBitMask = GameScene.enemyCategory | GameScene.obstacleCategory
            projectile.physicsBody!.collisionBitMask = GameScene.enemyCategory | GameScene.obstacleCategory
            projectile.physicsBody!.usesPreciseCollisionDetection = OptimizerBuddy.sharedInstance.usePreciseCollisionDetection()
            projectile.physicsBody!.affectedByGravity = false
            
            // 5 - OK to add now - we've double checked position
            self.gameScene!.worldViewPlayerProjectiles.append(projectile)
            self.worldView!.addChild(projectile)
            projectile.physicsBody!.applyImpulse(CGVector(dx: 22.0, dy: 0.0))*/
        case .Charge:
            // Set the skill to cooldown // TODO move this into a function
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            // Make the player faster
            self.maxSpeed = self.maxSpeed * CGFloat(skill.value)
            self.damage = self.damage * Int(skill.secondaryValue)
            
            // Raging Strength Upgrade
            if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.RagingStrength) {
                self.projectileDamageReduction = 1000
            }
            
            skill.skillIsActive = true
            skill.activeLength = skill.maxActiveLength
            
            self.spriteOverlay!.isHidden = false
            
            self.playActionSound(action: self.actionSoundSkill3)
        case .Stomp:
            // Set the skill to cooldown // TODO move this into a function
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            // Add stomp animations
            // Create yellow for range
            rangeInd = SKSpriteNode(texture: nil, color: SKColor(red: 219/255.0, green: 14/255.0, blue: 14/255.0, alpha: 1.0), size: CGSize(width: skill.range * 2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), height: 2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            rangeInd!.position = CGPoint(x: self.position.x + rangeInd!.size.width / 6.0, y: self.defaultPositionY - self.size.height / 2)
            rangeInd!.zPosition = 3
            self.worldView!.addChild(rangeInd!)
            
            // Group actions to do in parallel
            self.actionGroup3 = SKAction.group([SKAction.moveTo(y: self.defaultPositionY - self.size.height / 2 - 5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
            rangeInd!.run(SKAction.sequence([SKAction.moveTo(y: self.defaultPositionY - self.size.height / 2 + 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), duration: 0.05), self.actionGroup3, SKAction.removeFromParent()]))
            
            // If there is a sec value, launch rocks
            if skill.secondaryValue == 1 {
                // Launch first rock
                self.launchRock(skill.secondaryRange * ScaleBuddy.sharedInstance.getGameScaleAmount(false), height: 9500, forwardMomentum: 1150)
            }
            if skill.secondaryValue == 2 {
                // Launch first rock
                self.launchRock(skill.secondaryRange * ScaleBuddy.sharedInstance.getGameScaleAmount(false), height: 10500, forwardMomentum: 1150)
                
                // Launch second rock
                self.launchRock(skill.secondaryRange * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + 50 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), height: 8500, forwardMomentum: 1400)
            }
            
            // Iterate through all enemies and deal damage to them if they are touching the ground
            for enemy in self.gameScene!.worldViewEnvironmentObjects {
                if enemy.type == EnvironmentObjectType.Enemy {
                    // The enemy is within the skill range and the enemy is not flying or floating (so they should be on the ground
                    let enemyWithinRange1 = enemy.position.x + enemy.size.width / 2 > rangeInd!.position.x - rangeInd!.size.width / 2
                    let enemyWithinRange2 = enemy.position.x - enemy.size.width / 2 < rangeInd!.position.x + rangeInd!.size.width / 2
                    if (enemyWithinRange1 && enemyWithinRange2) && !enemy.isFloating && !enemy.isFlying {
                        let multiplier: Double = 1
                        
                        // Deal the skill damage
                        enemy.takeDamage(Int(skill.value * multiplier))
                        
                        // If the enemy is still alive, send them into the sky
                        if enemy.health > 0 {
                            enemy.isFloating = true
                            enemy.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 3000 * CGFloat(multiplier)))
                        }
                    }
                }
            }
            
            self.playActionSound(action: self.actionSoundSkill4)
        case .ShootArrow:
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            self.attackCooldown = 0.0
        case .MagicMissle:
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            self.attackCooldown = 0.0
        case .KiWave:
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            self.attackCooldown = 0.0
        case .TimeFreeze:
            // Set the skill to cooldown // TODO move this into a function
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            // Animate skill used
            self.animateSkillUsed()
            
            // Now we loop through and freeze enemies in front of the player. 
            // Value Y = # enemies frozen
            var freezeTimes = skill.value
            // SecondaryValue X = # enemies killed instead of frozen
            var warpTimes = skill.secondaryValue
            
            var objectsToFreeze = Array<EnvironmentObject>()
            
            // Find all enemies on screen.
            // Iterate through all enemies to find someone close
            for object in self.gameScene!.worldViewEnvironmentObjects {
                if (object.type == EnvironmentObjectType.Enemy || object.type == EnvironmentObjectType.Projectile) && object.isAlive {
                    if object.position.x > self.position.x && abs(object.position.x - self.position.x) < self.gameScene!.size.width {
                        objectsToFreeze.append(object)
                    }
                }
            }
            
            // Sort them by distance
            objectsToFreeze.sort(isOrderedBefore: { (e1: EnvironmentObject, e2: EnvironmentObject) -> Bool in
                if e1.position.x < e2.position.x {
                    return true
                } else {
                    return false
                }
            })
            
            // Kill the first X, freeze the rest up to Y
            for object in objectsToFreeze {
                if warpTimes > 0 {
                    // Kill the object
                    object.freezeEnemy()
                    object.takeDamage(100)
                    
                    warpTimes -= 1
                    freezeTimes -= 1
                } else if freezeTimes > 0 {
                    // Freeze the object
                    object.freezeEnemy()
                    
                    freezeTimes -= 1
                }
            }
            
            self.playActionSound(action: self.actionSoundSkill4)
        case .ProtectorOfTheSky:
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            skill.previouslyCoolingDown = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            self.protectorOfTheSky!.stopPositionAdjustment = true
            
            self.protectorOfTheSky!.defaultYPosition = self.protectorOfTheSky!.position.y
            
            // If we have homing, let's find the enemy
            if skill.secondaryValue == 1 {
                var closestObject: EnvironmentObject?
                
                // Iterate through all enemies to find someone close
                for object in self.gameScene!.worldViewEnvironmentObjects {
                    if (object.type == EnvironmentObjectType.Enemy ||
                        object.type == EnvironmentObjectType.Obstacle) && object.isAlive {
                        let modifiedObjectPosition = (abs(object.position.x) - (100 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
                        if closestObject == nil {
                            if modifiedObjectPosition - abs(self.protectorOfTheSky!.position.x) > 0 && object.position.y > self.protectorOfTheSky!.minimumHeight {
                                closestObject = object
                            }
                        } else {
                            if modifiedObjectPosition - abs(self.protectorOfTheSky!.position.x) > 0 && abs(object.position.x) < abs(closestObject!.position.x) && object.position.y > self.protectorOfTheSky!.minimumHeight {
                                closestObject = object
                            }
                        }
                    }
                }
                
                // If we found something to attack, let's do it
                if closestObject != nil {
                    self.protectorOfTheSky!.homingObject = closestObject
                }
            }
            
            self.playActionSound(action: self.actionSoundSkill4)
        case .WalkWithShadows:
            if skill.chargeCount > 0 {
                skill.skillIsUncharging = true
                
                // Start hiding
                self.startHiding()
            }
        case .DiveBomb:
            // Can't have these skills going off
            self.gameScene!.getButtonWithSkill(CharacterUpgrade.Hover)!.forceDisabled = true
            self.gameScene!.getButtonWithSkill(CharacterUpgrade.Jump)!.forceDisabled = true
            
            // We need to interact with hover
            if self.isHovering {
                self.deactivateSkill(self.getSkill(CharacterUpgrade.Hover)!)
            }
            
            // Set the skill to cooldown // TODO move this into a function
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            // Active
            skill.skillIsActive = true
            skill.activeLength = 100
            
            // Start hiding
            self.startHiding()
            
            // Update the force field object's contact bit and unhide it
            self.damageField!.resetToHarmful()
            
            // Impulse down
            self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0)
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: CGFloat(-skill.value)))
            
            self.playActionSound(action: self.actionSoundSkill4)
        case .Hover:
            if !self.isOnGround {
                if skill.chargeCount > 0 {
                    skill.skillIsUncharging = true
                    
                    self.startHovering()
                    
                    self.spriteOverlay2!.isHidden = false
                    self.spriteOverlay2!.run(self.spriteOverlay2Action, withKey: "hover")
                }
            }
        case .KiShield:
            self.projectileDamageReduction = 10
            self.enemyDamageReduction = 10
            self.obstacleDamageReduction = 10
            
            // Images
            self.spriteOverlay!.isHidden = false
            
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            skill.skillIsActive = true
            skill.activeLength = skill.maxActiveLength
            
            // Reset damage avoided
            self.damageAvoided = 0
            
            self.playActionSound(action: self.actionSoundSkill5)
        case .ForceField:
            self.projectileDamageReduction = 10
            self.enemyDamageReduction = 10
            self.obstacleDamageReduction = 10
            
            // Images
            self.spriteOverlay!.isHidden = false
            
            // Set the skill to cooldown
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            skill.skillIsActive = true
            skill.activeLength = skill.maxActiveLength
            
            // Reset damage avoided
            self.damageAvoided = 0
            
            self.playActionSound(action: self.actionSoundSkill5)
        case .HealthPotion:
            // Set the skill to cooldown // TODO move this into a function
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            // Add health
            if self.health + Int(skill.secondaryValue) >= self.maxHealth {
                self.health = self.maxHealth
            } else {
                self.health = self.health + Int(skill.secondaryValue)
            }
            
            self.playActionSound(action: self.actionSoundSkill5)
        case .Meteor:
            // Set the skill to cooldown // TODO move this into a function
            skill.cooldownInProgress = true
            
            // This is how long until it can be used again
            skill.activeCooldownCount = skill.maxCooldownCount
            
            if skill.value >= 1 {
                self.launchMeteorFromSky(range: skill.range * ScaleBuddy.sharedInstance.getGameScaleAmount(false), velocity: CGFloat(skill.secondaryValue), heightBoost: 0)
            }
            if skill.value >= 2 {
                self.launchMeteorFromSky(range: (skill.range + 100) * ScaleBuddy.sharedInstance.getGameScaleAmount(false), velocity: CGFloat(skill.secondaryValue), heightBoost: 50 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            }
            if skill.value >= 3 {
                self.launchMeteorFromSky(range: (skill.range + 200) * ScaleBuddy.sharedInstance.getGameScaleAmount(false), velocity: CGFloat(skill.secondaryValue), heightBoost: 150 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            }
            
            self.playActionSound(action: self.actionSoundSkill3)
        default: break
        }
    }
    
    func deactivateSkill(_ skill: CharacterSkillDetails) {
        // Deactivate flags
        skill.skillIsActive = false
        
        switch skill.upgrade {
        case .Block:
            if self.isBlocking {
                // No longer blocking
                self.stopBlocking()
            }
        case .Teleport:
            // If we had a double jump allowed and the player is still jumping, do it
            if self.allowDoubleJump && self.isJumping && self.additionalJumps > 0 {
                self.stopHovering()
                self.allowDoubleJump = false
                self.additionalJumps -= 1
                self.startTeleport(CGFloat(skill.secondaryValue) * ScaleBuddy.sharedInstance.getGameScaleAmount(false), fromDefaultPosition: false)
            }
        case .Jump:
            if self.isActiveJumping {
                // No longer jumping
                self.stopActiveJumping()
            }
            
            // If we had a double jump allowed and the player is still jumping, do it
            if self.allowDoubleJump && self.isJumping && self.additionalJumps > 0 {
                self.allowDoubleJump = false
                self.additionalJumps -= 1
                self.startJumping(5000)// * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            }
        case .Charge:
            // Set the player back to how it was
            self.maxSpeed = self.maxSpeed / CGFloat(skill.value)
            self.damage = self.damage / Int(skill.secondaryValue)
            
            // Reset damage reduction
            self.projectileDamageReduction = 0
            
            self.spriteOverlay!.isHidden = true
        case .KiShield:
            self.projectileDamageReduction = 0
            self.enemyDamageReduction = 0
            self.obstacleDamageReduction = 0
            
            // Images
            self.spriteOverlay!.isHidden = true
            
            self.damageAvoided = 0
        case .ForceField:
            self.projectileDamageReduction = 0
            self.enemyDamageReduction = 0
            self.obstacleDamageReduction = 0
            
            // Images
            self.spriteOverlay!.isHidden = true
            
            // Add health for all the damage avoided - REMOVE *NERF*
            if self.damageAvoided > self.maxHealth - self.health {
                self.health = self.maxHealth
            } else {
                self.health += self.damageAvoided
            }
            
            self.damageAvoided = 0
        case .WalkWithShadows:
            if self.isHiding {
                skill.skillIsUncharging = false
                
                // Stop hiding
                self.stopHiding()
            }
        case .Hover:
            // Make sure the button is depressed
            self.gameScene!.getButtonWithSkill(CharacterUpgrade.Hover)!.releaseButton()
            
            if self.isHovering {
                skill.skillIsUncharging = false
                
                // Stop hovering
                self.stopHovering()
                
                self.spriteOverlay2!.isHidden = true
                self.spriteOverlay2!.removeAction(forKey: "hover")
            }
        case .DiveBomb:
            self.gameScene!.getButtonWithSkill(CharacterUpgrade.Hover)!.forceDisabled = false
            self.gameScene!.getButtonWithSkill(CharacterUpgrade.Jump)!.forceDisabled = false
            
            // If we have the impulse skill, create impulse and damage enemies
            if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.ShockWave) {
                // Add shock wave animations
                let rangeInd = SKSpriteNode(texture: nil, color: SKColor(red: 25/255.0, green: 14/255.0, blue: 200/255.0, alpha: 1.0), size: CGSize(width: skill.range*2, height: 3))
                rangeInd.position = CGPoint(x: self.position.x, y: self.defaultPositionY - self.size.height / 2)
                rangeInd.zPosition = 3
                self.worldView!.addChild(rangeInd)
                
                // Group actions to do in parallel
                self.actionGroup3 = SKAction.group([SKAction.moveTo(y: self.defaultPositionY - self.size.height / 2 - 5, duration: 0.25), SKAction.fadeOut(withDuration: 0.25)])
                rangeInd.run(SKAction.sequence([SKAction.moveTo(y: self.defaultPositionY - self.size.height / 2 + 10, duration: 0.05), self.actionGroup3, SKAction.removeFromParent()]))
                
                // Iterate through all enemies and deal damage to them if they are touching the ground
                for enemy in self.gameScene!.worldViewEnvironmentObjects {
                    if enemy.type == EnvironmentObjectType.Enemy {
                        // The enemy is within the skill range and the enemy is not flying or floating (so they should be on the ground
                        let enemyWithinRange1 = enemy.position.x + enemy.size.width / 2 > rangeInd.position.x - rangeInd.size.width / 2
                        let enemyWithinRange2 = enemy.position.x - enemy.size.width / 2 < rangeInd.position.x + rangeInd.size.width / 2
                        if (enemyWithinRange1 && enemyWithinRange2) && !enemy.isFloating && !enemy.isFlying {
                            let multiplier: Double = 1
                            
                            // Deal the skill damage
                            enemy.takeDamage(Int(skill.value * multiplier))
                            
                            // If the enemy is still alive, send them into the sky
                            if enemy.health > 0 {
                                enemy.isFloating = true
                                enemy.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 3000 * CGFloat(multiplier)))
                            }
                        }
                    }
                }
                
                // Iterate through all obstacles and deal damage to them if they are touching the ground
                for obstacle in self.gameScene!.worldViewEnvironmentObjects {
                    if obstacle.type == EnvironmentObjectType.Obstacle {
                        // The enemy is within the skill range and the enemy is not flying or floating (so they should be on the ground
                        let obstacleWithinRange1 = obstacle.position.x + obstacle.size.width / 2 > rangeInd.position.x - rangeInd.size.width / 2
                        let obstacleWithinRange2 = obstacle.position.x - obstacle.size.width / 2 < rangeInd.position.x + rangeInd.size.width / 2
                        if (obstacleWithinRange1 && obstacleWithinRange2) && !obstacle.isFloating && !obstacle.isFlying {
                            let multiplier: Double = 1
                            
                            // Deal the skill damage
                            obstacle.takeDamage(Int(skill.value * multiplier))
                        }
                    }
                }
            }
            
            // On the forcefield object, change the physics contact bit and hide it... then when we enable we just set the bit and unhide.
            self.damageField!.setToHarmless(true)
            
            // Stop hiding
            self.stopHiding()
        default: break
        }
    }
    
    func reactivateSkill(_ skill: CharacterSkillDetails) {
        switch skill.upgrade {
        case .ProtectorOfTheSky:
            self.protectorOfTheSky!.resetEagle()
        default: break
        }
    }
    
    func clearOutSound() {
        self.actionSoundSkill1 = SKAction()
        self.actionSoundSkill2 = SKAction()
        self.actionSoundSkill3 = SKAction()
        self.actionSoundSkill4 = SKAction()
        self.actionSoundSkill5 = SKAction()
        self.actionSoundHurt = SKAction()
        self.actionSoundContact = SKAction()
        self.actionSoundCollision = SKAction()
        self.actionSoundJumpedOnObject = SKAction()
    }
    
    func clearOutActions() {
        /*
        self.fightAction = SKAction()
        self.spriteOverlay2Action = SKAction()
         */
        
        
        /*
        // Group actions
        self.actionGroup1 = SKAction()
        self.actionGroup2 = SKAction()
        self.actionGroup3 = SKAction()
        self.actionGroup4 = SKAction()
 */
        
        self.redFlash.removeAllActions()
        self.blueFlash.removeAllActions()
        self.rangeInd?.removeAllActions()
        self.spriteOverlay2?.removeAllActions()
        self.weapon.removeAllActions()
    }
    
    func playActionSound(action: SKAction) {
        if GameData.sharedGameData.preferenceSoundEffects {
            SoundHelper.sharedInstance.playSoundAction(self, action: action)
        }
    }
}
