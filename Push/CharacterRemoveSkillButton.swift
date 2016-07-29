//
//  CharactePurchaseSkillButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterRemoveSkillButton)
class CharacterRemoveSkillButton : DBButton {
    init(scene: CharacterSkillScene) {
        super.init(iconName: "button_remove", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        
        self.isDisabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // Add the skill cost back
        switch (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCurrency {
        case .Stars:
            GameData.sharedGameData.getSelectedCharacterData().spentStars -= (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCost
        case .Citrine:
            GameData.sharedGameData.getSelectedCharacterData().spentCitrine -= (dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillCost
        }
        
        // Remove the skill
        GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.remove((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillId.rawValue)
        
        // Check to see if the skills should be visible now
        (dbScene as! CharacterSkillScene).scrollingNode!.setSkillNodeOpacity()
        
        // Update the skill info
        (dbScene as! CharacterSkillScene).reselectSkillNode()
    }
    
    override func checkDisabled() {
        if !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillId) {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
        
        // They do not have a child
        var childPurchased: Bool
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.childSkillId) {
            childPurchased = true
        } else {
            childPurchased = false
        }
        
        // If we have the child or if this is the default skill
        if childPurchased || GameData.sharedGameData.getSelectedCharacterData().defaultUpgrades.contains((dbScene as! CharacterSkillScene).scrollingNode!.selectedSkillNode!.skillId.rawValue)
        {
            self.isDisabled = true
        } else {
            self.isDisabled = false
        }
        
        super.checkDisabled()
    }
}
