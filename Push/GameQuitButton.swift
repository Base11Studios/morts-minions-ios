//
//  GameEndLevel.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameQuitButton)
class GameQuitButton : DBButton {
    init(scene: GameScene) {
        super.init(iconName: "button_quit", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // We want the game scene to be able to be destroyed
        //self.removeFromParent()
        
        (self.dbScene as! GameScene).updateLevelDataWithoutScore()
        (self.dbScene as! GameScene).endSceneLevelSelect()
        //(self.dbScene as! GameScene).viewController!.presentLevelSelectionScene()
    }
}

