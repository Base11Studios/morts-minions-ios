//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(SceneTutorialTooltipOkButton)
class SceneTutorialTooltipOkButton : DBButton {
    weak var container: SKNode?
    var key: String
    var version: Double

    // Callbacks
    var onComplete: ()-> Void = {}

    init(scene: DBScene, container: SKNode, key: String, version: Double, onComplete: @escaping ()->Void) {
        self.onComplete = onComplete
        self.container = container
        self.key = key
        self.version = version
        
        super.init(iconName: "button_okay", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // Mark that the player acknowledged it
        GameData.sharedGameData.tutorialsAcknowledged[key] = version
        
        // Get rid of it
        self.isHidden = true
        self.container!.removeFromParent()
        self.onComplete()
    }
}
