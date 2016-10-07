//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterPurchaseSuperstarButton)
class CharacterPurchaseSuperstarButton : DBButton {
    var unlockAmount: Int
    
    var gemIcon: SKSpriteNode
    var amount: LabelWithShadow
    
    var gemIconScale: CGFloat = 0.625
    var buffer: CGFloat = 6.0
    
    init(scene: DBScene, unlockAmount: Int) {
        self.unlockAmount = unlockAmount
        
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.amount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.amount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        
        super.init(buttonSize: DBButtonSize.extrasmall, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)

        
        // Setup amount
        self.amount.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.amount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        self.updateUnlockAmount(self.unlockAmount)
        
        self.addChild(self.gemIcon)
        self.addChild(self.amount)
    }
    
    func updateUnlockAmount(_ amount: Int) {
        self.unlockAmount = amount
        self.amount.setText("\(self.unlockAmount)")
        
        let topTotalWidth = self.gemIcon.size.width + self.amount.calculateAccumulatedFrame().size.width
        
        self.gemIcon.position = CGPoint(x: 0 + (topTotalWidth / 2 - self.gemIcon.size.width / 2), y: 0)
        self.amount.position = CGPoint(x: 0 - (topTotalWidth / 2 - self.amount.calculateAccumulatedFrame().size.width / 2), y: self.gemIcon.position.y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBeganAction() {
        let scaleMult: CGFloat = 0.95
        
        self.setScale(1 * scaleMult)
    }
    
    override func touchesEndedAction() {
        /*
        self.setScale(1)
        
        // If the user has enough gems, unlock it
        let unlockCost = GameData.sharedGameData.getSelectedCharacterData().getNextSuperstarPurchaseCost() // this func needs to check the purcahsedSuperstars against a cost grid and return the cost
        
        if unlockCost <= GameData.sharedGameData.totalDiamonds { // Unlock it
            GameData.sharedGameData.totalDiamonds = GameData.sharedGameData.totalDiamonds - unlockCost
            
            // Unlock the character
            GameData.sharedGameData.getSelectedCharacterData().purchaseNextSuperstar() // this func needs to add 1 to the purchasedSuperstars variable.
            
            // Save data
            GameData.sharedGameData.save()
            
            // Update the button with the correct cost of the new
            self.updateUnlockAmount(GameData.sharedGameData.getSelectedCharacterData().getNextSuperstarPurchaseCost())
            
            (self.dbScene as! CharacterSkillScene).updateSuperstars()
        } else {
            // If the user does not have enough gems, show purchase menu
            self.dbScene!.showPurchaseMenu(true, itemCost: unlockCost, onSuccess: {_ in }, onFailure: {}) // TODO REJUV - implement callbacks
        }
 */
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }
}
