//
//  MainMenuGamecenterButton.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/11/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MainMenuCreditsButton)
class MainMenuCreditsButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "question", pressedIconName: nil, buttonSize: DBButtonSize.flag, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.displayCredits()
    }
}
