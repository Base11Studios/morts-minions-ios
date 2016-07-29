//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class RateMeDialog: DialogBackground {
    var rateButton: RateMeRateButton
    var neverButton: RateMeNeverButton
    var laterButton: RateMeLaterButton
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    
    init(frameSize: CGSize, scene: DBScene) {
        // Create the buttons
        self.rateButton = RateMeRateButton(scene: scene)
        self.neverButton = RateMeNeverButton(scene: scene)
        self.laterButton = RateMeLaterButton(scene: scene)
        
        super.init(frameSize: frameSize)
        
        // Set the container size
        self.container.size = CGSize(width: frameSize.height * 1.0164 /** (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount()))*/, height: frameSize.height * 2 / 3.5)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        let iconBackgroundNodeXPosition = self.container.size.width / -2 + self.iconBackgroundNode!.size.width / 2 + self.buttonBuffer / 2
        let iconBackgroundNodeYPosition = self.container.size.height / 2 - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer / 2
        self.iconBackgroundNode?.position = CGPoint(x: iconBackgroundNodeXPosition, y: iconBackgroundNodeYPosition)
        
        let iconTexture = GameTextures.sharedInstance.uxMenuAtlas.textureNamed("upgradeiconfilled")
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
        self.titleNode?.text = "please rate the game!"
        let titleNodeXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let titleNodeYPosition = self.container.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2
        self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
        
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        
        self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
        self.descriptionNode?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = "if you like mort's minions, please leave a positive rating on the app store. i built this game in my free time with the approval of my wife. help me pursue my passion by spreading the word! thanks - dan"
        let descriptionNodeXPosition = self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let descriptionNodeYPosition = self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
        self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        
        self.rateButton.position = CGPoint(x: self.container.size.width / 2 - self.rateButton.size.width / 2 - self.buttonBuffer / 2, y: self.container.size.height / -2 + self.rateButton.size.height / 2 + self.buttonBuffer / 2)
        self.laterButton.position = CGPoint(x: self.rateButton.position.x - self.laterButton.size.width - self.buttonBuffer, y: self.rateButton.position.y)
        self.neverButton.position = CGPoint(x: self.laterButton.position.x - self.neverButton.size.width - self.buttonBuffer, y: self.rateButton.position.y)
        
        self.container.addChild(self.rateButton)
        self.container.addChild(self.neverButton)
        self.container.addChild(self.laterButton)
        
        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
