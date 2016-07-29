//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class DBSceneDialog: DialogBackground {
    var okayButton: DBSceneOkayButton?
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var descriptionNode2: DSMultilineLabelNode?
    var descriptionNode3: DSMultilineLabelNode?
    var descriptionNode4: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    
    init(title: String, description: String, descriptionSize: Int, description2: String?, description3: String?, description4: String?, frameSize : CGSize, scene: DBScene, iconTexture: SKTexture) {
        super.init(frameSize: frameSize)
        
        // Create the buttons
        self.okayButton = DBSceneOkayButton(scene: scene, container: self)
        
        // Set the container size
        self.container.size = CGSize(width: frameSize.height * 1.0164 /** (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount()))*/, height: frameSize.height * 2 / 3.5)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        let iconBackgroundNodeXPosition = (self.container.size.width / -2) + (self.iconBackgroundNode!.size.width / 2) + (self.buttonBuffer / 2)
        let iconBackgroundNodeYPosition = (self.container.size.height / 2) - (self.iconBackgroundNode!.size.height / 2) - (self.buttonBuffer / 2)
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
        self.descriptionNode?.fontSize = round(CGFloat(descriptionSize) * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = description
        let descriptionNodeXPosition = self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let descriptionNodeYPosition = self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
        self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        if description2 != nil {
            self.descriptionNode2 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode2!)
            self.descriptionNode2?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode2?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.descriptionNode2?.fontColor = MerpColors.darkFont
            self.descriptionNode2?.text = description2!
            let descriptionNode2XPosition = self.container.size.width / -2 + self.descriptionNode2!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
            let descriptionNode2YPosition = self.descriptionNode!.position.y - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode2!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
            self.descriptionNode2?.position = CGPoint(x: descriptionNode2XPosition, y: descriptionNode2YPosition)
        }
        
        if description3 != nil {
            self.descriptionNode3 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode3!)
            self.descriptionNode3?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode3?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.descriptionNode3?.fontColor = MerpColors.darkFont
            self.descriptionNode3?.text = description3!
            let descriptionNode3XPosition = self.container.size.width / -2 + self.descriptionNode3!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
            let descriptionNode3YPosition = self.descriptionNode2!.position.y - self.descriptionNode2!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode3!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
            self.descriptionNode3?.position = CGPoint(x: descriptionNode3XPosition, y: descriptionNode3YPosition)
        }
        
        if description4 != nil {
            self.descriptionNode4 = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
            self.container.addChild(self.descriptionNode4!)
            self.descriptionNode4?.paragraphWidth = self.container.size.width - self.buttonBuffer
            self.descriptionNode4?.fontSize = round(12 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.descriptionNode4?.fontColor = MerpColors.darkFont
            self.descriptionNode4?.text = description4!
            let descriptionNode4XPosition = self.container.size.width / -2 + self.descriptionNode4!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
            let descriptionNode4YPosition = self.descriptionNode3!.position.y - self.descriptionNode3!.calculateAccumulatedFrame().size.height / 2 - self.descriptionNode4!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
            self.descriptionNode4?.position = CGPoint(x: descriptionNode4XPosition, y: descriptionNode4YPosition)
        }
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        
        self.okayButton!.position = CGPoint(x: self.container.size.width / 2 - self.okayButton!.size.width / 2 - self.buttonBuffer / 2, y: self.container.size.height / -2 + self.okayButton!.size.height / 2 + self.buttonBuffer / 2)
        
        self.container.addChild(self.okayButton!)

        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
