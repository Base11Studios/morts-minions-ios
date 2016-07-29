//
//  CharactePurchaseSkillButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/30/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GemContainer)
class GemContainer : DBButton {
    var gemIcon: SKSpriteNode
    var amount: LabelWithShadow
    
    var gemIconScale: CGFloat = 0.74
    var buffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    var loadsPurchaseMenu: Bool = false
    
    init(scene: DBScene, blueGem: Bool, loadsPurchaseMenu: Bool) {
        self.loadsPurchaseMenu = loadsPurchaseMenu
        
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed(blueGem ? "gem_blue" : "gem"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.amount = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        self.amount.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.amount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.amount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        super.init(dbScene: scene)
        
        self.updateAmount()
        self.addChild(self.gemIcon)
        self.addChild(self.amount)
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
        
        if loadsPurchaseMenu {
            // Start loading
            self.dbScene!.startLoadingOverlay()
        
            self.dbScene!.showPurchaseMenu(false, itemCost: 1, onSuccess: { (true) in }, onFailure: {() in })
        }
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }
    
    func updateAmount() {
        self.amount.setText("\(GameData.sharedGameData.totalDiamonds)")
        
        let topTotalWidth = self.gemIcon.size.width + buffer / 3 + self.amount.calculateAccumulatedFrame().size.width
        
        self.gemIcon.position = CGPoint(x: topTotalWidth / 2 - self.gemIcon.size.width / 2, y: 0)
        self.amount.position = CGPoint(x: self.gemIcon.position.x - self.gemIcon.size.width/2 - buffer/5, y: self.gemIcon.position.y)
    }
}
