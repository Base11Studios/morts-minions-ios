//
//  LabelWithShadow.swift
//  Merp
//
//  Created by Dan Bellinski on 10/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class LabelWithShadow : SKNode {
    var topShadow: SKLabelNode
    var bottomShadow: SKLabelNode
    var leftShadow: SKLabelNode
    var rightShadow: SKLabelNode
    var topRightShadow: SKLabelNode
    var bottomLeftShadow: SKLabelNode
    var leftTopShadow: SKLabelNode
    var rightBottomShadow: SKLabelNode
    var label: SKLabelNode
    var shadowXOffset: CGFloat
    var shadowYOffset: CGFloat
    
    func setText(_ text: String) {
        if self.label.text != text {
            self.label.text = text
            self.topShadow.text = text
            self.bottomShadow.text = text
            self.leftShadow.text = text
            self.rightShadow.text = text
            self.topRightShadow.text = text
            self.bottomLeftShadow.text = text
            self.leftTopShadow.text = text
            self.rightBottomShadow.text = text
        }
    }
    
    func setFontSize(_ size: CGFloat) {
        self.label.fontSize = size
        self.topShadow.fontSize = size
        self.bottomShadow.fontSize = size
        self.leftShadow.fontSize = size
        self.rightShadow.fontSize = size
        self.topRightShadow.fontSize = size
        self.bottomLeftShadow.fontSize = size
        self.leftTopShadow.fontSize = size
        self.rightBottomShadow.fontSize = size
    }
    
    func setHorizontalAlignmentMode(_ horizontalAlignmentMode: SKLabelHorizontalAlignmentMode) {
        self.label.horizontalAlignmentMode = horizontalAlignmentMode
        self.topShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.bottomShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.leftShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.rightShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.topRightShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.bottomLeftShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.leftTopShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.rightBottomShadow.horizontalAlignmentMode = horizontalAlignmentMode
    }
    
    func setVerticalAlignmentMode(_ verticalAlignmentMode: SKLabelVerticalAlignmentMode) {
        self.label.verticalAlignmentMode = verticalAlignmentMode
        self.topShadow.verticalAlignmentMode = verticalAlignmentMode
        self.bottomShadow.verticalAlignmentMode = verticalAlignmentMode
        self.leftShadow.verticalAlignmentMode = verticalAlignmentMode
        self.rightShadow.verticalAlignmentMode = verticalAlignmentMode
        self.topRightShadow.verticalAlignmentMode = verticalAlignmentMode
        self.bottomLeftShadow.verticalAlignmentMode = verticalAlignmentMode
        self.leftTopShadow.verticalAlignmentMode = verticalAlignmentMode
        self.rightBottomShadow.verticalAlignmentMode = verticalAlignmentMode
    }
    
    func setFontColor(_ fontColor: UIColor) {
        self.label.fontColor = fontColor
    }
    
    func setShadowFontColor(_ fontColor: UIColor) {
        self.topShadow.fontColor = fontColor
        self.bottomShadow.fontColor = fontColor
        self.leftShadow.fontColor = fontColor
        self.rightShadow.fontColor = fontColor
        self.topRightShadow.fontColor = fontColor
        self.bottomLeftShadow.fontColor = fontColor
        self.leftTopShadow.fontColor = fontColor
        self.rightBottomShadow.fontColor = fontColor
    }
    
    convenience init(darkFont: Bool) {
        self.init(fontNamed: "Avenir-Black", darkFont: darkFont, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
    }
    
    convenience init(fontNamed: String, darkFont: Bool) {
        self.init(fontNamed: fontNamed, darkFont: darkFont, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
    }
    
    init(fontNamed fontName: String, darkFont: Bool, borderSize: CGFloat) {
        self.label = SKLabelNode(fontNamed: fontName)
        
        self.topShadow = SKLabelNode(fontNamed: fontName)
        self.bottomShadow = SKLabelNode(fontNamed: fontName)
        self.leftShadow = SKLabelNode(fontNamed: fontName)
        self.rightShadow = SKLabelNode(fontNamed: fontName)
        self.topRightShadow = SKLabelNode(fontNamed: fontName)
        self.bottomLeftShadow = SKLabelNode(fontNamed: fontName)
        self.leftTopShadow = SKLabelNode(fontNamed: fontName)
        self.rightBottomShadow = SKLabelNode(fontNamed: fontName)
        
        // Set shadow offsets
        self.shadowXOffset = borderSize
        self.shadowYOffset = borderSize
        
        super.init()
        
        self.topShadow.position = CGPoint(x: 0, y: 0 + self.shadowYOffset)
        self.bottomShadow.position = CGPoint(x: 0, y: 0 - self.shadowYOffset)
        self.leftShadow.position = CGPoint(x: 0 - self.shadowYOffset, y: 0)
        
        self.bottomLeftShadow.position = CGPoint(x: 0 - self.shadowXOffset, y: 0 - self.shadowYOffset)
        self.leftTopShadow.position = CGPoint(x: 0 - self.shadowXOffset, y: 0 + self.shadowYOffset)
        
        self.shadowXOffset *= 2
        self.rightBottomShadow.position = CGPoint(x: 0 + self.shadowXOffset, y: 0 - self.shadowYOffset)
        self.rightShadow.position = CGPoint(x: 0 + self.shadowYOffset, y: 0)
        self.topRightShadow.position = CGPoint(x: 0 + self.shadowXOffset, y: 0 + self.shadowYOffset)
        
        // Set colors
        if !darkFont {
            // Main font white
            self.topShadow.fontColor = MerpColors.darkFont
            self.bottomShadow.fontColor = MerpColors.darkFont
            self.leftShadow.fontColor = MerpColors.darkFont
            self.rightShadow.fontColor = MerpColors.darkFont
            self.topRightShadow.fontColor = MerpColors.darkFont
            self.bottomLeftShadow.fontColor = MerpColors.darkFont
            self.leftTopShadow.fontColor = MerpColors.darkFont
            self.rightBottomShadow.fontColor = MerpColors.darkFont

            
            // Set default shadow to dark
            self.label.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        }
        else {
            // Main font dark
            self.topShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.bottomShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.leftShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.rightShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.topRightShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.bottomLeftShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.leftTopShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.rightBottomShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            
            // Set default shadow to white
            self.label.fontColor = MerpColors.darkFont
        }
        
        // Add the shadow to the node
        self.addChild(self.topShadow)
        self.addChild(self.bottomShadow)
        self.addChild(self.leftShadow)
        self.addChild(self.rightShadow)
        self.addChild(self.topRightShadow)
        self.addChild(self.bottomLeftShadow)
        self.addChild(self.leftTopShadow)
        self.addChild(self.rightBottomShadow)
        self.addChild(self.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

