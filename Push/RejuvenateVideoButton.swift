//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(RejuvenateVideoButton)
class RejuvenateVideoButton : DBButton {
    var gemIcon: SKSpriteNode
    var amount: LabelWithShadow
    
    var gemIconScale: CGFloat = 1.325
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    init(scene: GameScene) {
        // Create display objects
        self.gemIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxGameAtlas.textureNamed("movie"))
        self.gemIcon.setScale(self.gemIconScale)
        
        self.amount = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.amount.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        
        super.init(buttonSize: DBButtonSize.square_Large, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
        
        // Setup amount
        self.amount.setFontSize(round(36 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.amount.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        self.amount.setText("free")
        
        let height = self.gemIcon.size.height + self.amount.calculateAccumulatedFrame().size.height + self.nodeBuffer
        self.gemIcon.position = CGPoint(x: 0, y: height / 2 - self.gemIcon.size.height / 2)
        self.amount.position = CGPoint(x: 0, y: -height / 2 + self.amount.calculateAccumulatedFrame().size.height / 2)
        
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
        
        // Remove the current animation
        (self.dbScene as! GameScene).setRejuvDialogDisplayed()
        // Store on the app delegate that we're going to try to load something
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.presentingVideo = true
        self.dbScene!.viewController!.showRewardedVideo()
        
        // Start loading screen
        self.dbScene!.startLoadingOverlay()
        
        self.forceDisabled = true
        self.checkDisabled()
    }
    
    override func touchesReleasedAction() {
        self.setScale(1)
    }
}
