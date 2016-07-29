//
//  ScrollingSkillNodeRow.swift
//  Merp
//
//  Created by Dan Bellinski on 10/29/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class ScrollingSkillNodeRow : SKSpriteNode {
    var nodeBuffer: CGFloat = 6.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var numberChildren: Int = 0
    var rowNumber: Int = 0
    var rowStripe: SKSpriteNode
    var background: SKSpriteNode
    
    // Hold the first skill node added
    var firstSkillNode: ScrollingSkillNode?
    var secondSkillNode: ScrollingSkillNode?
    
    init() {
        // If this is a small screen we want a smaller nodeBuffer
        if ScaleBuddy.sharedInstance.getScaleAmount() < 1 {
            self.nodeBuffer = 0.0
        }
        
        
        // Green
        self.rowStripe = SKSpriteNode(color: UIColor(red: 108 / 255.0, green: 190 / 255.0, blue: 69 / 255.0, alpha: 0.4), size: CGSize(width: 0,height: 0))
        
        self.rowStripe = SKSpriteNode(color: MerpColors.darkFont, size: CGSize(width: 0,height: 0))
        
        self.background = ScaleBuddy.sharedInstance.getScreenAdjustedSpriteWithModifier("upgraderow", textureAtlas:  GameTextures.sharedInstance.uxMenuAtlas, modifier: 2.4)
        
        super.init(texture: nil, color: UIColor(), size: CGSize())
        
        super.addChild(self.background)
        //super.addChild(self.rowStripe)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addChild(_ node: SKNode) {
        // SSNode
        let scrollingSkillNode = node as! ScrollingSkillNode
        
        // If the skill node is not selected, select this
        if self.firstSkillNode == nil {
            self.firstSkillNode = scrollingSkillNode
        } else if self.secondSkillNode == nil {
            self.secondSkillNode = scrollingSkillNode
        }
    
        // These will be added horizontally because they make up 1 row
        scrollingSkillNode.position = CGPoint(x: (scrollingSkillNode.nodeContent!.size.width + self.nodeBuffer) * CGFloat(self.numberChildren), y: 0)
        
        self.numberChildren += 1
        
        super.addChild(scrollingSkillNode)
        
        // Update the row stripe
        self.rowStripe.size = CGSize(width: self.calculateAccumulatedFrame().size.width - scrollingSkillNode.calculateAccumulatedFrame().size.width, height: 1)
        self.rowStripe.position = CGPoint(x: self.rowStripe.size.width/2, y: 0)
        self.background.position = CGPoint(x: self.rowStripe.size.width/2, y: 0)
    }
}
