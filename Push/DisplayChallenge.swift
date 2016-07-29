//
//  SingleChallenge.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/17/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class DisplayChallenge: SKNode {
    weak var dbScene: DBScene?
    
    var icon: DBButton
    var completedIcon: SKSpriteNode
    var iconHighlight: SKSpriteNode
    var text: DSMultilineLabelNode
    var challenge: LevelChallenge
    
    var buffer: CGFloat = 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var widthTarget: CGFloat
    
    var isHighlighted: Bool = false
    
    // Accounts for unused paragraph space
    var trueWidth: CGFloat = 0.0
    
    init(scene: DBScene, challenge: LevelChallenge) {
        self.dbScene = scene
        self.challenge = challenge
        
        self.icon = DBButton(iconName: "trophyempty", pressedIconName: nil, buttonSize: DBButtonSize.square_Medium, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        self.completedIcon = DBButton(iconName: "trophygold", pressedIconName: nil, buttonSize: DBButtonSize.square_Medium, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        self.completedIcon.isHidden = true
        
        self.iconHighlight = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium_highlight_gold"))
        
        self.iconHighlight.isHidden = true
        
        self.text = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: self.dbScene!)
        
        self.text.fontColor = MerpColors.darkFont
        self.text.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.text.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.text.fontSize = round(16 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        // Change text if completed
        if self.challenge.completed {
            self.text.text = challenge.getDescription() + ". claimed \(challenge.reward) gem"
        } else {
            self.text.text = challenge.getDescription() + ". bounty: \(challenge.reward) gem"
        }
        
        // Make gem plural if needed
        if challenge.reward > 1 {
            self.text.text = self.text.text + "s."
        } else {
            self.text.text = self.text.text + "."
        }
        self.text.paragraphWidth = scene.size.height * 0.667
        
        // Center appropriately
        self.widthTarget = self.text.paragraphWidth + self.iconHighlight.size.width + self.buffer / 2
        self.trueWidth = widthTarget
        
        self.iconHighlight.position = CGPoint(x: 0 - (self.widthTarget / 2 - self.iconHighlight.size.width / 2), y: 0)
        let textXPosition = (self.widthTarget / 2) - (self.text.paragraphWidth / 2) - ((self.text.paragraphWidth - self.text.calculateAccumulatedFrame().size.width) / 2)
        let textYPosition = CGFloat(0)
        self.text.position = CGPoint(x: textXPosition, y: textYPosition)
        
        // Match the same positions
        self.icon.position = self.iconHighlight.position
        self.completedIcon.position = self.iconHighlight.position
        
        super.init()
        
        self.addChild(self.iconHighlight)
        self.addChild(self.icon)
        self.addChild(self.completedIcon)
        self.addChild(self.text)
        
        // If this challenge is completed, mark it so
        if challenge.completed {
            self.completeChallenge()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlightChallenge() {
        self.completeChallenge()
        
        // Highlight this
        text.fontColor = MerpColors.highlightColor
        iconHighlight.isHidden = false
        
        self.isHighlighted = true
    }
    
    func completeChallenge() {
        // Switch icons
        icon.isHidden = true
        completedIcon.isHidden = false
        
        // Make text dull
        text.fontColor = MerpColors.darkFontDulled
    }
}
