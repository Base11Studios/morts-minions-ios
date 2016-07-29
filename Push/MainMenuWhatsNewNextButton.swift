//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MainMenuWhatsNewNextButton)
class MainMenuWhatsNewNextButton : DBButton {
    var dialogNumber: Int
    
    init(dialogNumber: Int, scene: DBScene) {
        self.dialogNumber = dialogNumber
        
        super.init(iconName: "button_next", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        (self.dbScene as! MainMenuScene).tutorialDialogs![dialogNumber].isHidden = true
        (self.dbScene as! MainMenuScene).tutorialDialogs![dialogNumber + 1].isHidden = false
    }
}
