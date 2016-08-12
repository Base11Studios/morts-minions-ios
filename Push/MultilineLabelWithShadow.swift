//
//  LabelWithShadow.swift
//  Merp
//
//  Created by Dan Bellinski on 10/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class MultilineLabelWithShadow : SKNode, LabelWithShadowProtocol {
    var rightShadow: DSMultilineLabelNode
    var label: DSMultilineLabelNode
    var shadowXOffset: CGFloat
    var leftShadow: DSMultilineLabelNode
    
    func setText(_ text: String) {
        if self.label.text != text {
            self.label.text = text
            self.rightShadow.text = text
            self.leftShadow.text = text
        }
    }
    
    func setFontSize(_ size: CGFloat) {
        self.label.fontSize = size
        self.rightShadow.fontSize = size
        self.leftShadow.fontSize = size
    }
    
    func setHorizontalAlignmentMode(_ horizontalAlignmentMode: SKLabelHorizontalAlignmentMode) {
        self.label.horizontalAlignmentMode = horizontalAlignmentMode
        self.rightShadow.horizontalAlignmentMode = horizontalAlignmentMode
        self.leftShadow.horizontalAlignmentMode = horizontalAlignmentMode
    }
    
    func setVerticalAlignmentMode(_ verticalAlignmentMode: SKLabelVerticalAlignmentMode) {
        self.label.verticalAlignmentMode = verticalAlignmentMode
        self.rightShadow.verticalAlignmentMode = verticalAlignmentMode
        self.leftShadow.verticalAlignmentMode = verticalAlignmentMode
    }
    
    func setFontColor(_ fontColor: UIColor) {
        self.label.fontColor = fontColor
    }
    
    func setShadowFontColor(_ fontColor: UIColor) {
        self.rightShadow.fontColor = fontColor
        self.leftShadow.fontColor = fontColor
    }
    
    init(fontNamed fontName: String, scene: DBScene, darkFont: Bool, borderSize: CGFloat) {
        self.label = DSMultilineLabelNode(fontName: fontName, scene: scene)
        self.rightShadow = DSMultilineLabelNode(fontName: fontName, scene: scene)
        self.leftShadow = DSMultilineLabelNode(fontName: fontName, scene: scene)
        
        // Set shadow offsets
        self.shadowXOffset = borderSize * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
  
        super.init()

        self.shadowXOffset *= 2
        self.rightShadow.position = CGPoint(x: 0 + self.shadowXOffset, y: 0)
        self.leftShadow.position = CGPoint(x: -1, y: 0)
        
        // Set colors
        if !darkFont {
            // Main font white
            self.leftShadow.fontColor = MerpColors.darkFont
            self.rightShadow.fontColor = MerpColors.darkFont
            
            // Set default shadow to dark
            self.label.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        }
        else {
            // Main font dark
            self.leftShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            self.rightShadow.fontColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            
            // Set default shadow to white
            self.label.fontColor = MerpColors.darkFont
        }
        
        // Add the shadow to the node
        self.addChild(self.rightShadow)
        self.addChild(self.leftShadow)
        self.addChild(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

