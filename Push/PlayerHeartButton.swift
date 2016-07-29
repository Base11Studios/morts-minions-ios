//
//  PlayerHeartButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/25/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(PlayerHeartButton)
class PlayerHeartButton : DBButton {
    var specialTexture: SKTexture = GameTextures.sharedInstance.buttonAtlas.textureNamed("heartgold")
    var baseTexture: SKTexture = GameTextures.sharedInstance.buttonAtlas.textureNamed("heartfilled")
    
    init(scene: DBScene) {
        super.init(name: "heartfilled", pressedName: "heartopen", dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func releaseButtonSpecialColor() {
        super.releaseButton()
        self.texture = specialTexture
    }
}
