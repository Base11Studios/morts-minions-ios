//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class UXTutorialDialog: DialogBackground {
    var okButton: SceneTutorialTooltipOkButton?
    var descriptionNode: DSMultilineLabelNode?
    var builtIndicators = Array<SKSpriteNode>()
    weak var dbScene: DBScene?
    var onComplete: (()-> Void)? = {}
    
    init(frameSize: CGSize, description: String, scene: DBScene, size: String, indicators: Array<UxTutorialIndicatorPosition>, key: String, version: Double, onComplete: ()->Void) {
        var widthOffset: CGFloat = 0
        var heightOffset: CGFloat = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        self.dbScene = scene
        self.onComplete = onComplete
        
        var offsetSize: CGFloat = 4 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // First just get offsets
        if indicators.contains(UxTutorialIndicatorPosition.leftBottom) ||
            indicators.contains(UxTutorialIndicatorPosition.leftMiddle) ||
            indicators.contains(UxTutorialIndicatorPosition.leftTop) {
                widthOffset = widthOffset + offsetSize
                xOffset = xOffset - offsetSize / 2
        }
        if indicators.contains(UxTutorialIndicatorPosition.rightBottom) ||
            indicators.contains(UxTutorialIndicatorPosition.rightMiddle) ||
            indicators.contains(UxTutorialIndicatorPosition.rightTop) {
                widthOffset = widthOffset + offsetSize
                xOffset = xOffset + offsetSize / 2
        }
        if indicators.contains(UxTutorialIndicatorPosition.bottomCenter) ||
            indicators.contains(UxTutorialIndicatorPosition.bottomLeft) ||
            indicators.contains(UxTutorialIndicatorPosition.bottomRight) {
                heightOffset = heightOffset + offsetSize
                yOffset = yOffset - offsetSize / 2
        }
        if indicators.contains(UxTutorialIndicatorPosition.topCenter) ||
            indicators.contains(UxTutorialIndicatorPosition.topLeft) ||
            indicators.contains(UxTutorialIndicatorPosition.topRight) {
                heightOffset = heightOffset + offsetSize
                yOffset = yOffset + offsetSize / 2
        }
        
        super.init(frameSize: frameSize)
        
        // Create the button
        self.okButton = SceneTutorialTooltipOkButton(scene: scene, container: self, key: key, version: version, onComplete: self.onComplete!)
        
        // Make BG transparent
        self.color = MerpColors.superLightBackground
        
        var containerWidth: CGFloat = 0
        
        if (size == "Large") {
            containerWidth = 240 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        } else if (size == "Medium") {
            containerWidth = 180 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        } else if (size == "Small") {
            containerWidth = 117 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        }
        
        self.container.size = CGSize(width: containerWidth, height: 0)
        self.containerBackground.size = CGSize(width: containerWidth + 2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), height: 0 + 4 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        // Now we need to add the text and the button. Position in the center
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        self.descriptionNode?.paragraphWidth = containerWidth - self.buttonBuffer
        self.descriptionNode?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.descriptionNode?.fontColor = MerpColors.darkFont
        self.descriptionNode?.text = description
        
        // Create container height
        let containerHeight = self.descriptionNode!.calculateAccumulatedFrame().size.height + self.okButton!.size.height + self.buttonBuffer * 2
        
        let descriptionNodeXPosition = (self.container.size.width / -2) + (self.descriptionNode!.calculateAccumulatedFrame().size.width / 2) + (self.buttonBuffer / 2)
        let descriptionNodeYPosition = (containerHeight / 2) - (self.buttonBuffer / 2) - (self.descriptionNode!.calculateAccumulatedFrame().size.height / 2)
        self.descriptionNode?.position = CGPoint(x: descriptionNodeXPosition, y: descriptionNodeYPosition)
        
        self.okButton!.position = CGPoint(x: self.container.size.width / 2 - self.buttonBuffer / 2 - self.okButton!.size.width / 2, y: self.descriptionNode!.position.y - self.buttonBuffer - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.okButton!.size.height / 2)
        //self.okButton.position = CGPointMake(0, self.descriptionNode!.position.y - self.buttonBuffer - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.okButton.size.height / 2)
        self.container.addChild(self.okButton!)
        
        // Now we need to resize the height of the containers
        self.container.size = CGSize(width: containerWidth, height: containerHeight)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + widthOffset, height: containerHeight + 4 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) + heightOffset)
        
        self.containerBackground.position = CGPoint(x: 0,y: 0)
        self.container.position = CGPoint(x: -xOffset, y: -yOffset + 1)
        
        // Now we need to place the indicators because we have the height and width
        // Create the positions
        let wideIndy = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("top_ux_tutorial_indicator"))
        let tallIndy = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("left_ux_tutorial_indicator"))
        
        // Indicators on top and bottom
        let scalar: CGFloat = 1.0
        let halfWideIndyHeight = wideIndy.size.height / 2
        let halfWideIndyWidth = wideIndy.size.width / 2
        let horzLeftIndicatorX = CGFloat(self.containerBackground.position.x - self.containerBackground.size.width / 2 + halfWideIndyWidth) + scalar
        let horzRightIndicatorX = CGFloat(self.containerBackground.position.x + self.containerBackground.size.width / 2 - halfWideIndyWidth) - scalar
        let horzTopIndicatorY = CGFloat(self.containerBackground.position.y + (self.containerBackground.size.height / 2) + halfWideIndyHeight) - scalar
        let horzBottomIndicatorY = CGFloat(self.containerBackground.position.y - (self.containerBackground.size.height / 2) - halfWideIndyHeight) + scalar
        
        // Indicators on left and right sides
        let halfTallIndyHeight = tallIndy.size.height / 2
        let halfTallIndyWidth = tallIndy.size.width / 2
        let vertTopIndicatorY = CGFloat(self.containerBackground.position.y + (self.containerBackground.size.height / 2) - halfTallIndyHeight) - scalar
        let vertBottomIndicatorY = CGFloat(self.containerBackground.position.y - (self.containerBackground.size.height / 2) + halfTallIndyHeight) + scalar
        let vertLeftIndicatorX = CGFloat(self.containerBackground.position.x - (self.containerBackground.size.width / 2) - halfTallIndyWidth) + scalar
        let vertRightIndicatorX = CGFloat(self.containerBackground.position.x + (self.containerBackground.size.width / 2) + halfTallIndyWidth) - scalar
        
        // Top
        if indicators.contains(UxTutorialIndicatorPosition.topLeft) {
            self.createAndAddIndicator("top_ux_tutorial_indicator", position: CGPoint(x: horzLeftIndicatorX, y: horzTopIndicatorY))
        }
        if indicators.contains(UxTutorialIndicatorPosition.topCenter) {
            self.createAndAddIndicator("top_ux_tutorial_indicator", position: CGPoint(x: 0, y: horzTopIndicatorY))
        }
        if indicators.contains(UxTutorialIndicatorPosition.topRight) {
            self.createAndAddIndicator("top_ux_tutorial_indicator", position: CGPoint(x: horzRightIndicatorX, y: horzTopIndicatorY))
        }
        
        // Bottom
        if indicators.contains(UxTutorialIndicatorPosition.bottomLeft) {
            self.createAndAddIndicator("bottom_ux_tutorial_indicator", position: CGPoint(x: horzLeftIndicatorX, y: horzBottomIndicatorY))
        }
        if indicators.contains(UxTutorialIndicatorPosition.bottomCenter) {
            self.createAndAddIndicator("bottom_ux_tutorial_indicator", position: CGPoint(x: 0, y: horzBottomIndicatorY))
        }
        if indicators.contains(UxTutorialIndicatorPosition.bottomRight) {
            self.createAndAddIndicator("bottom_ux_tutorial_indicator", position: CGPoint(x: horzRightIndicatorX, y: horzBottomIndicatorY))
        }
        
        // Left
        if indicators.contains(UxTutorialIndicatorPosition.leftTop) {
            self.createAndAddIndicator("left_ux_tutorial_indicator", position: CGPoint(x: vertLeftIndicatorX, y: vertTopIndicatorY))
        }
        if indicators.contains(UxTutorialIndicatorPosition.leftMiddle) {
            self.createAndAddIndicator("left_ux_tutorial_indicator", position: CGPoint(x: vertLeftIndicatorX, y: 0))
        }
        if indicators.contains(UxTutorialIndicatorPosition.leftBottom) {
            self.createAndAddIndicator("left_ux_tutorial_indicator", position: CGPoint(x: vertLeftIndicatorX, y: vertBottomIndicatorY))
        }
        
        // Right
        if indicators.contains(UxTutorialIndicatorPosition.rightTop) {
            self.createAndAddIndicator("right_ux_tutorial_indicator", position: CGPoint(x: vertRightIndicatorX, y: vertTopIndicatorY))
        }
        if indicators.contains(UxTutorialIndicatorPosition.rightMiddle) {
            self.createAndAddIndicator("right_ux_tutorial_indicator", position: CGPoint(x: vertRightIndicatorX, y: 0))
        }
        if indicators.contains(UxTutorialIndicatorPosition.rightBottom) {
            self.createAndAddIndicator("right_ux_tutorial_indicator", position: CGPoint(x: vertRightIndicatorX, y: vertBottomIndicatorY))
        }
        
        self.isHidden = true
    }
    
    func createAndAddIndicator(_ name: String, position: CGPoint) {
        let indy = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed(name))
        
        indy.position = position
        
        self.containerBackground.addChild(indy)
        
        builtIndicators.append(indy)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
