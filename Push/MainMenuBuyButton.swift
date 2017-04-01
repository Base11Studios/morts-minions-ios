//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(MainMenuBuyButton)
class MainMenuBuyButton : DBButton {
    var unlockAmount: Int
    
    var gemIcon: SKSpriteNode
    var amount: LabelWithShadow
    
    var gemIconScale: CGFloat = 0.825
    var buffer: CGFloat = 6.0
    
    init(scene: MainMenuScene, unlockAmount: Int) {
        self.unlockAmount = unlockAmount
        
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.amount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.amount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        
        super.init(buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        
        // Setup amount
        self.amount.setFontSize(round(34 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
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
        self.setScale(1)
        
        let title = "ClickedToBuyCharacter"
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "cont" as NSObject
            ])
        
        // If the user has enough gems, unlock it
        let unlockCost = CharacterType.getUnlockCost(GameData.sharedGameData.selectedCharacter)
        
        if unlockCost <= GameData.sharedGameData.totalDiamonds { // Unlock it
            self.purchaseCharacter(ugh: true)
        } else {
            let title = "ClickedToBuyCharacterAndDidntHaveGems"
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            // If the user does not have enough gems, show purchase menu
            // Need weak reference to prevent retain cycle
            //let onSuccessPurchase: (Bool) -> Void = {[weak self] (ugh: Bool) in self!.purchaseCharacter(ugh: ugh)}
            self.dbScene!.showPurchaseMenu(true, itemCost: unlockCost, onSuccess: {_ in }, onFailure: {}) // TODO REJUV
        }
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }

    func purchaseCharacter(ugh: Bool) -> Void {
        // If the user has enough gems, unlock it
        let unlockCost = CharacterType.getUnlockCost(GameData.sharedGameData.selectedCharacter)
        
        if unlockCost <= GameData.sharedGameData.totalDiamonds { // Unlock it
            let title = "PurchasedCharacter-\(GameData.sharedGameData.selectedCharacter.rawValue)-ForGems-\(unlockCost)"
            FIRAnalytics.logEvent(withName: kFIREventSpendVirtualCurrency, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            
            GameData.sharedGameData.totalDiamonds = GameData.sharedGameData.totalDiamonds - unlockCost
            
            // Unlock the character
            GameData.sharedGameData.getSelectedCharacterData().isCharacterUnlocked = true
            
            // Determine if we need to lock char
            (self.dbScene as! MainMenuScene).lockOrUnlockCharacter()
            
            // Save data
            GameData.sharedGameData.save()
        }
    }
}
