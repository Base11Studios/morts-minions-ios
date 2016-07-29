//
//  GameQuitButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameMenuButton)
class GameMenuButton : DBButton {
    init(scene: GameScene) {
        super.init(iconName: "button_menu", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // End the scene
        (self.dbScene as! GameScene).endSceneLevelSelect()
    }
}

