//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class CloudDataDialog: DialogBackground {
    // Buttons
    var localButton: CloudDataLocalButton?
    var cloudButton: CloudDataCloudButton?
    
    // Other items
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?
    
    init(frameSize : CGSize, scene: DBScene) {
        super.init(frameSize: frameSize)
        
        // Create the buttons
        self.localButton = CloudDataLocalButton(scene: scene, dialog: self)
        self.cloudButton = CloudDataCloudButton(scene: scene)
        
        // Set the container size
        self.container.size = CGSize(width: frameSize.height * 1.0164 /** (1 + (1 - ScaleBuddy.sharedInstance.getScaleAmount()))*/, height: frameSize.height * 2 / 3.5) // TODOSCALE havent updated
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
        self.container.position = CGPoint(x: 0, y: 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        
        let iconBackgroundNodeXPosition = self.container.size.width / -2 + self.iconBackgroundNode!.size.width / 2 + self.buttonBuffer / 2
        let iconBackgroundNodeYPosition = self.container.size.height / 2 - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer / 2
        self.iconBackgroundNode?.position = CGPoint(x: iconBackgroundNodeXPosition, y: iconBackgroundNodeYPosition)
        
        // Get the icon for this
        let iconTexture: SKTexture = GameTextures.sharedInstance.buttonAtlas.textureNamed("cloud")
        
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
        self.titleNode?.text = "Newer iCloud Data Found"
        let titleNodeXPosition = self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let titleNodeYPosition = self.container.size.height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer / 2
        self.titleNode?.position = CGPoint(x: titleNodeXPosition, y: titleNodeYPosition)
        
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        self.descriptionNode?.paragraphWidth = self.container.size.width - self.buttonBuffer
        self.descriptionNode?.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = "A game save was found in iCloud that is more recent than the local game save on this device. Would you like to load the save from iCloud and replace the save on this device (recommended)? If you do not load the iCloud save it will be overwritten."
        let descriptionNodeXPosition = self.container.size.width / -2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2
        let descriptionNodeYPosition = self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer
        self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        
        self.cloudButton!.position = CGPoint(x: self.container.size.width / 2 - self.cloudButton!.size.width / 2 - self.buttonBuffer / 2, y: self.container.size.height / -2 + self.cloudButton!.size.height / 2 + self.buttonBuffer / 2)
        self.localButton!.position = CGPoint(x: self.cloudButton!.position.x - self.localButton!.size.width - self.buttonBuffer, y: self.cloudButton!.position.y)
        
        self.container.addChild(self.cloudButton!)
        self.container.addChild(self.localButton!)
        
        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }
    
    func changeToLocalConfirm() {
        self.titleNode?.text = "Are You Sure?"
        self.titleNode?.position = CGPoint(x: self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2, y: self.titleNode!.position.y)
        
        self.descriptionNode?.text = "If you do not load the iCloud save, the iCloud save will be overwritten by the local save on this device for this iCloud account."
        self.descriptionNode?.position = CGPoint(x: self.descriptionNode!.position.x, y: self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer)
        
        //self.cloudButton!.position = CGPointMake(self.container.size.width / 2 - self.cloudButton!.size.width / 2 - self.buttonBuffer / 2, self.container.size.height / -2 + self.cloudButton!.size.height / 2 + self.buttonBuffer / 2)
        //self.localButton!.position = CGPointMake(self.cloudButton!.position.x - self.localButton!.size.width - self.buttonBuffer, self.cloudButton!.position.y)
        
        // Reset the container size
        // self.resetContainerSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.cloudButton!.alreadyPrompted = false
        self.cloudButton!.forceDisabled = false
    }
}
