//
//  CharacterBackButton.swift
//  Merp
//
//  Created by Dan Bellinski on 11/5/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(RateMeRateButton)
class RateMeRateButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_rateme", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        let title = "ClickedRateMeNOW"
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "cont" as NSObject
            ])
        
        
        GameData.sharedGameData.playerHasRatedGame = true
        //GameData.sharedGameData.save()
        dbScene!.hideRateMeMenu()
        
        //appstore.com/morts-minions
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/us/app/morts-minions/id1082229199?ls=1&mt=8")!)
    }
}
