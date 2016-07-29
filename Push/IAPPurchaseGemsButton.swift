//
//  CharactePurchaseSkillButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(IAPPurchaseGemsButton)
class IAPPurchaseGemsButton : DBButton {
    var product: String
    
    var gemIcon: SKSpriteNode
    var amount: LabelWithShadow
    var cost: SKLabelNode
    
    var unlockAmount: Int
    var unlockCost: String
    
    var gemIconScale: CGFloat = 0.65
    var buffer: CGFloat = 10.0
    
    init(scene: DBScene, amount: Int, cost: String, product: String) {
        self.unlockAmount = amount
        self.unlockCost = cost
        self.product = product
        
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.amount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: true, borderSize: 0.80 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.amount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        
        self.cost = SKLabelNode(fontNamed: "Avenir-Medium")
        self.cost.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        super.init(buttonSize: DBButtonSize.medium, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        
        // Setup amount
        self.amount.setFontSize(round(23 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.amount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.amount.setText("\(self.unlockAmount)")
        
        // Setup cost
        self.cost.fontSize = round(16 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.cost.fontColor = MerpColors.darkFont
        self.cost.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.cost.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.cost.text = self.unlockCost
        
        let topTotalWidth = self.gemIcon.size.width + buffer / 3 + self.amount.calculateAccumulatedFrame().size.width
        
        self.gemIcon.position = CGPoint(x: 0 + (topTotalWidth / 2 - self.gemIcon.size.width / 2), y: 0 + self.gemIcon.size.width / 2 + buffer / 4)
        self.amount.position = CGPoint(x: 0 - (topTotalWidth / 2 - self.amount.calculateAccumulatedFrame().size.width / 2), y: self.gemIcon.position.y)
        self.cost.position = CGPoint(x: 0, y: 0 - self.cost.calculateAccumulatedFrame().size.height / 2 - buffer / 2)
        
        self.addChild(self.gemIcon)
        self.addChild(self.amount)
        self.addChild(self.cost)
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
        
        // Start loading
        self.dbScene!.startLoadingOverlay()
        
        // Purchase the product
        IAPProducts.store.purchaseProduct(IAPProducts.getProductFromEnum(self.product, products: self.dbScene!.products)!)
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }

    override func checkDisabled() {
        super.checkDisabled()
    }
    
    func updateCost(_ cost: String) {
        self.unlockCost = cost
        self.cost.text = cost
        self.cost.position = CGPoint(x: 0, y: 0 - self.cost.calculateAccumulatedFrame().size.height / 2 - buffer / 2)
    }
}
