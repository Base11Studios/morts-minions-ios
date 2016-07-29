//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MainMenuStoreButton)
class MainMenuStoreButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_store", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.showPurchaseMenu(false, itemCost: 0, onSuccess: {_ in }, onFailure: {}) // TODO REJUV
    }
}
