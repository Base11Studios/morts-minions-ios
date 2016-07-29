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
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    var key: String
    var version: Double
    
    init(title: String, description: String, frameSize : CGSize, dialogs: Array<TutorialDialog>, dialogNumber: Int, scene: GameScene, iconTexture: SKTexture, key: String, version: Double) {
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
        self.container.size = CGSizeMake(frameSize.width * 2 / 3.5 * (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount())), frameSize.height * 2 / 3.5)
        self.containerBackground.size = CGSizeMake(self.container.size.width + 2, self.container.size.height + 4)
        self.container.position = CGPointMake(0, 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        self.iconBackgroundNode?.position = CGPointMake(self.container.size.width / -2 + self.iconBackgroundNode!.size.width / 2 + self.buttonBuffer / 2, self.container.size.height / 2 - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer / 2)
        
        let widthRatio = iconTexture.size().width / iconBackgroundNode!.size.width
        let heightRatio = iconTexture.size().height / iconBackgroundNode!.size.height
        var adjustRatio: CGFloat
        
        if widthRatio > heightRatio {
            adjustRatio = widthRatio
        } else {
            adjustRatio = heightRatio
        }
        
        self.iconNode = SKSpriteNode(texture: iconTexture, color: SKColor(), size: CGSizeMake(iconTexture.size().width / adjustRatio, iconTexture.size().height / adjustRatio))
        self.iconNode?.setScale(0.7)
        
        // Title and desc
        self.titleNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.titleNode!)
        
        self.titleNode?.text = title
        self.titleNode?.paragraphWidth = self.container.size.width - self.buttonBuffer - self.iconBackgroundNode!.size.width
        self.titleNode?.fontSize = 28
        self.titleNode?.fontColor = MerpColors.darkFont
        self.titleNode?.position = CGPointMake(self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2, self.container.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2)
        
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        self.descriptionNode?.text = description
        self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
        self.descriptionNode?.fontSize = 14
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.position = CGPointMake(self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2, self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        
        self.nextButton.position = CGPointMake(self.container.size.width / 2 - self.nextButton.size.width / 2 - self.buttonBuffer / 2, self.container.size.height / -2 + self.nextButton.size.height / 2 + self.buttonBuffer / 2)
        self.previousButton.position = CGPointMake(self.nextButton.position.x - self.previousButton.size.width - self.buttonBuffer, self.nextButton.position.y)
        self.playButton.position = CGPointMake(self.nextButton.position.x, self.nextButton.position.y)
        
        self.container.addChild(self.nextButton)
        self.container.addChild(self.previousButton)
        self.container.addChild(self.playButton)
        
        // By default this is a "play" button
        self.nextButton.hidden = true
        self.previousButton.hidden = true
        self.playButton.hidden = false
        
        // Reset the container size
        self.resetContainerSize()
        
        self.hidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAsPlayOnly() {
        self.nextButton.hidden = true
        self.previousButton.hidden = true
        self.playButton.hidden = false
    }
    
    func updateAsPlayAndPrevious() {
        self.nextButton.hidden = true
        self.previousButton.hidden = false
        self.playButton.hidden = false
    }
    
    func updateAsNextOnly() {
        self.nextButton.hidden = false
        self.previousButton.hidden = true
        self.playButton.hidden = true
    }
    
    func updateAsPreviousAndNext() {
        self.nextButton.hidden = false
        self.previousButton.hidden = false
        self.playButton.hidden = true
    }
}