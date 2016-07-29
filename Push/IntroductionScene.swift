//
//  IntroductionScene.swift
//  Push
//
//  Created by Dan Bellinski on 10/22/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(IntroductionScene)
class IntroductionScene : DBScene {
    var worldView: SKSpriteNode
    
    init(size: CGSize) {
        // Init vars
        // World selector view ( this is the background & parent that everything is added to)
        self.worldView = SKSpriteNode(color: MerpColors.background, size: size)
        
        // Super
        super.init(size: size, settings: false, loadingOverlay: false, purchaseMenu: false, rateMe: false)
        
        // Center the "camera"
        self.worldView.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        self.addChild(self.worldView)
        
        // Now create the logo image and add to the scene
        let logo: SKSpriteNode = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("logo_big"))
        logo.position = CGPoint(x: 0.0, y: self.frame.size.height / 8.0)
        self.worldView.addChild(logo)
        
        // Add the click here text
        let clickHereLabel = LabelWithShadow(fontNamed: "Avenir-Black", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        clickHereLabel.name = "hudLabel"
        clickHereLabel.setText("Click anywhere to start")
        clickHereLabel.setFontSize(20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        clickHereLabel.position = CGPoint(x: 0, y: -self.frame.size.height / 4.0)
        clickHereLabel.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        clickHereLabel.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        // Start faded
        clickHereLabel.alpha = 0.0
        
        self.worldView.addChild(clickHereLabel)
        
        let flashAction: SKAction = SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 2.0), SKAction.fadeOut(withDuration: 0.1)]))
        
        clickHereLabel.run(flashAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the user touches anywhere, go to the main page
        self.viewController!.presentMainMenuScene()
    }
}
