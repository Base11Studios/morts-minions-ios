//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(HeartBoostCloseButton)
class HeartBoostCloseButton : DBButton {
    init(scene: GameScene) {
        super.init(iconName: "button_play", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        (self.dbScene as! GameScene).heartBoostDialog!.isHidden = true
        (self.dbScene as! GameScene).displayPregamePops()
    }
}
