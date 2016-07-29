//
//  GamePauseButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GamePauseButton)
class GamePauseButton : DBButton {
    init(scene: GameScene) {
        super.init(name: "pausebuttonreleased", pressedName: "pausebuttonpressed", dbScene: scene, atlas: GameTextures.sharedInstance.buttonGameAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.pauseGame()
    }
}
