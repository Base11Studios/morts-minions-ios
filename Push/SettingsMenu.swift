//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class SettingsMenu: DialogBackground {
    var soundEffectsButton: SettingsSoundEffectsButton
    var musicButton: SettingsMusicButton
    var backButton: SettingsBackButton
    
    init(frameSize : CGSize, scene: DBScene) {
        // Create the buttons
        self.soundEffectsButton = SettingsSoundEffectsButton(scene: scene)
        self.musicButton = SettingsMusicButton(scene: scene)
        self.backButton = SettingsBackButton(scene: scene)
        
        super.init(frameSize: frameSize)
        
        let totalHeight = self.soundEffectsButton.size.height + self.backButton.size.height + self.buttonBuffer
        let totalWidth = self.soundEffectsButton.size.width + self.musicButton.size.width + self.buttonBuffer
        
        self.soundEffectsButton.position = CGPoint(x: -self.soundEffectsButton.size.width / 2 - self.buttonBuffer / 2, y: totalHeight / 2 - self.soundEffectsButton.size.height / 2)
        
        self.musicButton.position = CGPoint(x: self.musicButton.size.width / 2 + self.buttonBuffer / 2, y: totalHeight / 2 - self.soundEffectsButton.size.height / 2)
        
        self.backButton.position = CGPoint(x: totalWidth / 2 - self.backButton.size.width / 2, y: -totalHeight / 2 + self.backButton.size.height / 2)
        
        self.setButtonStates()
        
        self.container.addChild(self.soundEffectsButton)
        self.container.addChild(self.musicButton)
        self.container.addChild(self.backButton)
        
        // Reset the container size
        self.resetContainerSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonStates() {
        // Set proper state
        if GameData.sharedGameData.preferenceMusic {
            self.musicButton.pressButton()
        } else {
            self.musicButton.releaseButton()
        }
        
        // Set proper state
        if GameData.sharedGameData.preferenceSoundEffects {
            self.soundEffectsButton.pressButton()
        } else {
            self.soundEffectsButton.releaseButton()
        }
    }
}
