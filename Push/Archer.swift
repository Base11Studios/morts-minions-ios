//
//  Archer.swift
//  Push
//
//  Created by Dan Bellinski on 10/13/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Archer : Player {

    override func initializeSkills() {
        self.skill1Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Jump)
        self.skill2Details = CharacterSkillDetails(upgrade: CharacterUpgrade.ShootArrow)
        self.skill3Details = CharacterSkillDetails(upgrade: CharacterUpgrade.WalkWithShadows)
        self.skill4Details = CharacterSkillDetails(upgrade: CharacterUpgrade.ProtectorOfTheSky)
        self.skill5Details = CharacterSkillDetails(upgrade: CharacterUpgrade.HealthPotion)
        
        super.initializeSkills()
        
        // If the player has the eagle skill, create the eagle
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.ProtectorOfTheSky) {
            // Create the protector
            self.protectorOfTheSky = PlayerEagle(attachedSkill: self.getSkill(CharacterUpgrade.ProtectorOfTheSky)!, gameScene: self.gameScene!)
            self.protectorOfTheSky!.zPosition=1
            
            self.protectorXAdjust = -40 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            self.protectorYAdjust = CGFloat(50.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + CGFloat(self.getSkill(CharacterUpgrade.ProtectorOfTheSky)!.value) * ScaleBuddy.sharedInstance.getGameScaleAmount(false) / 2.0)
            
            self.worldView!.addChild(self.protectorOfTheSky!)
            self.gameScene!.worldViewPlayerProjectiles.append(self.protectorOfTheSky!)
        }
        
        self.name = "archer"
    }
    
    init(worldView: SKNode?, gameScene: GameScene) {
        super.init(atlas: GameTextures.sharedInstance.playerArcherAtlas, textureArrayName: "archerwalking", worldView: worldView, gameScene: gameScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        // Attacking
        self.maxAttackCooldown = 5000.0
        self.attackCooldown = 5000.0 // Set really high so it doesnt trigger on its own
        self.weaponStartPosition = CGPoint(x: 23, y: -5)
    }
    
    override func initializeWeapon() {
        // Add the weapon // TODO call self function that is specific to the class
        self.weapon = SKSpriteNode(texture: GameTextures.sharedInstance.playerArcherAtlas.textureNamed("archershooting_000"))
        self.addChild(self.weapon)
        self.weapon.position = self.weaponStartPosition
        
        // Create projectiles
        for i in 0 ..< (Int(self.getSkill(CharacterUpgrade.ShootArrow)!.value * (self.getSkill(CharacterUpgrade.ShootArrow)!.secondaryValue + 1)) * 5) {
            // Create projectile
            let projectile: PlayerArrow = PlayerArrow(gameScene: self.gameScene!)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.isHidden = true
            
            // Set up initial location of projectile
            projectile.position = CGPoint(x: self.position.x + self.weaponStartPosition.x, y: self.position.y + self.weaponStartPosition.y - 2.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            projectile.zPosition = 9
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.worldView!.addChild(projectile)
            
            self.projectiles.append(projectile)
        }
        
        // ** Create an action to attack **
        // At the end, create the projectile
        let actionCreateProjectile: SKAction = SKAction.run({
            
            for i in 0 ..< Int(self.getSkill(CharacterUpgrade.ShootArrow)!.value) {
                let arrow: PlayerArrow = self.projectiles.popLast() as! PlayerArrow
                
                arrow.position = CGPoint(x: self.position.x + self.weaponStartPosition.x, y: self.position.y + self.weaponStartPosition.y - 2.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                
                // Change the name back to default so it receives updates
                arrow.resetName()
                
                // Unhide it
                arrow.isHidden = false
                
                // Set physics body back
                arrow.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
                
                self.gameScene!.worldViewPlayerProjectiles.append(arrow)
                
                arrow.physicsBody!.applyImpulse(CGVector(dx: 8000.0, dy: 2000.0 * CGFloat(i)))
                
                self.playActionSound(action: self.actionSoundSkill2!)
            }
        })
        
        // At the end, switch back to walking and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            self.isShooting = false
            
            if self.getSkill(CharacterUpgrade.ShootArrow)!.secondaryValue > 0 && Int(self.getSkill(CharacterUpgrade.ShootArrow)!.secondaryValue) > self.attacksInSuccession {
                // Shoot again
                self.attackCooldown = 0
                self.attacksInSuccession += 1
            } else {
                // Start cooldown back over
                self.attackCooldown = self.maxAttackCooldown
                
                self.attacksInSuccession = 0
            }
            
            // Update the animations
            //[self updateAnimation]; TODO might need to change back to texture... or different animation
        })
        self.weaponFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.playerArcherAtlas, texturesNamed: "archershooting", frameStart: 0, frameEnd: 15)
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([SKAction.animate(with: self.weaponFrames, timePerFrame: 0.01, resize: true, restore: false), actionCreateProjectile, actionEndAttack])
    }
    
    override func initSounds() {
        if GameData.sharedGameData.preferenceSoundEffects {
            self.actionSoundSkill1 = SKAction.playSoundFileNamed(SoundType.Jump.rawValue, waitForCompletion: false)
            self.actionSoundSkill2 = SKAction.playSoundFileNamed(SoundType.ProjectileThrow.rawValue, waitForCompletion: false)
            //self.actionSoundSkill3 = SKAction.playSoundFileNamed(SoundType..rawValue, waitForCompletion: false)
            self.actionSoundSkill4 = SKAction.playSoundFileNamed(SoundType.Zoom.rawValue, waitForCompletion: false)
            self.actionSoundSkill5 = SKAction.playSoundFileNamed(SoundType.Drink.rawValue, waitForCompletion: false)
        }
        
        super.initSounds()
    }
    
    static func getDefaultSkills() -> NSMutableArray {
        let defaultUpgrades = NSMutableArray()
        
        defaultUpgrades.add(CharacterUpgrade.Jump.rawValue)
        
        return defaultUpgrades
    }
    
    override func setPlayerAttachmentPositions(_ defaultYPosition: CGFloat, position: CGPoint) {
        self.protectorOfTheSky?.position = CGPoint(x: self.position.x - 35 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), y: self.position.y + 50 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        self.protectorOfTheSky?.nextPosition = CGPoint(x: self.position.x - 35 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), y: self.position.y + 50 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        self.protectorOfTheSky?.defaultYPosition = defaultYPosition + self.protectorYAdjust
        
        self.protectorOfTheSky?.startingYPosition = defaultYPosition + self.protectorYAdjust
        
        self.protectorOfTheSky?.minimumHeight = defaultYPosition + self.protectorYAdjust - self.protectorOfTheSky!.size.height / 2
    }
    
    override func update(_ timeSinceLast: CFTimeInterval) {
        self.protectorOfTheSky?.nextPosition = CGPoint(x: self.position.x + (5 * sin(CGFloat(self.protectorOfTheSky!.timeAlive)*4)) * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + self.protectorXAdjust, y: self.position.y + (CGFloat(self.getSkill(CharacterUpgrade.ProtectorOfTheSky)!.value) * sin(CGFloat(self.protectorOfTheSky!.timeAlive)*4)) * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + self.protectorYAdjust)
        
        self.protectorOfTheSky?.update(timeSinceLast, withPlayer: self)
        
        super.update(timeSinceLast)
    }
    
    override func updateAfterPhysics() {
        super.updateAfterPhysics()
        
        self.protectorOfTheSky?.updateAfterPhysics()
    }
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.9, height: self.size.height * 1), center: CGPoint(x: self.size.width * 0.05, y: self.size.height * 0.0))
    }
}
