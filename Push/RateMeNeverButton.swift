//
//  CharacterBackButton.swift
//  Merp
//
//  Created by Dan Bellinski on 11/5/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(RateMeNeverButton)
class RateMeNeverButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_never", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        GameData.sharedGameData.playerHasRatedGame = true
        //GameData.sharedGameData.save()
        dbScene!.hideRateMeMenu()
    }
}
