//
//  CharacterSkillInformation.swift
//  Merp
//
//  Created by Dan Bellinski on 11/11/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class CharacterSkillDetails {
    var upgrade: CharacterUpgrade
    
    // Type
    var type: UpgradeType = .None
    var targetSkill: CharacterUpgrade = .None
    
    // Icon
    var iconName: String?
    
    // Activation Method
    var activatesOnPress: Bool = false
    var activatesOnRelease: Bool = false
    
    // Skill counter
    var hasSkillCounter: Bool = false
    var skillCount: Int = 0
    var activeSkillCount: Int = 0
    var hasSkillCounterRegeneration: Bool = false
    var skillCountRegeneration: Double = 0
    var activeSkillCountRegeneration: Double = 0
    
    // Cooldown
    var hasCooldown: Bool = false
    var activeCooldownCount: Double = 0
    var maxCooldownCount: Double = 0
    var cooldownInProgress: Bool = false
    var previouslyCoolingDown: Bool = false
    
    // Length
    var hasActiveLength: Bool = false
    var skillIsActive: Bool = false
    var activeLength: Double = 0
    var maxActiveLength: Double = 0
    
    // Value
    var value: Double = 0
    var secondaryValue: Double = 0
    var tertiaryValue: Double = 0
    
    // Range
    var range: CGFloat = 0
    var secondaryRange: CGFloat = 0
    
    // Active
    var isDisabled: Bool = false
    
    // Charge
    var chargeCount: Double = 0
    var skillIsUncharging: Bool = false
    var hasChargeCounter: Bool = false
    var chargeRecoup: Double = 0
    var maxChargeCount: Double = 0
    
    // Resstrictions
    var restriction: CharacterRestriction = .None
    
    // Tutorial
    var tutorialText: String = ""
    var tutorialVersion: Double = 1.0
    
    // Deactivates
    var deactivatesOnGround: Bool = false
    var deactivatesOnObstacleContact: Bool = false
    var deactivatesOnProjectileContact: Bool = false
    var deactivatesOnEnemyContact: Bool = false
    
    init(upgrade: CharacterUpgrade) {
        self.upgrade = upgrade
        
        if self.upgrade != CharacterUpgrade.None {
            // Now we need to find the skill and set the appropriate information to use it
            // Create the path to the level
            let filePath: String = "upgrades_\(GameData.sharedGameData.selectedCharacter.rawValue)".lowercased()
            let path: String = Bundle.main.path(forResource: filePath, ofType: "plist")!
            
            // Read in the level
            let upgradeList = NSMutableArray(contentsOfFile: path) as! Array<Array<[String: AnyObject]>>
            
            // Loop through each entry in the dictionary
            for upgradeColumn in upgradeList {
                for upgrade in upgradeColumn {
                    // We need to find the right skill
                    if self.upgrade == CharacterUpgrade(rawValue: upgrade["Id"] as! String) {
                        // Activation method
                        if let method = upgrade["ActivationMethod"] as? String {
                            if (method == "press") {
                                self.activatesOnPress = true
                                self.activatesOnRelease = false
                            } else {
                                self.activatesOnPress = false
                                self.activatesOnRelease = true
                            }
                        }
                        
                        // Type information
                        self.type = UpgradeType(rawValue: upgrade["Type"] as! String)!
                        
                        if self.type == UpgradeType.Boost || self.type == UpgradeType.Enhancement {
                            self.targetSkill = CharacterUpgrade(rawValue: upgrade["TargetSkill"] as! String)!
                        }
                        
                        // If this is a skill, get tutorial info
                        if self.type == UpgradeType.Skill {
                            self.tutorialText = TextFormatter.formatText(upgrade["TutorialText"] as! String)
                            self.tutorialVersion = upgrade["TutorialVersion"] as! Double
                        }
                        
                        // Cooldown information
                        if let cooldown = upgrade["Cooldown"] as? Double {
                            self.hasCooldown = true
                            self.activeCooldownCount = 0
                            self.maxCooldownCount = cooldown
                            self.cooldownInProgress = false
                        }
                        
                        // Skill count information
                        if let skillCount = upgrade["SkillCount"] as? Int {
                            self.skillCount = skillCount
                            self.activeSkillCount = skillCount
                            self.hasSkillCounter = true
                        }
                        
                        if let skillCountRegeneration = upgrade["SkillCountRegeneration"] as? Double {
                            self.skillCountRegeneration = skillCountRegeneration
                            self.activeSkillCountRegeneration = skillCountRegeneration
                            self.hasSkillCounterRegeneration = true
                        }
                        
                        // Skill active information
                        if let activeLength = upgrade["ActiveLength"] as? Double {
                            self.activeLength = activeLength
                            self.maxActiveLength = activeLength
                            self.hasActiveLength = true
                        }
                        
                        // Skill value information
                        if let value = upgrade["Value"] as? Double {
                            self.value = value
                        }
                        
                        // Skill secondary value information
                        if let secondaryValue = upgrade["SecondaryValue"] as? Double {
                            self.secondaryValue = secondaryValue
                        }
                        
                        // Skill tertiary value information
                        if let tertiaryValue = upgrade["TertiaryValue"] as? Double {
                            self.tertiaryValue = tertiaryValue
                        }
                        
                        // Range information
                        if let range = upgrade["Range"] as? CGFloat {
                            self.range = range
                        }
                        
                        // Range information
                        if let secondaryRange = upgrade["SecondaryRange"] as? CGFloat {
                            self.secondaryRange = secondaryRange
                        }
                        
                        // Restriction information
                        if let restriction = upgrade["Restriction"] as? String {
                            self.restriction = CharacterRestriction(rawValue: restriction)!
                        }
                        
                        // Charge count information
                        if let chargeCount = upgrade["ChargeCount"] as? Double {
                            self.chargeCount = chargeCount
                            self.maxChargeCount = chargeCount
                            self.hasChargeCounter = true
                        }
                        
                        if let chargeRecoup = upgrade["ChargeRecoup"] as? Double {
                            self.chargeRecoup = chargeRecoup
                        }
                        
                        // Deactivation
                        if let deactivatesOnGround = upgrade["DeactivatesOnGround"] as? Bool {
                            if deactivatesOnGround == true {
                                self.deactivatesOnGround = true
                            }
                        }
                        if let deactivatesOnEnemyContact = upgrade["DeactivatesOnEnemyContact"] as? Bool {
                            if deactivatesOnEnemyContact == true {
                                self.deactivatesOnEnemyContact = true
                            }
                        }
                        if let deactivatesOnProjectileContact = upgrade["DeactivatesOnProjectileContact"] as? Bool {
                            if deactivatesOnProjectileContact == true {
                                self.deactivatesOnProjectileContact = true
                            }
                        }
                        if let deactivatesOnObstacleContact = upgrade["DeactivatesOnObstacleContact"] as? Bool {
                            if deactivatesOnObstacleContact == true {
                                self.deactivatesOnObstacleContact = true
                            }
                        }
                        
                        self.iconName = upgrade["IconName"] as? String
                    }
                }
            }
            
            // TODO - Now we need to loop through the list again and look for any upgrades that modify this skill
        }
    }
}
