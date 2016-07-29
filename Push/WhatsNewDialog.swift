//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class WhatsNewDialog: DialogBackground {
    var nextButton: MainMenuWhatsNewNextButton
    var previousButton: MainMenuWhatsNewPreviousButton
    var playButton: MainMenuWhatsNewPlayButton
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    var key: String
    var version: Double
    
    init(title: String, description: String, frameSize : CGSize, dialogs: Array<WhatsNewDialog>, dialogNumber: Int, scene: MainMenuScene, iconTexture: SKTexture, key: String, version: Double) {
        // Inits
        self.key = key
        self.version = version
        
        // Create the buttons
        self.nextButton = MainMenuWhatsNewNextButton(dialogNumber: dialogNumber, scene: scene)
        self.previousButton = MainMenuWhatsNewPreviousButton(dialogNumber: dialogNumber, scene: scene)
        self.playButton = MainMenuWhatsNewPlayButton(dialogNumber: dialogNumber, scene: scene)
        
        super.init(frameSize: frameSize)
        
        // Add to the parent
        scene.addChild(self) // TODO I think I dont need to do this anymore because I fixed the bug with the multiline text
        
        // Set the container size
        self.container.size = CGSize(width: frameSize.height * 1.0164 /** (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount()))*/, height: frameSize.height * 2 / 3.5)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        let iconBackgroundNodeXPosition = self.container.size.width / -2 + self.iconBackgroundNode!.size.width / 2 + self.buttonBuffer / 2
        let iconBackgroundNodeYPosition = self.container.size.height / 2 - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer / 2
        self.iconBackgroundNode?.position = CGPoint(x: iconBackgroundNodeXPosition, y: iconBackgroundNodeYPosition)
        
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
        self.titleNode?.text = title
        let titleNodeXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let titleNodeYPosition = self.container.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2
        self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
        
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
        self.descriptionNode?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = description
        let descriptionNodeXPosition = self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let descriptionNodeYPosition = self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
        self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        
        self.nextButton.position = CGPoint(x: self.container.size.width / 2 - self.nextButton.size.width / 2 - self.buttonBuffer / 2, y: self.container.size.height / -2 + self.nextButton.size.height / 2 + self.buttonBuffer / 2)
        self.previousButton.position = CGPoint(x: self.nextButton.position.x - self.previousButton.size.width - self.buttonBuffer, y: self.nextButton.position.y)
        self.playButton.position = CGPoint(x: self.nextButton.position.x, y: self.nextButton.position.y)
        
        self.container.addChild(self.nextButton)
        self.container.addChild(self.previousButton)
        self.container.addChild(self.playButton)
        
        // By default this is a "play" button
        self.nextButton.isHidden = true
        self.previousButton.isHidden = true
        self.playButton.isHidden = false
        
        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAsPlayOnly() {
        self.nextButton.isHidden = true
        self.previousButton.isHidden = true
        self.playButton.isHidden = false
    }
    
    func updateAsPlayAndPrevious() {
        self.nextButton.isHidden = true
        self.previousButton.isHidden = false
        self.playButton.isHidden = false
    }
    
    func updateAsNextOnly() {
        self.nextButton.isHidden = false
        self.previousButton.isHidden = true
        self.playButton.isHidden = true
    }
    
    func updateAsPreviousAndNext() {
        self.nextButton.isHidden = false
        self.previousButton.isHidden = false
        self.playButton.isHidden = true
    }
}
