//
//  PlayerHeartButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/25/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(SuperstarButton)
class SuperstarButton : DBButton {
    init() {
        super.init(dbScene: nil)
    }
    
    init(scene: DBScene) {
        super.init(name: "superstarempty", pressedName: "superstar", dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
