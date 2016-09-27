//
//  GameRestartLevelButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameRestartButton)
class GameRestartButton : DBButton {
    init() {
        super.init(dbScene: nil)
    }
    
    init(scene: GameScene?) {
        super.init(iconName: "button_restart", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        (self.dbScene as! GameScene).updateLevelDataWithoutScore()
        (self.dbScene as! GameScene).endSceneRetryLevel()
    }
}

