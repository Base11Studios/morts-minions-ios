//
//  TradeGemsForStarsButton.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 10/6/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation
import FirebaseAnalytics

@objc(TradeGemsForStarsButton)
class TradeGemsForStarsButton : DBButton {
    var unlockAmount: Int
    var reward: Int
    var type: String
    
    var gemIcon: SKSpriteNode
    var gemAmount: LabelWithShadow
    
    var rewardIcon: SKSpriteNode
    var rewardAmount: LabelWithShadow
    
    var tradeIcon: SKSpriteNode
    
    var gemIconScale: CGFloat = 0.825
    var buffer: CGFloat = 6.0
    var buttonBuffer: CGFloat
    
    init(scene: DBScene, amount: Int, cost: Int, type: String) {
        self.unlockAmount = cost
        self.reward = amount
        self.type = type
        self.buttonBuffer = ScaleBuddy.sharedInstance.getNodeBuffer()
        
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.rewardIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed(self.type))
        self.rewardIcon.setScale(self.gemIconScale)
        
        self.tradeIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("trade_icon"))
        //self.tradeIcon.setScale(self.gemIconScale)
        
        self.gemAmount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: true, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.gemAmount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.gemAmount.setFontSize(round(34 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.gemAmount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        self.rewardAmount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: true, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.rewardAmount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.rewardAmount.setFontSize(round(34 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.rewardAmount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        super.init(buttonSize: DBButtonSize.large, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        
        // Setup amount
        
        self.updateUnlockAmount(self.unlockAmount)
        
        self.addChild(self.gemIcon)
        self.addChild(self.gemAmount)
        self.addChild(self.rewardIcon)
        self.addChild(self.rewardAmount)
        self.addChild(self.tradeIcon)
    }
    
    func updateUnlockAmount(_ amount: Int) {
        self.unlockAmount = amount
        self.gemAmount.setText("\(self.unlockAmount)")
        self.rewardAmount.setText("\(self.reward)")
        
        let topTotalWidth = self.gemIcon.size.width + self.gemAmount.calculateAccumulatedFrame().size.width + self.rewardIcon.size.width + self.rewardAmount.calculateAccumulatedFrame().size.width + self.tradeIcon.size.width + self.buttonBuffer
        
        self.gemAmount.position = CGPoint(x: -(topTotalWidth / 2 - self.gemAmount.calculateAccumulatedFrame().size.width / 2), y: 0)
        self.gemIcon.position = CGPoint(x: self.gemAmount.position.x + self.gemAmount.calculateAccumulatedFrame().size.width / 2 + self.gemIcon.size.width / 2, y: 0)
        
        self.tradeIcon.position = CGPoint(x: self.gemIcon.position.x + self.gemIcon.size.width / 2 + self.tradeIcon.size.width / 2 + self.buttonBuffer/2, y: 0)
        
        self.rewardAmount.position = CGPoint(x: self.tradeIcon.position.x + self.tradeIcon.size.width / 2 + self.rewardAmount.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer/2, y: 0)
        self.rewardIcon.position = CGPoint(x: self.rewardAmount.position.x + self.rewardAmount.calculateAccumulatedFrame().size.width / 2 + self.rewardIcon.size.width / 2, y: 0)
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
        
        let title = "ClickBuyStarsForGems"
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "cont" as NSObject
            ])

        if self.unlockAmount <= GameData.sharedGameData.totalDiamonds { // Unlock it
            let title = "HadGemsToBuyStars"
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            
            self.purchaseStars(ugh: false)
        } else {
            let title = "DidntHaveGemsToBuyStars"
            FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
                kFIRParameterItemID: "id-\(title)" as NSObject,
                kFIRParameterItemName: title as NSObject,
                kFIRParameterContentType: "cont" as NSObject
                ])
            
            
            // If the user does not have enough gems, show purchase menu
            // Need weak reference to prevent retain cycle
            //let onSuccessPurchase: (Bool) -> Void = {[weak self] (ugh: Bool) in self!.purchaseStars(ugh: ugh)}
            self.dbScene!.showPurchaseMenu(true, itemCost: self.unlockAmount, onSuccess: {_ in }, onFailure: {}) // TODO REJUV
        }
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }
    
    func purchaseStars(ugh: Bool) -> Void {
        if self.unlockAmount <= GameData.sharedGameData.totalDiamonds { // Unlock it
            GameData.sharedGameData.totalDiamonds = GameData.sharedGameData.totalDiamonds - self.unlockAmount
            
            // Give the reward
            if self.type == "star" {
                GameData.sharedGameData.getSelectedCharacterData().purchasedStars += self.reward
            } else if self.type == "superstar" {
                GameData.sharedGameData.getSelectedCharacterData().purchasedSuperstars += self.reward
            }
            
            // Save data
            GameData.sharedGameData.save()
            
            // Update gem counts
            self.dbScene!.updateGemCounts()
        }
    }
}
