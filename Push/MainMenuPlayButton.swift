//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MainMenuPlayButton)
class MainMenuPlayButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_play", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // In case this was 0 gems and we didn't actually buy it, unlock it
        if !GameData.sharedGameData.getSelectedCharacterData().isCharacterUnlocked {
            // Unlock the character
            GameData.sharedGameData.getSelectedCharacterData().isCharacterUnlocked = true
            
            GameData.sharedGameData.save()
        }
        
        self.dbScene!.viewController!.presentLevelSelectionScene()
    }
}
