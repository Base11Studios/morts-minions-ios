//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CloudDataCloudButton)
class CloudDataCloudButton : DBButton {
    var alreadyPrompted: Bool = false
    
    init(scene: DBScene) {
        super.init(iconName: "button_cloud", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        if !alreadyPrompted && !self.forceDisabled {
            self.alreadyPrompted = true
            self.forceDisabled = true
            self.dbScene!.cloudDataDialog!.isHidden = true
            //self.hidden = true
            self.dbScene!.unpauseGame()
            self.dbScene!.reloadDataFromCloud()
        }
    }
}
