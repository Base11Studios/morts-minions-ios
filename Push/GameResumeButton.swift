//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameResumeButton)
class GameResumeButton : DBButton {
    init() {
        super.init(dbScene: nil)
    }
    
    init(scene: DBScene?) {
        super.init(iconName: "button_resume", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.unpauseGame()
    }
}
