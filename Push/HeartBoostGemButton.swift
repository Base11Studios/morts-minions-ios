//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(HeartBoostGemButton)
class HeartBoostGemButton : DBButton {
    var unlockAmount: Int
    
    var gemIcon: SKSpriteNode
    var amount: LabelWithShadow
    
    var gemIconScale: CGFloat = 1.325
    var buffer: CGFloat = 6.0
    
    init(scene: GameScene, unlockAmount: Int) {
        self.unlockAmount = unlockAmount
        
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.amount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.amount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        
        super.init(buttonSize: DBButtonSize.square_Large, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        
        // Setup amount
        self.amount.setFontSize(round(52 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.amount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        self.updateUnlockAmount(self.unlockAmount)
        
        if !GameData.sharedGameData.getSelectedCharacterData().hasFreeHeartBoosts() {
            self.addChild(self.gemIcon)
        }
        
        self.addChild(self.amount)
    }
    
    func updateUnlockAmount(_ amount: Int) {
        if GameData.sharedGameData.getSelectedCharacterData().hasFreeHeartBoosts() {
            self.amount.setText("free")
            self.amount.position = CGPoint(x: 0, y: 0)
        } else {
            self.unlockAmount = amount
            self.amount.setText("\(self.unlockAmount)")
        
            let topTotalWidth = self.gemIcon.size.width + self.amount.calculateAccumulatedFrame().size.width
        
            self.gemIcon.position = CGPoint(x: 0 + (topTotalWidth / 2 - self.gemIcon.size.width / 2), y: 0)
            self.amount.position = CGPoint(x: 0 - (topTotalWidth / 2 - self.amount.calculateAccumulatedFrame().size.width / 2), y: self.gemIcon.position.y)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBeganAction() {
        let scaleMult: CGFloat = 0.95
        
        self.setScale(1 * scaleMult)
    }
    
    override func touchesEndedAction() {
        let title = "ClickedToBuyHeartBoostWithGems"
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "cont" as NSObject
            ])
        
        self.setScale(1)
        
        if GameData.sharedGameData.getSelectedCharacterData().hasFreeHeartBoosts() {
            let title = "ClickedToBuyHeartBoostWithGemsAndHadFreebie"
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            
            // Reduce free hb
            GameData.sharedGameData.getSelectedCharacterData().useFreeHeartBoost()
            //GameData.sharedGameData.save()
            
            // Heart boost for free
            self.purchaseBoost(false)
        } else {
            if self.unlockAmount <= GameData.sharedGameData.totalDiamonds { // Unlock it
                let title = "ClickedToBuyHeartBoostWithGemsAndHadGems"
                FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                    kFIRParameterItemID: "id-\(title)" as NSObject,
                    kFIRParameterItemName: title as NSObject,
                    kFIRParameterContentType: "cont" as NSObject
                    ])
                
                self.purchaseBoost(true)
            } else {
                let title = "ClickedToBuyHeartBoostWithGemsAndDidntHaveGems"
                FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                    kFIRParameterItemID: "id-\(title)" as NSObject,
                    kFIRParameterItemName: title as NSObject,
                    kFIRParameterContentType: "cont" as NSObject
                    ])
                // If the user does not have enough gems, show purchase menu
                // Need weak reference to prevent retain cycle
                let onSuccessPurchase: (Bool) -> Void = {[weak self] (flag: Bool) in self!.purchaseBoost(flag)}
                // Need weak reference to prevent retain cycle
                let onFailedPurchase: () -> Void = {[weak self] in self!.dismissBoost()}
                self.dbScene!.showPurchaseMenu(true, itemCost: self.unlockAmount, onSuccess: onSuccessPurchase, onFailure: onFailedPurchase)
            }
        }
    }
    
    func purchaseBoost(_ useGems: Bool) -> Void {
        if useGems {
            GameData.sharedGameData.totalDiamonds = GameData.sharedGameData.totalDiamonds - self.unlockAmount
            
            (self.dbScene as! GameScene).enableHeartBoost()
        } else {
            (self.dbScene as! GameScene).enableHeartBoost()
        }
        
        return
    }
    
    func dismissBoost() -> Void {
        // TODO anything?
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }
}
