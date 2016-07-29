//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameTutorialNextButton)
class GameTutorialNextButton : DBButton {
    var dialogNumber: Int
    
    init(dialogNumber: Int, scene: GameScene) {
        self.dialogNumber = dialogNumber
        
        super.init(iconName: "button_next", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        (self.dbScene as! GameScene).tutorialDialogs![dialogNumber].isHidden = true
        (self.dbScene as! GameScene).tutorialDialogs![dialogNumber + 1].isHidden = false
    }
}
