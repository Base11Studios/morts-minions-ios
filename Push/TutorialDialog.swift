//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class TutorialDialog: DialogBackground {
    var nextButton: GameTutorialNextButton
    var previousButton: GameTutorialPreviousButton
    var playButton: GameTutorialPlayButton
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var speechBubble: SKSpriteNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    var key: String
    var version: Double
    
    init(title: String, description: String, frameSize : CGSize, dialogs: Array<TutorialDialog>, dialogNumber: Int, scene: GameScene, iconTexture: SKTexture, isCharacter: Bool, key: String, version: Double, prependText: Bool) {
        // Inits
        self.key = key
        self.version = version
        
        // Create the buttons
        self.nextButton = GameTutorialNextButton(dialogNumber: dialogNumber, scene: scene)
        self.previousButton = GameTutorialPreviousButton(dialogNumber: dialogNumber, scene: scene)
        self.playButton = GameTutorialPlayButton(dialogNumber: dialogNumber, scene: scene)
        
        super.init(frameSize: frameSize)
        
        // Add to the parent
        scene.addChild(self) // TODO I think I dont need to do this anymore because I fixed the bug with the multiline text
        
        // Set the container size
        self.container.size = CGSize(width: frameSize.height * 1.0164 /** (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount()))*/, height: frameSize.height * 2 / 3.5)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        self.nextButton.position = CGPoint(x: self.container.size.width / 2 - self.nextButton.size.width / 2 - self.buttonBuffer / 2, y: self.container.size.height / -2 + self.nextButton.size.height / 2 + self.buttonBuffer / 2)
        self.previousButton.position = CGPoint(x: self.nextButton.position.x - self.previousButton.size.width - self.buttonBuffer, y: self.nextButton.position.y)
        self.playButton.position = CGPoint(x: self.nextButton.position.x, y: self.nextButton.position.y)
        
        // Icon
        if isCharacter {
            self.iconBackgroundNode = SKSpriteNode(texture: iconTexture)

            if iconBackgroundNode!.size.width > iconBackgroundNode!.size.height { // LANDSCAPE
                let maxHeight = self.container.size.height - self.buttonBuffer * 4
                let maxWidth = self.container.size.width - buttonBuffer * 3 - self.playButton.size.width
                
                // Ratio to max wide
                let widthRatio = maxWidth / self.iconBackgroundNode!.size.width
                // Ratio max height (basically .55% and speech buub gets the rest)
                let heightRatio = (maxHeight * 0.65) / self.iconBackgroundNode!.size.height
                let aspectRatio = min(widthRatio, heightRatio)
                
                // whichever one is smaller, we have to go with that one
                
                self.iconBackgroundNode?.setScale(aspectRatio)
                self.iconNode = SKSpriteNode()
                
                self.speechBubble = SKSpriteNode(texture: GameTextures.sharedInstance.uxGameAtlas.textureNamed("landscape_speech_bubble"))
                
                let speechWidthRatio = (self.container.size.width - buttonBuffer * 1) / self.speechBubble!.size.width
                // Ratio max height (basically .55% and speech buub gets the rest)
                let speechHeightRatio = (maxHeight * 0.45) / self.speechBubble!.size.height
                let speechAspectRatio = min(speechWidthRatio, speechHeightRatio)
                
                self.speechBubble?.setScale(speechAspectRatio)
                let speechBubbleXPosition = CGFloat(0)
                let speechBubbleYPosition = self.container.size.height / 2 - self.speechBubble!.size.height / 2 - self.buttonBuffer / 2
                self.speechBubble?.position = CGPoint(x: speechBubbleXPosition, y: speechBubbleYPosition)
                self.container.addChild(self.speechBubble!)
                
                let iconBackgroundNodeXPosition = self.playButton.position.x - self.playButton.size.width / 2 - self.iconBackgroundNode!.size.width / 2 - buttonBuffer*2
                let iconBackgroundNodeYPosition = self.speechBubble!.position.y - self.speechBubble!.size.height / 2 - self.iconBackgroundNode!.size.height / 2 - 1
                self.iconBackgroundNode?.position = CGPoint(x: iconBackgroundNodeXPosition, y: iconBackgroundNodeYPosition)
                
                // Title and desc
                self.titleNode = DSMultilineLabelNode(fontName: "Avenir-Heavy", scene: scene)
                self.titleNode?.paragraphWidth = self.speechBubble!.size.width * 0.93
                self.titleNode?.fontSize = round(21 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                self.titleNode?.fontColor = MerpColors.darkFont
                if prependText {
                    self.titleNode?.text = TextFormatter.formatTextUppercase("I'm \(title)")
                } else {
                    self.titleNode?.text = TextFormatter.formatTextUppercase("\(title)")
                }
                let titleNodeXPosition = self.speechBubble!.position.x - self.speechBubble!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.speechBubble!.size.width * 0.035
                let titleNodeYPosition = self.speechBubble!.position.y + self.speechBubble!.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.speechBubble!.size.height * 0.1
                self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
                
                self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
                self.descriptionNode?.paragraphWidth = self.speechBubble!.size.width * 0.93
                self.descriptionNode?.fontSize = round(16 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                self.descriptionNode?.fontColor = MerpColors.darkFont
                self.descriptionNode?.text = description
                let descriptionNodeXPosition = self.speechBubble!.position.x - self.speechBubble!.size.width / 2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.speechBubble!.size.width * 0.035
                let descriptionNodeYPosition = self.titleNode!.position.y - self.titleNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 4
                self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
            } else { // PORTRAIT
                self.iconBackgroundNode?.setScale(self.container.size.height / self.iconBackgroundNode!.size.height)
                self.iconBackgroundNode?.position = CGPoint(x: self.container.size.width / -2 + self.iconBackgroundNode!.size.width / 2, y: self.container.size.height / 2 - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer / 2)
                self.iconNode = SKSpriteNode()
                
                self.speechBubble = SKSpriteNode(texture: GameTextures.sharedInstance.uxGameAtlas.textureNamed("portrait_speech_bubble"))
                self.speechBubble?.setScale((self.container.size.width - self.iconBackgroundNode!.calculateAccumulatedFrame().size.width - self.buttonBuffer) / self.speechBubble!.size.width)
                let speechBubbleXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.speechBubble!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer
                let speechBubbleYPosition = self.container.size.height / 2 - self.speechBubble!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2
                self.container.addChild(self.speechBubble!)
                self.speechBubble?.position = CGPoint(x: speechBubbleXPosition, y: speechBubbleYPosition)
                
                // Title and desc
                self.titleNode = DSMultilineLabelNode(fontName: "Avenir-Heavy", scene: scene)
                self.titleNode?.paragraphWidth = self.speechBubble!.size.width * 0.73
                self.titleNode?.fontSize = round(22 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                self.titleNode?.fontColor = MerpColors.darkFont
                if prependText {
                    self.titleNode?.text = TextFormatter.formatTextUppercase("I'm \(title)")
                } else {
                    self.titleNode?.text = TextFormatter.formatTextUppercase("\(title)")
                }
                let titleNodeXPosition = self.speechBubble!.position.x - self.speechBubble!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.speechBubble!.size.width * 0.22
                let titleNodeYPosition = self.speechBubble!.position.y + self.speechBubble!.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.speechBubble!.size.height * 0.1
                self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
                
                self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
                self.descriptionNode?.paragraphWidth = self.speechBubble!.size.width * 0.73
                self.descriptionNode?.fontSize = round(16 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
                self.descriptionNode?.fontColor = MerpColors.darkFont
                self.descriptionNode?.text = description
                let descriptionNodeXPosition = self.speechBubble!.position.x - self.speechBubble!.size.width / 2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.speechBubble!.size.width * 0.22
                let descriptionNodeYPosition = self.titleNode!.position.y - self.titleNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
                self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
            }
        } else {
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
            self.titleNode?.paragraphWidth = self.container.size.width - self.buttonBuffer - self.iconBackgroundNode!.size.width
            self.titleNode?.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.titleNode?.fontColor = MerpColors.darkFont
            self.titleNode?.text = TextFormatter.formatTextUppercase(title)
            let titleNodeXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
            let titleNodeYPosition = self.container.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2
            self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
            
            self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.descriptionNode?.fontColor = MerpColors.darkFont
            self.descriptionNode?.text = description
            let descriptionNodeXPosition = self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
            let descriptionNodeYPosition = self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
            self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        }
        
        self.container.addChild(self.titleNode!)
        self.container.addChild(self.descriptionNode!)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        
        
        
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
