//
//  GameCooldownButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/26/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameCooldownButton)
class GameCooldownButton : DBButton {
    var atlasArray: Array<SKTexture> = []
    
    convenience init(atlasName: String, texturesNamed texturesName: String, frameStart: Int, frameEnd: Int, scene: DBScene) {
        // Create the button
        self.init(name: texturesName + "_000", pressedName: texturesName + "_000", dbScene: scene, atlas: GameTextures.sharedInstance.buttonGameAtlas)
        
        // Get the animation
        self.atlasArray = SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.buttonGameAtlas, texturesNamed: texturesName, frameStart: frameStart, frameEnd: frameEnd)
        
        // Do not want to be able to touch this
        self.isUserInteractionEnabled = false
    }
    
    func runAnimation(_ length: Double) {
        let timePerFrame = length / (Double(atlasArray.count) * 1.0)
        let buttonCooldownAction: SKAction = SKAction.animate(with: atlasArray, timePerFrame: timePerFrame, resize: true, restore: true)
        let buttonCooldownEndedAction: SKAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([buttonCooldownAction, buttonCooldownEndedAction]))
    }
}
