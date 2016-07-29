//
//  ScrollingSkillNode.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class ScrollingSkillNode : SKSpriteNode {
    var nodeContent: SKSpriteNode?
    var nodeIcon: SKSpriteNode?
    var selectedBackground: SKSpriteNode?
    var isSelected: Bool = false
    var isPurchased: Bool = false
    var nodeLock: SKSpriteNode?
    
    // Deets
    var skillDescription: String
    var skillTitle: String
    var skillCost: Int
    var skillCurrency: Currency
    var skillId: CharacterUpgrade
    var skillParentId: CharacterUpgrade
    var childSkillId: CharacterUpgrade
    
    init(upgradeName: String, upgradeId: CharacterUpgrade, upgradeCost: Int, upgradeCurrency: Currency, upgradeDescription: String, upgradeParentId: CharacterUpgrade, upgradeIcon: String?, upgradeType: UpgradeType) {
        // Set the info
        self.skillDescription = upgradeDescription
        self.skillTitle = upgradeName
        self.skillCost = upgradeCost
        self.skillCurrency = upgradeCurrency
        self.skillId = upgradeId
        self.skillParentId = upgradeParentId
        self.childSkillId = CharacterUpgrade.None // For now we dont know the child
        
        // Create self as same size as the sprite that will be the main content
        super.init(texture: nil, color: UIColor(), size: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium").size())
        
        if (upgradeType == UpgradeType.Skill) {
            self.nodeIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed(upgradeIcon!))
            
            // Skill lock
            self.nodeLock = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("\(upgradeIcon!)empty"))
            
            self.nodeIcon!.size = CGSize(width: self.nodeIcon!.size.width * 0.65, height: self.nodeIcon!.size.height * 0.65)
            self.nodeLock!.size = CGSize(width: self.nodeLock!.size.width * 0.65, height: self.nodeLock!.size.height * 0.65)
            
            // Create main content
            self.nodeContent = SKSpriteNode(texture: nil, color: UIColor(), size: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium").size())
        } else {
            self.nodeIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("upgradeiconfilled"))
            
            // Skill lock
            self.nodeLock = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("upgradeiconempty"))
            
            self.nodeIcon!.size = CGSize(width: self.nodeIcon!.size.width * 0.65, height: self.nodeIcon!.size.height * 0.65)
            self.nodeLock!.size = CGSize(width: self.nodeLock!.size.width * 0.65, height: self.nodeLock!.size.height * 0.65)
            
            // Create main content
            self.nodeContent = SKSpriteNode(texture: nil, color: UIColor(), size: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium").size())
        }
        
        self.nodeLock!.name = "upgradelock"
        self.nodeLock?.position = CGPoint(x: 0, y: 1)
        
        // Create background
        self.selectedBackground = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium_highlight"))
        
        // Add bg first then content
        self.addChild(self.selectedBackground!)
        self.addChild(self.nodeContent!)
        self.nodeContent!.addChild(self.nodeIcon!)
        self.nodeContent!.addChild(self.nodeLock!)

        // Make sure the node is not selected
        self.selected(self.isSelected)
        
        // Ensure we can click the node
        self.isUserInteractionEnabled = true
        
        // Check if the skill is purchased
        self.checkSkillPurchased()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected(_ selected: Bool) {
        self.isSelected = selected
        
        if selected {
            self.selectedBackground?.isHidden = false
        } else {
            self.selectedBackground?.isHidden = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Unselect the selected node
        let parent = self.parent?.parent as! VerticalScrollingSkillNode
        
        // Set the newly touched node as the selected one
        parent.setSelectedNode(self)
        
        SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
    }
    
    func checkSkillPurchased() {
        if GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(skillId) {
            self.isPurchased = true
        } else {
            self.isPurchased = false
        }
        
        if self.isPurchased {
            self.nodeLock?.alpha = 0.0
            self.nodeIcon?.alpha = 1.0
        } else {
            self.nodeLock?.alpha = 1.0
            self.nodeIcon?.alpha = 0.0
        }
    }
}
