//
//  CharacterBackButton.swift
//  Merp
//
//  Created by Dan Bellinski on 11/5/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(RateMeRateButton)
class RateMeRateButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_rateme", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        GameData.sharedGameData.playerHasRatedGame = true
        //GameData.sharedGameData.save()
        dbScene!.hideRateMeMenu()
        UIApplication.shared().openURL(URL(string: "itms-apps://itunes.apple.com/app/idcom.base11studios.morts-minions")!)
    }
}
