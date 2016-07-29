//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(SettingsMusicButton)
class SettingsMusicButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "musicempty", pressedIconName: "musicgold", buttonSize: DBButtonSize.square_Medium, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        self.pressedIcon?.setScale(1.4)
        self.unPressedIcon?.setScale(1.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        GameData.sharedGameData.preferenceMusic = !GameData.sharedGameData.preferenceMusic
        self.dbScene!.viewController!.playMusic(GameData.sharedGameData.preferenceMusic)
        GameData.sharedGameData.save()
        
        // Set proper state
        if GameData.sharedGameData.preferenceMusic {
            self.pressButton()
        } else {
            self.releaseButton()
        }
    }
    
    override func touchesReleasedAction() {
        // Set proper state
        if GameData.sharedGameData.preferenceMusic {
            self.pressButton()
        } else {
            self.releaseButton()
        }
    }
}
