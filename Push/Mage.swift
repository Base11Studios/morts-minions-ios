//
//  Warrior.swift
//  Push
//
//  Created by Dan Bellinski on 10/13/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Mage : Player {
    // Skills
    override func initializeSkills() {
        self.skill1Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Teleport)
        self.skill2Details = CharacterSkillDetails(upgrade: CharacterUpgrade.MagicMissle)
        self.skill3Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Meteor)
        self.skill4Details = CharacterSkillDetails(upgrade: CharacterUpgrade.TimeFreeze)
        self.skill5Details = CharacterSkillDetails(upgrade: CharacterUpgrade.ForceField)
        
        super.initializeSkills()
        
        self.maxAutoHoverStopCountdown = self.getSkill(CharacterUpgrade.Teleport)!.tertiaryValue
        
        // Create the meteors
        for i in 0 ..< Int(self.getSkill(CharacterUpgrade.Meteor)!.value * 5) {
            // Create projectile
            let projectile: PlayerMeteor = PlayerMeteor(gameScene: self.gameScene!, groundCollision: GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(CharacterUpgrade.MeteorBlast))
            projectile.physicsBody!.velocity = CGVector()
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.isHidden = true
            
            // Set up initial location of projectile
            projectile.position = CGPoint(x: self.position.x + self.weaponStartPosition.x, y: self.position.y + self.weaponStartPosition.y - 2.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            projectile.zPosition = 4
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.worldView!.addChild(projectile)
            self.projectiles2.append(projectile)
        }
    }
    
    init(worldView: SKNode?, gameScene: GameScene) {
        super.init(atlas: GameTextures.sharedInstance.playerMageAtlas, textureArrayName: "magewalking", worldView: worldView, gameScene: gameScene)
        self.name = "mage"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        // Attacking
        self.maxAttackCooldown = 5000.0
        self.attackCooldown = 5000.0 // Set really high so it doesnt trigger on its own
        self.weaponStartPosition = CGPoint(x: 15, y: -5)
    }
    
    override func initializeWeapon() {
        // Add the weapon // TODO call self function that is specific to the class
        self.weapon = SKSpriteNode(texture: GameTextures.sharedInstance.playerMageAtlas.textureNamed("magestaffing_000"))
        self.addChild(self.weapon)
        self.weapon.position = self.weaponStartPosition
        
        // Create projectiles
        for i in 0 ..< Int((self.getSkill(CharacterUpgrade.MagicMissle)!.secondaryValue + 1) * 5) {
            // Create projectile
            let projectile: PlayerMagicMissle = PlayerMagicMissle(gameScene: self.gameScene!, range: self.getSkill(CharacterUpgrade.MagicMissle)!.range * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            projectile.damage = Int(self.getSkill(CharacterUpgrade.MagicMissle)!.value)
            
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
            let arrow: PlayerMagicMissle = self.projectiles.popLast() as! PlayerMagicMissle
            
            arrow.position = CGPoint(x: self.position.x + self.weaponStartPosition.x, y: self.position.y + self.weaponStartPosition.y - 2.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            // Change the name back to default so it receives updates
            arrow.resetName()
            
            // Unhide it
            arrow.isHidden = false
            
            // Set physics body back
            arrow.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
            
            self.gameScene!.worldViewPlayerProjectiles.append(arrow)
            
            arrow.physicsBody!.applyImpulse(CGVector(dx: 8000.0, dy: 0))
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.ProjectileThrow)
        })
        
        // At the end, switch back to walking and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            self.isShooting = false
            
            if self.getSkill(CharacterUpgrade.MagicMissle)!.secondaryValue > 0 && Int(self.getSkill(CharacterUpgrade.MagicMissle)!.secondaryValue) > self.attacksInSuccession {
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
        self.weaponFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.playerMageAtlas, texturesNamed: "magestaffing", frameStart: 0, frameEnd: 15)
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([SKAction.animate(with: self.weaponFrames, timePerFrame: 0.02, resize: true, restore: false), actionCreateProjectile, actionEndAttack])
        
        // Force Field overlay
        self.spriteOverlay = SKSpriteNode(texture: GameTextures.sharedInstance.playerMageAtlas.textureNamed("forcefield"))
        self.spriteOverlay!.zPosition = 9
        self.spriteOverlay!.isHidden = true
        self.addChild(self.spriteOverlay!)
    }
    
    static func getDefaultSkills() -> NSMutableArray {
        let defaultUpgrades = NSMutableArray()
        
        defaultUpgrades.add(CharacterUpgrade.Teleport.rawValue)
        
        return defaultUpgrades
    }
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.712, height: self.size.height * 0.917), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * -0.041))
    }
}
