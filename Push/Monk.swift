//
//  Warrior.swift
//  Push
//
//  Created by Dan Bellinski on 10/13/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Monk : Player {
    // Skills
    override func initializeSkills() {
        self.skill1Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Jump)
        self.skill2Details = CharacterSkillDetails(upgrade: CharacterUpgrade.DiveBomb)
        self.skill3Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Hover)
        self.skill4Details = CharacterSkillDetails(upgrade: CharacterUpgrade.KiWave)
        self.skill5Details = CharacterSkillDetails(upgrade: CharacterUpgrade.KiShield)
        
        super.initializeSkills()
    }
    
    override init() {
        super.init()
    }
    
    init(worldView: SKNode?, gameScene: GameScene) {
        super.init(atlas: GameTextures.sharedInstance.playerMonkAtlas, textureArrayName: "monkwalking", worldView: worldView, gameScene: gameScene)
        self.name = "monk"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        // Attacking
        self.maxAttackCooldown = 5000.0
        self.attackCooldown = 5000.0 // Set really high so it doesnt trigger on its own
        self.weaponStartPosition = CGPoint(x: 12, y: -7)
    }
    
    override func initializeWeapon() {
        // Add the weapon // TODO call self function that is specific to the class
        self.weapon = SKSpriteNode(texture: GameTextures.sharedInstance.playerMonkAtlas.textureNamed("monkcasting_000"))
        self.addChild(self.weapon)
        self.weapon.position = self.weaponStartPosition
        
        // Create projectiles
        for _ in 0 ..< 5 {
            // Create projectile
            let projectile: PlayerShockwave = PlayerShockwave(gameScene: self.gameScene!)
            
            // Set scale - 3 is highest so we will make the wave that large and then scale down so we dont lose graphic quality
            projectile.setScale(CGFloat(self.getSkill(CharacterUpgrade.KiWave)!.value) / 3.0)
            
            // This is how far it can pass through
            projectile.numberOfContacts = Int(self.getSkill(CharacterUpgrade.KiWave)!.secondaryValue)
            
            // We dont want this to get updated by gamescene so change the name which is the selector
            projectile.name = "proj_dont_update"
            projectile.type = EnvironmentObjectType.Ignored
            projectile.isHidden = true
            
            // Set up initial location of projectile
            projectile.position = CGPoint(x: self.position.x + projectile.size.width / 2, y: self.position.y + 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + self.weaponStartPosition.y)
            
            projectile.zPosition = 9
            
            // Override
            projectile.physicsBody!.categoryBitMask = GameScene.harmlessObjectCategory
            
            self.worldView!.addChild(projectile)
            
            self.projectiles.append(projectile)
        }
        
        // ** Create an action to attack **
        // At the end, create the projectile
        let actionCreateProjectile: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                let arrow: PlayerShockwave = self?.projectiles.popLast() as! PlayerShockwave
                
                arrow.position = CGPoint(x: self!.position.x + arrow.size.width / 2, y: self!.position.y + 10 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + self!.weaponStartPosition.y)
                
                // Change the name back to default so it receives updates
                arrow.resetName()
                
                // Unhide it
                arrow.isHidden = false
                
                // Set physics body back
                arrow.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
                
                self?.gameScene!.worldViewPlayerProjectiles.append(arrow)
                
                arrow.physicsBody!.applyImpulse(CGVector(dx: 8000.0, dy: 0))
                
                self?.playActionSound(action: SoundHelper.sharedInstance.projectileThrow)
            }
            })
        
        // At the end, switch back to walking and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.isShooting = false
                
                // Start cooldown back over
                self?.attackCooldown = self!.maxAttackCooldown
                
                self?.attacksInSuccession = 0
                
                // Update the animations
                //[self updateAnimation]; TODO might need to change back to texture... or different animation
            }
            })
        
        
        self.weaponFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.playerMonkAtlas, texturesNamed: "monkcasting", frameStart: 0, frameEnd: 15)
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([SKAction.animate(with: self.weaponFrames, timePerFrame: 0.01, resize: true, restore: false), actionCreateProjectile, actionEndAttack])
        
        // Create damagefield
        self.damageField = PlayerDamageField(size: Int(self.skill2Details.secondaryValue), gameScene: self.gameScene!)
        
        self.damageField!.setToHarmless(false)
        self.damageField!.zPosition = 8
        self.worldView!.addChild(self.damageField!)
        self.gameScene!.worldViewPlayerProjectiles.append(self.damageField!)
        
        // Ki Shield overlay
        self.spriteOverlay = SKSpriteNode(texture: GameTextures.sharedInstance.playerMonkAtlas.textureNamed("kishield"))
        self.spriteOverlay!.zPosition = 9
        self.spriteOverlay!.isHidden = true
        self.addChild(self.spriteOverlay!)
        
        // Hover board overlay
        self.spriteOverlay2 = SKSpriteNode(texture: GameTextures.sharedInstance.playerMonkAtlas.textureNamed("hoverboard_000"))
        self.spriteOverlay2!.zPosition = 9
        let spriteOverlay2XPosition = CGFloat(0)
        let spriteOverlay2YPosition = (-self.spriteOverlay2!.size.height / 2) - (self.size.height / 2) + (3)
        self.spriteOverlay2!.position = CGPoint(x: spriteOverlay2XPosition, y: spriteOverlay2YPosition)
        self.spriteOverlay2!.isHidden = true
        self.spriteOverlay2Action = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.playerMonkAtlas, texturesNamed: "hoverboard", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false))
        
        self.addChild(self.spriteOverlay2!)
    }
    
    static func getDefaultSkills() -> NSMutableArray {
        let defaultUpgrades = NSMutableArray()
        
        defaultUpgrades.add(CharacterUpgrade.Jump.rawValue)
        
        return defaultUpgrades
    }
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.912, height: self.size.height * 0.98), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * -0.02))
    }
}
