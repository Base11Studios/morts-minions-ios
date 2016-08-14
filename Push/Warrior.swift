//
//  Warrior.swift
//  Push
//
//  Created by Dan Bellinski on 10/13/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class Warrior : Player {
    // Skills
    override func initializeSkills() {
        self.skill1Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Jump)
        self.skill2Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Block)
        self.skill3Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Stomp)
        self.skill4Details = CharacterSkillDetails(upgrade: CharacterUpgrade.Charge)
        self.skill5Details = CharacterSkillDetails(upgrade: CharacterUpgrade.FirstAidKit)
        
        super.initializeSkills()

        // Create the rocks for stomp
        for i in 0 ..< Int(self.getSkill(CharacterUpgrade.Stomp)!.secondaryValue * 5) {
            // Create projectile
            let projectile: PlayerRock = PlayerRock(gameScene: self.gameScene!)
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
        super.init(atlas: GameTextures.sharedInstance.playerWarriorAtlas, textureArrayName: "warriorwalking", worldView: worldView, gameScene: gameScene)
        self.name = "warrior"
    }
    
    override func initSounds() {
        if GameData.sharedGameData.preferenceSoundEffects {
            self.actionSoundSkill1 = SKAction.playSoundFileNamed(SoundType.Jump.rawValue, waitForCompletion: false)
            //self.actionSoundSkill2 = SKAction.playSoundFileNamed(SoundType..rawValue, waitForCompletion: false)
            self.actionSoundSkill3 = SKAction.playSoundFileNamed(SoundType.Charge.rawValue, waitForCompletion: false)
            self.actionSoundSkill4 = SKAction.playSoundFileNamed(SoundType.Explode.rawValue, waitForCompletion: false)
            //self.actionSoundSkill5 = SKAction.playSoundFileNamed(SoundType..rawValue, waitForCompletion: false)
        }
        
        super.initSounds()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupTraits() {
        // Attacking
        self.maxAttackCooldown = 0.25
        self.attackCooldown = 0.0
        self.weaponStartPosition = CGPoint(x: 11, y: 2)
    }
    
    override func initializeWeapon() {
        // Add the weapon // TODO call self function that is specific to the class
        self.weapon = SKSpriteNode(texture: GameTextures.sharedInstance.playerWarriorAtlas.textureNamed("warriorswording_000"))
        self.addChild(self.weapon)
        self.weapon.position = self.weaponStartPosition
        
        // ** Create an action to attack **
        
        // At the end, switch back to walking and update the animation
        let actionEndAttack: SKAction = SKAction.run({
            self.isShooting = false
            
            // Start cooldown back over
            self.attackCooldown = self.maxAttackCooldown
            
            // Update the animations
            //[self updateAnimation]; TODO might need to change back to texture... or different animation
        })
        self.weaponFrames = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.playerWarriorAtlas, texturesNamed: "warriorswording", frameStart: 0, frameEnd: 15)
        
        // Set the appropriate fight action
        self.fightAction = SKAction.sequence([SKAction.animate(with: self.weaponFrames, timePerFrame: 0.025, resize: true, restore: false), actionEndAttack])
        
        // Charge overlay
        self.spriteOverlay = SKSpriteNode(texture: GameTextures.sharedInstance.playerWarriorAtlas.textureNamed("charge"))
        self.spriteOverlay!.zPosition = 9
        self.spriteOverlay!.position = CGPoint(x: self.size.width * 0.6, y: 0)
        self.spriteOverlay!.isHidden = true
        self.addChild(self.spriteOverlay!)
    }
    
    static func getDefaultSkills() -> NSMutableArray {
        let defaultUpgrades = NSMutableArray()
        
        defaultUpgrades.add(CharacterUpgrade.Jump.rawValue)
        
        return defaultUpgrades
    }
    
    override func createPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.712, height: self.size.height * 0.917), center: CGPoint(x: self.size.width * 0.0, y: self.size.height * -0.041))
    }
}
