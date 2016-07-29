//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameStorySkipButton)
class GameStorySkipButton : DBButton {
    var dialogNumber: Int
    var beginning: Bool
    
    init(dialogNumber: Int, scene: GameScene, beginning: Bool) {
        self.dialogNumber = dialogNumber
        self.beginning = beginning
        super.init(iconName: "button_next", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        if beginning {
            if dialogNumber < (self.dbScene as! GameScene).storyDialogs!.count - 1 {
                (self.dbScene as! GameScene).storyDialogs![dialogNumber].isHidden = true
                (self.dbScene as! GameScene).storyDialogs![dialogNumber + 1].isHidden = false
            } else {
                (self.dbScene as! GameScene).storyDialogs![dialogNumber].isHidden = true
                
                // Remove everything from the array
                for dialog in (self.dbScene as! GameScene).storyDialogs! {
                    // Mark that the player acknowledged it
                    GameData.sharedGameData.tutorialsAcknowledged[dialog.key] = dialog.version
                    
                    dialog.removeFromParent()
                }
                
                (self.dbScene as! GameScene).storyDialogs!.removeAll()
                
                (self.dbScene as! GameScene).displayPregamePops()
            }
        } else {
            if dialogNumber < (self.dbScene as! GameScene).storyEndDialogs!.count - 1 {
                (self.dbScene as! GameScene).storyEndDialogs![dialogNumber].isHidden = true
                (self.dbScene as! GameScene).storyEndDialogs![dialogNumber + 1].isHidden = false
            } else {
                (self.dbScene as! GameScene).storyEndDialogs![dialogNumber].isHidden = true
                
                // Remove everything from the array
                for dialog in (self.dbScene as! GameScene).storyEndDialogs! {
                    // Mark that the player acknowledged it
                    GameData.sharedGameData.tutorialsAcknowledged[dialog.key] = dialog.version
                    
                    dialog.removeFromParent()
                }
                
                (self.dbScene as! GameScene).storyEndDialogs!.removeAll()
                
                (self.dbScene as! GameScene).endLevel(0)
            }
        }
    }
}
