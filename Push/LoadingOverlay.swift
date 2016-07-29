//
//  LoadingOverlay.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/7/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class LoadingOverlay: SKSpriteNode {
    // Container
    var loadingIcon: SKSpriteNode
    var loadingAction = SKAction()
    
    init(frameSize : CGSize) {
        // Icon
        self.loadingIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("eagleflapping_000"))
        
        // Animation
        self.loadingAction = SKAction.repeatForever(SKAction.animate(with: SpriteKitHelper.getTextureArrayFromAtlas(GameTextures.sharedInstance.uxAtlas, texturesNamed: "eagleflapping", frameStart: 0, frameEnd: 15), timePerFrame: 0.05, resize: true, restore: false))
        
        // Setup the background from super init
        super.init(texture: nil, color: MerpColors.pauseBackground, size: frameSize)
        
        // Put in center of screen
        self.position = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        
        // Add the container
        self.addChild(self.loadingIcon)
    }
    
    convenience init() {
        self.init(frameSize: CGSize())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() {
        self.loadingIcon.run(self.loadingAction)
    }
    
    func deactivate() {
        self.removeAllActions()
    }
}
