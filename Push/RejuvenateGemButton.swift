//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(RejuvenateGemButton)
class RejuvenateGemButton : DBButton {
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
        
        if !GameData.sharedGameData.getSelectedCharacterData().hasFreeRejuvenations() {
            self.addChild(self.gemIcon)
        }
        
        self.addChild(self.amount)
    }
    
    func updateUnlockAmount(_ amount: Int) {
        if GameData.sharedGameData.getSelectedCharacterData().hasFreeRejuvenations() {
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
        let title = "ClickedToBuyReviveWithGems"
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "cont" as NSObject
            ])
        
        self.setScale(1)
        
        // Remove the current animation
        (self.dbScene as! GameScene).setRejuvDialogDisplayed()
        
        if GameData.sharedGameData.getSelectedCharacterData().hasFreeRejuvenations() {
            // Reduce free rejuvenation
            GameData.sharedGameData.getSelectedCharacterData().useFreeRejuvenation()
            //GameData.sharedGameData.save()
            
            // Rejuvenate the player for free
            self.purchaseRejuvenate(false)
        } else {
            if self.unlockAmount <= GameData.sharedGameData.totalDiamonds { // Unlock it
                self.purchaseRejuvenate(true)
            } else {
                let title = "ClickedToBuyReviveWithGemsAndDidntHaveGems"
                FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                    kFIRParameterItemID: "id-\(title)" as NSObject,
                    kFIRParameterItemName: title as NSObject,
                    kFIRParameterContentType: "cont" as NSObject
                    ])
                
                // If the user does not have enough gems, show purchase menu
                // Need weak reference to prevent retain cycle
                let onSuccessPurchase: (Bool) -> Void = {[weak self] (flag: Bool) in self!.purchaseRejuvenate(flag)}
                // Need weak reference to prevent retain cycle
                let onFailedPurchase: () -> Void = {[weak self] in self!.dismissRejuvenate()}
                self.dbScene!.showPurchaseMenu(true, itemCost: self.unlockAmount, onSuccess: onSuccessPurchase, onFailure: onFailedPurchase)
                
                // TODO when purchase menu is dismissed and gems were not purchased, reset timer action and do 3 second wait + dismiss
                // TODO when purchase menu is dismissed if gems were purchased, rejuvenate player and remove dialog through 1 sec slideout
            }
        }
    }
    
    func purchaseRejuvenate(_ useGems: Bool) -> Void {
        if useGems {
            let title = "PurchasedRejuvForGems-\(self.unlockAmount)"
            FIRAnalytics.logEvent(withName: kFIREventSpendVirtualCurrency, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            
            GameData.sharedGameData.totalDiamonds = GameData.sharedGameData.totalDiamonds - self.unlockAmount
            
            // Rejuvenate player and remove dialog through 1 sec slideout
            (self.dbScene as! GameScene).rejuvenatePlayer()
            
            // Save data
            //GameData.sharedGameData.save()
        } else {
            let title = "ClickedToBuyReviveWithGemsAndHadFreeRejuv"
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            
            // Rejuvenate player and remove dialog through 1 sec slideout
            (self.dbScene as! GameScene).rejuvenatePlayer()
        }
        
        return
    }
    
    func dismissRejuvenate() -> Void {
        // Completely dismiss rejuvenate - this happens if you just call the rejuvenateplayer on the gamescene
        /* Let's not do anything if the video watching fails.. let them try another option and close manually */
        //(self.dbScene as! GameScene).dismissRejuvDialogWaitAndEndLevel()
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }
}
