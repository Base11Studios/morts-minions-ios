//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(GameTutorialStoreButton)
class GameTutorialStoreButton : DBButton {
    var dialogNumber: Int
    
    init(dialogNumber: Int, scene: GameScene) {
        self.dialogNumber = dialogNumber
        
        super.init(iconName: "button_store", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        let title = "ClickedToGoToPurchaseMenuInHouseAds"
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "cont" as NSObject
            ])
        
        self.dbScene!.showPurchaseMenu(false, itemCost: 0, onSuccess: {_ in }, onFailure: {})
    }
}
