//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class HeartBoostDialog: DialogBackground {
    // Buttons
    var okayButton: GameBoostPlayButton?
    
    // Heart Boost
    var heartBoost: HeartBoostContainer?
    
    // Other items
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    
    init(frameSize : CGSize, scene: DBScene) {
        super.init(frameSize: frameSize)
        
        // Create the buttons
        self.okayButton = GameBoostPlayButton(scene: scene as! GameScene)
        
        // Set the container size
        //self.container.size = CGSizeMake(frameSize.width * 2 / 3.5 * (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount())), 2)
        //self.containerBackground.size = CGSizeMake(self.container.size.width + 2, self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        
        // Get the icon for this
        let iconTexture: SKTexture = GameTextures.sharedInstance.buttonAtlas.textureNamed("heartfilled_large")
        
        let widthRatio = iconTexture.size().width / iconBackgroundNode!.size.width
        let heightRatio = iconTexture.size().height / iconBackgroundNode!.size.height
        var adjustRatio: CGFloat
        
        if widthRatio > heightRatio {
            adjustRatio = widthRatio
        } else {
            adjustRatio = heightRatio
        }
        
        self.iconNode = SKSpriteNode(texture: iconTexture, color: SKColor(), size: CGSize(width: iconTexture.size().width / adjustRatio, height: iconTexture.size().height / adjustRatio))
        self.iconNode?.setScale(0.7)
        
        // Title and desc
        self.titleNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.titleNode!)
    
        self.titleNode?.paragraphWidth = self.container.size.width - self.buttonBuffer - self.iconBackgroundNode!.size.width
        self.titleNode?.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.titleNode?.fontColor = MerpColors.darkFont
        self.titleNode?.text = "want a boost?"
        
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
        self.descriptionNode?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = "add hearts to your character for this play."
        
        self.heartBoost = HeartBoostContainer(scene: scene)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        self.container.addChild(self.heartBoost!)
        self.container.addChild(self.okayButton!)
        
        let height = self.iconBackgroundNode!.size.height + self.descriptionNode!.calculateAccumulatedFrame().size.height + self.heartBoost!.calculateAccumulatedFrame().size.height + self.okayButton!.size.height + self.buttonBuffer * 3
        let width = max(max(self.descriptionNode!.calculateAccumulatedFrame().size.width, self.heartBoost!.calculateAccumulatedFrame().size.width), self.iconBackgroundNode!.size.width + self.buttonBuffer + self.titleNode!.calculateAccumulatedFrame().size.width)
        
        self.iconBackgroundNode?.position = CGPoint(x: width / -2 + self.iconBackgroundNode!.size.width / 2, y: height / 2 - self.iconBackgroundNode!.size.height / 2)
        
        let titleNodeXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let titleNodeYPosition = height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2
        self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
        
        self.descriptionNode?.position = CGPoint(x: width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2, y: self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer)
        
        self.heartBoost!.position = CGPoint(x: 0, y: self.descriptionNode!.position.y - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer - self.heartBoost!.calculateAccumulatedFrame().size.height / 2)
        
        self.okayButton!.position = CGPoint(x: width / 2 - self.okayButton!.size.width / 2 - self.buttonBuffer / 2, y: self.heartBoost!.position.y - self.heartBoost!.calculateAccumulatedFrame().size.height / 2 - self.okayButton!.size.height / 2 - self.buttonBuffer)
        
        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
