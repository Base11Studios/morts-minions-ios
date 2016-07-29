//
//  ScrollingSKSpriteNode.swift
//  Push
//
//  Created by Dan Bellinski on 10/24/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(WorldNode)
class WorldNode : SKSpriteNode {
    var levelNumber: Int = 1
    var worldNumber: Int = 1
    var levelLocked: Bool = true
    var levelLockNode: SKSpriteNode

    var worldName: String
    
    // Button
    var levelButtonNode: LevelSelectWorldButton
    
    // Selected
    var levelSelectedNode: SKSpriteNode
    weak var relatedLevelSelector: ScrollingLevelNodeRow?
    var selected: Bool = false {
        didSet {
            self.relatedLevelSelector!.isHidden = !selected
            self.levelSelectedNode.isHidden = !selected
        }
    }
    
    // Scene
    weak var dbScene: LevelSelectionScene?
    
    // Buffer
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    // Trophy Count
    var trophyIcon: SKSpriteNode
    var trophyCount: LabelWithShadow
    
    init(levelNumber: Int, worldNumber: Int, worldName: String, relatedLevelSelector: ScrollingLevelNodeRow, dbScene: LevelSelectionScene){
        // Init
        self.dbScene = dbScene
        
        self.relatedLevelSelector = relatedLevelSelector
        
        // Level background
        self.worldName = worldName
        
        // Add the level lock icon
        self.levelLockNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonMenuAtlas.textureNamed("world_button_locked"))
        
        // Add level selected icon
        self.levelSelectedNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonMenuAtlas.textureNamed("world_button_selected"))
        
        self.levelButtonNode = LevelSelectWorldButton(scene: dbScene, iconName: "world_select_\(worldName)", worldNumber: worldNumber)
        
        // Trohpy Count
        self.trophyIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("trophygold"))
        self.trophyIcon.setScale(0.9)
        self.trophyCount = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        self.trophyCount.setFontSize(round(22 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.trophyCount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.trophyCount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        super.init(texture: nil, color: SKColor(), size: self.levelSelectedNode.size)
        
        self.setScale(0.4985)
        
        // Add the level lock icon
        self.levelLockNode.alpha = 0.6

        self.name = "db_world_node_\(levelNumber)"
        self.levelNumber = levelNumber
        self.worldNumber = worldNumber
        
        self.addChild(levelSelectedNode)
        self.addChild(levelButtonNode)
        self.addChild(levelLockNode)
        self.addChild(self.trophyIcon)
        self.addChild(self.trophyCount)
        
        // Add stars and determine if locked
        self.updateLevelNode()
        
        // Update trophy count
        self.updateTrophyCount()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Call this anytime to update all node aspects
     */
    func updateLevelNode() {
        // Unlock level, update stars
        self.lockOrUnlockLevel()
        
        self.updateTrophyCount()
    }
    
    func lockOrUnlockLevel() {
        self.levelLocked = GameData.sharedGameData.getSelectedCharacterData().isWorldLocked(self.levelNumber)
        
        if self.levelLocked {
            self.levelLockNode.isHidden = false
            self.levelButtonNode.unPressedLabel!.isHidden = true
            self.levelButtonNode.pressedLabel!.isHidden = true
        } else {
            self.levelLockNode.isHidden = true
            self.levelButtonNode.unPressedLabel!.isHidden = false
            self.levelButtonNode.pressedLabel!.isHidden = false
        }
    }
    
    func updateTrophyCount() {
        if GameData.sharedGameData.getSelectedCharacterData().challengesUnlocked(1) && !self.levelLocked {
            self.trophyCount.setText("\(GameData.sharedGameData.getSelectedCharacterData().challengesEarnedForWorld(self.worldNumber))")
            
            // Positioning
            let modNodeBuffer: CGFloat = nodeBuffer * 0.75 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            let trophyY = -self.size.height / 2 - self.trophyIcon.size.height / 2 - modNodeBuffer
            let trophyWidth = self.trophyIcon.size.width + self.trophyIcon.calculateAccumulatedFrame().size.width
            
            self.trophyIcon.position = CGPoint(x: 0 + (trophyWidth / 2 - self.trophyIcon.size.width / 2), y: trophyY)
            self.trophyCount.position = CGPoint(x: 0 - (trophyWidth / 2 - self.trophyCount.calculateAccumulatedFrame().size.width / 2) + modNodeBuffer, y: trophyY)
            
            self.trophyIcon.isHidden = false
            self.trophyCount.isHidden = false
        } else {
            self.trophyIcon.isHidden = true
            self.trophyCount.isHidden = true
        }
    }
}
