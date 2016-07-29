//
//  GameChallengeOkButton.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/17/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameChallengeOkButton)
class GameChallengeOkButton : DBButton {
    init(scene: DBScene) {
        super.init(iconName: "button_okay", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        (self.dbScene as! GameScene).challengeDialog!.isHidden = true
        (self.dbScene as! GameScene).challengeDialog!.removeFromParent()
        
        (self.dbScene as! GameScene).displayTutorialTooltip()
    }
}
