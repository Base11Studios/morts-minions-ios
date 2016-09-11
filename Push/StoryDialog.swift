//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class StoryDialog: SKSpriteNode {
    var skipButton: GameStorySkipButton?
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    var key: String
    var version: Double
    
    var buttonBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    init(description: String, frameSize : CGSize, dialogNumber: Int, scene: GameScene, iconTexture: SKTexture, key: String, version: Double, beginning: Bool) {
        // Inits
        self.key = key
        self.version = version
        
        // Create the buttons
        self.skipButton = GameStorySkipButton(dialogNumber: dialogNumber, scene: scene, beginning: beginning)
        
        // Setup the background from super init
        super.init(texture: nil, color: MerpColors.background, size: frameSize)
        
        // Center on screen
        self.position = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        
        // TODO need this? self.isUserInteractionEnabled = true
        
        self.iconBackgroundNode = SKSpriteNode(texture: iconTexture)
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.descriptionNode?.paragraphWidth = self.size.width * 0.80
        self.descriptionNode?.fontSize = round(18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = description
        
        // Positioning
        let height = self.iconBackgroundNode!.size.height + self.buttonBuffer + self.descriptionNode!.calculateAccumulatedFrame().size.height
        
        // Center the description and icon for Y
        let iconBackgroundNodeXPosition = CGFloat(0.0)
        let iconBackgroundNodeYPosition = height / 2 - self.iconBackgroundNode!.size.height / 2
        self.iconBackgroundNode!.position = CGPoint(x: iconBackgroundNodeXPosition, y: iconBackgroundNodeYPosition)
        
        let descriptionNodeXPosition = CGFloat(0.0)
        let descriptionNodeYPosition = height / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.height / 2
        self.descriptionNode!.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        self.skipButton!.position = CGPoint(x: self.size.width / 2 - self.skipButton!.size.width / 2 - self.buttonBuffer, y: self.size.height / -2 + self.skipButton!.size.height / 2 + self.buttonBuffer)
        
        self.addChild(self.descriptionNode!)
        self.addChild(self.iconBackgroundNode!)
        self.addChild(self.skipButton!)
        
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
