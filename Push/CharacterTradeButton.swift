//
//  CharacterTradeButton.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 10/6/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterTradeButton)
class CharacterTradeButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_trade", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.showTradeMenu()
    }
}
