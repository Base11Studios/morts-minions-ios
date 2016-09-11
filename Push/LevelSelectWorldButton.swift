//
//  LevelSelectWorldButton.swift
//  Merp
//
//  Created by Dan Bellinski on 12/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(LevelSelectWorldButton)
class LevelSelectWorldButton : DBButton {
    init(scene: LevelSelectionScene, iconName: String, worldNumber: Int) {
        super.init(buttonName: iconName, labelText: "\(worldNumber)", fontSize: 32 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), dbScene: scene, atlas: GameTextures.sharedInstance.buttonMenuAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // Set the newly touched node as the selected one
        (self.dbScene as! LevelSelectionScene).switchSelectedWorld(worldNameToSelect: (self.parent as! WorldNode).worldName, initialLoad: false)
    }
}
