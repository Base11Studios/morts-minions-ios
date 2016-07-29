//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(SettingsSoundEffectsButton)
class SettingsSoundEffectsButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "soundeffectsempty", pressedIconName: "soundeffectsgold", buttonSize: DBButtonSize.square_Medium, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        self.pressedIcon?.setScale(1.4)
        self.unPressedIcon?.setScale(1.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        GameData.sharedGameData.preferenceSoundEffects = !GameData.sharedGameData.preferenceSoundEffects
        GameData.sharedGameData.save()
        
        // Set proper state
        if GameData.sharedGameData.preferenceSoundEffects {
            self.pressButton()
        } else {
            self.releaseButton()
        }
    }
    
    override func touchesReleasedAction() {
        // Set proper state
        if GameData.sharedGameData.preferenceSoundEffects {
            self.pressButton()
        } else {
            self.releaseButton()
        }
    }
}
