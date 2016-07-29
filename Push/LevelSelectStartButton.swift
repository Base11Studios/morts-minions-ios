//
//  LevelSelectPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(LevelSelectStartButton)
class LevelSelectStartButton : DBButton {
    init(scene: LevelSelectionScene) {
        super.init(iconName: "button_start", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        if !(self.dbScene as! LevelSelectionScene).selectedWorld!.relatedLevelSelector!.levelSelectedNode!.levelLocked {
            // Capture the level selected
            (self.dbScene as! LevelSelectionScene).levelSelected = Int((self.dbScene as! LevelSelectionScene).selectedWorld!.relatedLevelSelector!.levelSelected) // TODO remove casting after swift
            
            // Start the game
            (self.dbScene as! LevelSelectionScene).viewController!.presentGameSceneLevel((self.dbScene as! LevelSelectionScene).selectedWorld!.relatedLevelSelector!.levelSelected, justRestarted: false)
        }
    }
}
