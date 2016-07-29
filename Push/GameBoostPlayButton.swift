//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameBoostPlayButton)
class GameBoostPlayButton : DBButton {
    init(scene: GameScene) {
        super.init(iconName: "button_play", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        /*
        var selectedHearts: Int = 0
        var heartCost: Int = 0
        
        if (scene as! GameScene).heartBoostDialog!.heartBoost!.selectedHeartBoost != nil {
            selectedHearts = (scene as! GameScene).heartBoostDialog!.heartBoost!.selectedHeartBoost!.heartBoost
            heartCost = (scene as! GameScene).heartBoostDialog!.heartBoost!.selectedHeartBoost!.boostCost
        }
        
        if selectedHearts > 0 {
            // Take away gems from player
            GameData.sharedGameData.totalDiamonds -= heartCost
        }
        
        // Boost the level hearts - still send if 0 so we set the proper lastHeartBoost attr
        (self.dbScene as! GameScene).addHeartsToPlayer(selectedHearts)
        
        (self.dbScene as! GameScene).endHeartBoostDialog()
         */
    }
}
