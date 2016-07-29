//
//  ScrollingSKSpriteNode.swift
//  Push
//
//  Created by Dan Bellinski on 10/24/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(HeartBoostNode)
class HeartBoostNode : SKSpriteNode {
    var boostCost: Int = 1
    var heartBoost: Int = 1
    
    // Button
    var boostButton: SKSpriteNode
    var boostSelectedNode: SKSpriteNode
    var boostIcon: SKSpriteNode
    var boostIcon2: SKSpriteNode
    var boostIcon3: SKSpriteNode
    var boostText: LabelWithShadow
    var boostCostIcon: SKSpriteNode
    var boostCostText: LabelWithShadow
    
    // Container
    weak var container: HeartBoostContainer?
    
    // Buffer
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()

    // Icon sizing
    var gemIconScale: CGFloat = 0.625
    var heartIconScale: CGFloat = 0.6
    
    init(heartBoost: Int, boostCost: Int, container: HeartBoostContainer){
        // Init
        self.container = container
        
        // Add buttons
        self.boostSelectedNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("boost_button_selected"))
        
        //self.boostSelectedNode.size = CGSizeMake(self.boostSelectedNode.size.width * 1.3, self.boostSelectedNode.size.height * 0.7)
        self.boostButton = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("boost_button"))
        //self.boostButton.size = CGSizeMake(self.boostButton.size.width * 1.3, self.boostButton.size.height * 0.6)
        
        self.boostIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("heartfilled"))
        //self.boostIcon.position = CGPointMake(-10, self.boostButton.size.height / 2 + self.boostIcon.size.height / 2 + 3)
        self.boostIcon.setScale(heartIconScale)
        
        self.boostIcon2 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("heartfilled"))
        //self.boostIcon2.position = CGPointMake(0, self.boostIcon.position.y)
        self.boostIcon2.setScale(heartIconScale)
        
        self.boostIcon3 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("heartfilled"))
        //self.boostIcon3.position = CGPointMake(10, self.boostIcon.position.y)
        self.boostIcon3.setScale(heartIconScale)
        
        self.boostCostIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        //self.boostCostIcon.position = CGPointMake(13, 0)
        self.boostCostIcon.setScale(self.gemIconScale)
        
        self.boostText = LabelWithShadow(fontNamed: "Avenir-Heavy", darkFont: true, borderSize: 1.5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.boostText.setFontSize(round(20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
       // self.boostText.position = CGPointMake(-20, self.boostIcon.position.y)
        self.boostText.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.boostText.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.boostText.setText("+")
        
        self.boostCostText = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.boostCostText.setFontSize(round(20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        //self.boostCostText.position = CGPointMake(-14, 2)
        self.boostCostText.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.boostCostText.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.boostCostText.setText("\(boostCost)")
        
        // Positioning
        // Cost
        let costTotalWidth = self.boostCostIcon.size.width + self.boostCostText.calculateAccumulatedFrame().size.width
        self.boostCostIcon.position = CGPoint(x: 0 + (costTotalWidth / 2 - self.boostCostIcon.size.width / 2), y: 0)
        self.boostCostText.position = CGPoint(x: 0 - (costTotalWidth / 2 - self.boostCostText.calculateAccumulatedFrame().size.width / 2), y: self.boostCostIcon.position.y)
        
        // Heart boost
        if heartBoost == 1 {
            let boostTotalWidth = self.boostIcon.size.width + self.boostText.calculateAccumulatedFrame().size.width
            self.boostIcon.position = CGPoint(x: boostTotalWidth / 2 - self.boostIcon.size.width / 2, y: self.boostButton.size.height / 2 + self.boostIcon.size.height / 2 + 3)
            self.boostText.position = CGPoint(x: self.boostIcon.position.x - self.boostIcon.size.width / 2 - self.boostText.calculateAccumulatedFrame().size.width / 2, y: self.boostIcon.position.y)
            
            self.boostButton.addChild(self.boostIcon)
        } else if heartBoost == 2 {
            let boostTotalWidth = self.boostIcon.size.width * 2 + self.boostText.calculateAccumulatedFrame().size.width
            self.boostIcon.position = CGPoint(x: boostTotalWidth / 2 - self.boostIcon.size.width / 2, y: self.boostButton.size.height / 2 + self.boostIcon.size.height / 2 + 3)
            self.boostIcon2.position = CGPoint(x: self.boostIcon.position.x - self.boostIcon.size.width / 2 - self.boostIcon2.size.width / 2, y: self.boostButton.size.height / 2 + self.boostIcon.size.height / 2 + 3)
            self.boostText.position = CGPoint(x: self.boostIcon2.position.x - self.boostIcon2.size.width / 2 - self.boostText.calculateAccumulatedFrame().size.width / 2, y: self.boostIcon.position.y)
            
            self.boostButton.addChild(self.boostIcon)
            self.boostButton.addChild(self.boostIcon2)
        } else if heartBoost == 3 {
            let boostTotalWidth = self.boostIcon.size.width * 3 + self.boostText.calculateAccumulatedFrame().size.width
            self.boostIcon.position = CGPoint(x: boostTotalWidth / 2 - self.boostIcon.size.width / 2, y: self.boostButton.size.height / 2 + self.boostIcon.size.height / 2 + 3)
            self.boostIcon2.position = CGPoint(x: self.boostIcon.position.x - self.boostIcon.size.width / 2 - self.boostIcon2.size.width / 2, y: self.boostButton.size.height / 2 + self.boostIcon.size.height / 2 + 3)
            self.boostIcon3.position = CGPoint(x: self.boostIcon2.position.x - self.boostIcon2.size.width / 2 - self.boostIcon3.size.width / 2, y: self.boostButton.size.height / 2 + self.boostIcon2.size.height / 2 + 3)
            self.boostText.position = CGPoint(x: self.boostIcon3.position.x - self.boostIcon3.size.width / 2 - self.boostText.calculateAccumulatedFrame().size.width / 2, y: self.boostIcon.position.y)
            
            self.boostButton.addChild(self.boostIcon)
            self.boostButton.addChild(self.boostIcon2)
            self.boostButton.addChild(self.boostIcon3)
        }
        
        super.init(texture: nil, color: SKColor(), size: self.boostSelectedNode.size)
        
        //self.setScale(0.4985)
        
        // Set props
        self.boostCost = boostCost
        self.heartBoost = heartBoost
        
        self.addChild(self.boostSelectedNode)
        self.addChild(self.boostButton)
        
        self.boostButton.addChild(self.boostText)
        self.boostButton.addChild(self.boostCostIcon)
        self.boostButton.addChild(self.boostCostText)
        
        self.boostSelectedNode.isHidden = true
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
        
        // If already selected, unselect it
        if container!.selectedHeartBoost == self {
            self.boostSelectedNode.isHidden = true
            self.container!.selectedHeartBoost = nil
            self.container!.updateHeartBoostText(true)
        } else if GameData.sharedGameData.totalDiamonds >= self.boostCost {
            // If not selected and player has enough gems to pay for it, select it
            if self.container!.selectedHeartBoost != nil {
                self.container!.selectedHeartBoost!.boostSelectedNode.isHidden = true
            }
            self.container!.selectedHeartBoost = self
            self.boostSelectedNode.isHidden = false
            self.container!.updateHeartBoostText(false)
        } else {
            // Prompt for player to buy it (go to the store OR just pay .99 for 10 or whatever)
            self.container!.dbScene!.showPurchaseMenu(true, itemCost: self.boostCost, onSuccess: {_ in }, onFailure: {}) // TODO REJUV
        }
    }
}
