//
//  CharactePurchaseSkillButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterPurchaseSkillButton)
class CharacterPurchaseSkillButton : DBButton {
    var errorText: String? = nil
    
    init(scene: CharacterSkillScene) {
        super.init(iconName: "button_buy", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // Purchase the skill
        GameData.sharedGameData.getSelectedCharacterData().purchaseUpgrade((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCurrency, cost: (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCost, id: (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillId)
        
        // Check to see if the skills should be visible now
        (dbScene as! CharacterSkillScene).scrollingNode!.setSkillNodeOpacity()
        
        // Update the skill info
        (dbScene as! CharacterSkillScene).reselectSkillNode()
    }
    
    override func checkDisabled() {
        // If the skill is purchased already, use remove button
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillId) {
            self.isHidden = true
            self.errorText = nil
        } else {
            self.isHidden = false
        
            // If they have enough skill points to purchase the skill
            var enoughSkillPoints: Bool
            var skillPoints: Int
            var usingStars: Bool = true
            
            // Get the right skill currency
            switch (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCurrency {
            case .Stars:
                skillPoints = GameData.sharedGameData.getSelectedCharacterData().unspentStars
            case .Citrine:
                skillPoints = GameData.sharedGameData.getSelectedCharacterData().unspentCitrine
                usingStars = false
            }
            
            if skillPoints >= (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCost {
                enoughSkillPoints = true
            } else {
                enoughSkillPoints = false
                
                let difference = (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCost - skillPoints
                
                if usingStars {
                    self.errorText = "* need \(difference) more star"
                } else {
                    self.errorText = "* need \(difference) more superstar"
                }
                
                if difference > 1 {
                    self.errorText = self.errorText! + "s"
                }
            }

            // They do not have a parent, or they have the parent skill
            var parentPurchased: Bool
            if (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillParentId == .None || GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillParentId) {
                parentPurchased = true
            } else {
                parentPurchased = false
                self.errorText = "* buy the previous upgrade"
            }
            
            if !enoughSkillPoints || !parentPurchased
            {
                self.isDisabled = true
            } else {
                self.isDisabled = false
                self.errorText = nil
            }
            
            super.checkDisabled()
        }
    }
    
    /*
    // If they have enough skill points to purchase the skill
    var enoughSkillPoints: Bool
    var skillPoints: Int
    
    // Get the right skill currency
    switch (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCurrency {
    case .Stars:
    skillPoints = GameData.sharedGameData.getSelectedCharacterData().unspentStars
    case .Citrine:
    skillPoints = GameData.sharedGameData.getSelectedCharacterData().unspentCitrine
    }
    
    if skillPoints >= (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCost {
    enoughSkillPoints = true
    } else {
    enoughSkillPoints = false
    }
    
    // They dont already have the skill
    var skillNotAlreadyPurchased: Bool
    if !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillId) {
    skillNotAlreadyPurchased = true
    } else {
    skillNotAlreadyPurchased = false
    }
    
    // They do not have a parent, or they have the parent skill
    var parentPurchased: Bool
    if (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillParentId == .None || GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillParentId) {
    parentPurchased = true
    } else {
    parentPurchased = false
    }
    
    if !enoughSkillPoints || !skillNotAlreadyPurchased || !parentPurchased
    {
    self.isDisabled = true
    } else {
    self.isDisabled = false
    }
    
    super.checkDisabled()*/
}
