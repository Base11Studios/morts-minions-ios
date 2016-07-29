//
//  GameResumeButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CloudDataLocalButton)
class CloudDataLocalButton : DBButton {
    weak var dialog: CloudDataDialog?
    var confirmLocal: Bool = true
    
    init(scene: DBScene, dialog: CloudDataDialog) {
        self.dialog = dialog
        super.init(iconName: "button_local", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        if self.confirmLocal {
            // Switch text to confirm
            self.dialog!.changeToLocalConfirm()
            
            self.confirmLocal = false
        } else {
            self.dbScene!.keepLoadedLocalData()
            self.dbScene!.unpauseGame()
            
            // Also record that we aren't going to sync to cloud
            GameData.sharedGameData.cloudSyncing = false
        }
    }
}
