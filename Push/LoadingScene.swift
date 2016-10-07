//
//  LoadingScene.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(LoadingScene)
class LoadingScene : DBScene {
    var worldView: SKSpriteNode
    
    init(size: CGSize) {
        // Init vars
        // World selector view ( this is the background & parent that everything is added to)
        self.worldView = SKSpriteNode(color: MerpColors.background, size: size)
        
        // Super
        super.init(size: size, settings: false, loadingOverlay: false, purchaseMenu: false, rateMe: false, trade: false)
        
        // Center the "camera"
        self.worldView.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        self.addChild(self.worldView)
        
        // Now create the logo image and add to the scene
        let logo: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "splash"))
        logo.setScale(0.85)
        self.worldView.addChild(logo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lets lie and pretend like we have music so it is silent. Praise the silence
    override func hasOwnMusic() -> Bool {
        return true
    }
}
