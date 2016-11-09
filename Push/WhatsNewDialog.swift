//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class WhatsNewDialog: DialogBackground {
    var playButton: MainMenuWhatsNewPlayButton
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var descriptionNode2: DSMultilineLabelNode?
    var descriptionNode3: DSMultilineLabelNode?
    var descriptionNode4: DSMultilineLabelNode?
    var descriptionNode5: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    var key: String
    var version: Double
    
    init(title: String, description: String, description2: String?, description3: String?, description4: String?, description5: String?, frameSize : CGSize, dialogs: Array<WhatsNewDialog>, dialogNumber: Int, scene: MainMenuScene, iconTexture: SKTexture, key: String, version: Double) {
        // Inits
        self.key = key
        self.version = version
        
        // Create the buttons
        self.playButton = MainMenuWhatsNewPlayButton(dialogNumber: dialogNumber, scene: scene)
        
        super.init(frameSize: frameSize)
        
        // Add to the parent
        scene.addChild(self) // TODO I think I dont need to do this anymore because I fixed the bug with the multiline text
        
        // Set the container size
        self.container.size = CGSize(width: frameSize.height * 1.0164 /** (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount()))*/, height: frameSize.height * 2 / 3.5)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        var minHeight = self.container.size.height
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        
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

        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
        self.descriptionNode?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = description

        var height: CGFloat = self.iconBackgroundNode!.size.height + self.descriptionNode!.calculateAccumulatedFrame().size.height + self.buttonBuffer * 1.5 + self.playButton.size.height
        
        if description2 != nil && description2 != "" {
            self.descriptionNode2 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode2!)
            self.descriptionNode2?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode2?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
            self.descriptionNode2?.fontColor = MerpColors.darkFont
            self.descriptionNode2?.text = description2!
            height += self.descriptionNode2!.calculateAccumulatedFrame().size.height + self.buttonBuffer / 2
        }
        
        if description3 != nil && description3 != "" {
            self.descriptionNode3 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode3!)
            self.descriptionNode3?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode3?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
            self.descriptionNode3?.fontColor = MerpColors.darkFont
            self.descriptionNode3?.text = description3!
            height += self.descriptionNode3!.calculateAccumulatedFrame().size.height + self.buttonBuffer / 2
        }
        
        if description4 != nil && description4 != "" {
            self.descriptionNode4 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode4!)
            self.descriptionNode4?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode4?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
            self.descriptionNode4?.fontColor = MerpColors.darkFont
            self.descriptionNode4?.text = description4!
            height += self.descriptionNode4!.calculateAccumulatedFrame().size.height + self.buttonBuffer / 2
        }
        
        if description5 != nil && description5 != "" {
            self.descriptionNode5 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode5!)
            self.descriptionNode5?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode5?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
            self.descriptionNode5?.fontColor = MerpColors.darkFont
            self.descriptionNode5?.text = description5!
            height += self.descriptionNode5!.calculateAccumulatedFrame().size.height + self.buttonBuffer / 2
        }
        
        if height < minHeight {
            height = minHeight
        }
        
        // POSITIONING
        let iconBackgroundNodeXPosition = self.container.size.width / -2 + self.iconBackgroundNode!.size.width / 2 + self.buttonBuffer / 2
        let iconBackgroundNodeYPosition = height / 2 - self.iconBackgroundNode!.size.height / 2
        self.iconBackgroundNode?.position = CGPoint(x: iconBackgroundNodeXPosition, y: iconBackgroundNodeYPosition)
        
        let titleNodeXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let titleNodeYPosition = height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2
        self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
        
        let descriptionNodeXPosition = self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let descriptionNodeYPosition = self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
        self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        self.playButton.position = CGPoint(x: self.container.size.width / 2 - self.playButton.size.width / 2 - self.buttonBuffer / 2, y: -height / 2 + self.playButton.size.height / 2)
        
        if descriptionNode2 != nil {
            self.descriptionNode2?.position = CGPoint(x: self.descriptionNode!.position.x - self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.descriptionNode2!.calculateAccumulatedFrame().size.width / 2, y: self.descriptionNode!.position.y - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode2!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2)
            
            self.playButton.position = CGPoint(x: self.container.size.width / 2 - self.playButton.size.width / 2 - self.buttonBuffer / 2, y: -height / 2 + self.playButton.size.height / 2)
        }
        
        if descriptionNode3 != nil {
            self.descriptionNode3?.position = CGPoint(x: self.descriptionNode!.position.x - self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.descriptionNode3!.calculateAccumulatedFrame().size.width / 2, y: self.descriptionNode2!.position.y - self.descriptionNode2!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode3!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2)
            
            self.playButton.position = CGPoint(x: self.container.size.width / 2 - self.playButton.size.width / 2 - self.buttonBuffer / 2, y: -height / 2 + self.playButton.size.height / 2)
        }
        
        if descriptionNode4 != nil {
            self.descriptionNode4?.position = CGPoint(x: self.descriptionNode!.position.x - self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.descriptionNode4!.calculateAccumulatedFrame().size.width / 2, y: self.descriptionNode3!.position.y - self.descriptionNode3!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode4!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2)
            
            self.playButton.position = CGPoint(x: self.container.size.width / 2 - self.playButton.size.width / 2 - self.buttonBuffer / 2, y: -height / 2 + self.playButton.size.height / 2)
        }
        
        if descriptionNode5 != nil {
            self.descriptionNode5?.position = CGPoint(x: self.descriptionNode!.position.x - self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.descriptionNode5!.calculateAccumulatedFrame().size.width / 2, y: self.descriptionNode4!.position.y - self.descriptionNode4!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode5!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2)
            
            self.playButton.position = CGPoint(x: self.container.size.width / 2 - self.playButton.size.width / 2 - self.buttonBuffer / 2, y: -height / 2 + self.playButton.size.height / 2)
        }
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)

        self.container.addChild(self.playButton)

        self.playButton.isHidden = false
        
        // Reset the container size
        self.resetContainerSize(width: nil, height: height)
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
