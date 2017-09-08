//
//  CharacterBackButton.swift
//  Merp
//
//  Created by Dan Bellinski on 11/5/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(RateMeLaterButton)
class RateMeLaterButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_later", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        let title = "ClickedRateMeLATER"
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(title)" as NSObject,
            AnalyticsParameterItemName: title as NSObject,
            AnalyticsParameterContentType: "cont" as NSObject
            ])
        
        GameData.sharedGameData.promptRateMeCountdown = GameData.sharedGameData.promptRateMeMax
        //GameData.sharedGameData.save()
        dbScene!.hideRateMeMenu()
    }
}
