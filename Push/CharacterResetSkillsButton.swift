//
//  CharacterResetSkillsButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/31/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterResetSkillsButton)
class CharacterResetSkillsButton : DBButton {
    init(scene: CharacterSkillScene) {
        super.init(iconName: "button_reset", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // TODO add prompt
        GameData.sharedGameData.getSelectedCharacterData().resetCharacterSkills()
        
        // Check to see if the skills should be visible now
        (dbScene as! CharacterSkillScene).scrollingNode!.setSkillNodeOpacity()
        
        // Update the skill info
        (dbScene as! CharacterSkillScene).reselectSkillNode()
    }
}
