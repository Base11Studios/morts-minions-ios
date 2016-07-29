//
//  LevelSelectPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(LevelSelectBackButton)
class LevelSelectBackButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_menu", pressedIconName: nil, buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.viewController!.presentMainMenuScene()
    }
}
