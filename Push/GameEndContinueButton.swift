//
//  GameEndContinueButton.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/18/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class GameEndContinueButton : DBButton {
    init(scene: GameScene) {
        super.init(iconName: "button_okay", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        (self.dbScene as! GameScene).endOfLevelDialog!.showNextPage()
    }
}
