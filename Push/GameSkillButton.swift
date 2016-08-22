//
//  GameSkillButton.swift
//  Merp
//
//  Created by Dan Bellinski on 11/11/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameSkillButton)
class GameSkillButton : DBButton {
    weak var upgradeDetails: CharacterSkillDetails?
    
    init(scene: GameScene, upgrade: CharacterSkillDetails) {
        self.upgradeDetails = upgrade
        
        var labelText: String? = nil
        
        if upgrade.hasSkillCounter {
            labelText = "\(upgrade.activeSkillCount)"
        } else if upgrade.hasChargeCounter {
            //labelText = "\(upgrade.chargeCount)"
            labelText = String(format: "%.2f", upgrade.chargeCount)
        }
        
        super.init(iconName: upgrade.iconName, labelText: labelText, fontSize: round(48 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)), dbScene: scene, backgroundAtlas: GameTextures.sharedInstance.buttonGameAtlas, iconAtlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.upgradeDetails!.isDisabled {
            super.touchesBegan(touches, with: event)
        }
        
        // Press button
        if self.upgradeDetails!.activatesOnRelease && !self.isDisabled && !self.upgradeDetails!.isDisabled {
            self.releaseButton()
            touchesEndedAction()
            self.checkDisabled()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Allow anywhere on screen
        if self.allowAnywhereOnScreen {
            self.allowAnywhereOnScreen = false
        }
        
        // Press button
        if (self.upgradeDetails!.activatesOnPress && self.isPressed && !self.isDisabled && !self.upgradeDetails!.isDisabled) {
            self.releaseButton()
            touchesEndedAction()
            self.checkDisabled()
        }
    }
    
    override func touchesBeganAction() {
        if self.upgradeDetails!.activatesOnPress {
            (self.dbScene as! GameScene).player!.activateSkill(self.upgradeDetails!)
        }
    }
    
    override func touchesReleasedAction() {
        if self.upgradeDetails!.activatesOnPress {
            (self.dbScene as! GameScene).player!.deactivateSkill(self.upgradeDetails!)
        }
    }
    
    override func touchesEndedAction() {
        // If this is a release skill, activate the skill
        if !self.upgradeDetails!.cooldownInProgress && self.upgradeDetails!.activatesOnRelease {
            (self.dbScene as! GameScene).player!.activateSkill(self.upgradeDetails!)
            
            // Create a cooldown animation on the button
            self.createCooldownButtonForCooldown()
            
            // Disable the button
            self.isDisabled = true
        }
        
        // If this is a press skill, deactivate it
        if self.upgradeDetails!.activatesOnPress {
            (self.dbScene as! GameScene).player!.deactivateSkill(self.upgradeDetails!)
        }
    }
    
    func createCooldownButtonForCooldown() {
        self.createCooldownButton(self.upgradeDetails!.maxCooldownCount)
    }
    
    func createCooldownButtonForCountRegeneration() {
        self.createCooldownButton(self.upgradeDetails!.activeSkillCountRegeneration)
    }
    
    func createCooldownButton(_ time: Double) {
        // Create a cooldown animation on the button
        let cooldownButton = GameCooldownButton(atlasName: "guibuttons", texturesNamed: "buttoncooldown", frameStart: 0, frameEnd: 15, scene: self.dbScene!)
        
        // Set appropriate attributes
        cooldownButton.runAnimation(time)
        
        self.addChild(cooldownButton)
    }
    
    func update(_ player: Player, timeSinceLast: CFTimeInterval) {
        if self.upgradeDetails!.hasSkillCounter {
            self.unPressedLabel?.setText("\(self.upgradeDetails!.activeSkillCount)")
            self.pressedLabel?.setText("\(self.upgradeDetails!.activeSkillCount)")
        } else if self.upgradeDetails!.hasChargeCounter {
            if self.upgradeDetails!.chargeCount > 0 {
                self.unPressedLabel?.setText(String(format: "%.2f", self.upgradeDetails!.chargeCount))
                self.pressedLabel?.setText(String(format: "%.2f", self.upgradeDetails!.chargeCount))
            } else {
                self.unPressedLabel?.setText("0.0")
                self.pressedLabel?.setText("0.0")
            }
        }
        
        // Start out with the button not disabled and find all scenarios we may disable it
        self.isDisabled = false
        
        // We need to release the button if they ran out of skill counts
        if self.upgradeDetails?.hasSkillCounter == true && self.upgradeDetails?.activeSkillCount == 0 && self.isPressed {
            // Stop the button from being pressed
            self.releaseButton()
            
            // Create a cooldown animation on the button
            self.createCooldownButtonForCountRegeneration()
            
            self.isDisabled = true
        }
        
        // We need to release the button if they ran out of charge counts
        if self.upgradeDetails?.hasChargeCounter == true && self.upgradeDetails?.chargeCount <= 0 {
            // Stop the button from being pressed
            self.releaseButton()
            
            self.isDisabled = true
        }
        
        // If this has regen, increment the counter. If we have reached the regen time, add a count and reset the counter. If the count was 0 and is now 1, enable the button again (take off disable)
        //var enableButton = false
        if self.upgradeDetails!.hasSkillCounterRegeneration {
            if self.upgradeDetails!.activeSkillCount < self.upgradeDetails!.skillCount {
                self.upgradeDetails!.activeSkillCountRegeneration -= timeSinceLast
            } else {
                self.upgradeDetails!.activeSkillCountRegeneration = self.upgradeDetails!.skillCountRegeneration
            }
            
            if self.upgradeDetails!.activeSkillCountRegeneration <= 0 {
                self.upgradeDetails!.activeSkillCountRegeneration = self.upgradeDetails!.skillCountRegeneration
                self.upgradeDetails!.activeSkillCount += 1
            }
            
            // Now check for button disabled - we don't have any skill count
            if self.upgradeDetails!.activeSkillCount == 0 {
                self.isDisabled = true
            }
        } else if self.upgradeDetails!.cooldownInProgress {
            self.upgradeDetails!.activeCooldownCount -= timeSinceLast
            
            if self.upgradeDetails!.activeCooldownCount <= 0 {
                self.upgradeDetails!.activeCooldownCount = self.upgradeDetails!.maxCooldownCount
                
                self.upgradeDetails!.cooldownInProgress = false
            } else { // We're still cooling down
                self.isDisabled = true
            }
        }
        
        // If the skill is disabled, another reason to not enable it
        if self.upgradeDetails!.isDisabled {
            self.isDisabled = true
        }
        
        // Check if this is disabled now
        self.checkDisabled()
    }
}



/// Skill buttons can have a var for the characterugrade they are attached to,
// if the skill is a hold, do certain things on the touchesbegan, if release, do touches ended... etc. If it has a cooldown, activate it when needed. If it has a counter, display it and use block logic to put it above. Disable the button if it has a counter and the counter is 0
