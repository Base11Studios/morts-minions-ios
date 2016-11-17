//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class HeartBoostDialog: DialogBackground {
    
    // heartBoost Buttons
    var heartBoostGemsButton: HeartBoostGemButton?
    var heartBoostVideoButton: HeartBoostVideoButton?
    var closeButton: HeartBoostCloseButton?
    
    // Gem Container
    var gemContainer: GemContainer
    
    // Other items
    var titleNode: DSMultilineLabelNode?
    var descriptionNode: DSMultilineLabelNode?
    var iconBackgroundNode: SKSpriteNode?
    var iconNode: SKSpriteNode?

    weak var dbScene: DBScene?
    
    init(frameSize : CGSize, scene: GameScene, gemCost: Int) {
        self.dbScene = scene
        
        self.gemContainer = GemContainer(scene: scene, blueGem: true, loadsPurchaseMenu: false)
        
        super.init(frameSize: frameSize)
        // Set the container size
        
        self.container.position = CGPoint(x: 0, y: 1)
        
        // Icon
        self.iconBackgroundNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_medium"))
        
        // Get the icon for this
        let iconTexture: SKTexture = GameTextures.sharedInstance.buttonAtlas.textureNamed("heartfilled_large")
        
        let widthRatio = iconTexture.size().width / iconBackgroundNode!.size.width
        let heightRatio = iconTexture.size().height / iconBackgroundNode!.size.height
        var adjustRatio: CGFloat
        
        if widthRatio > heightRatio {
            adjustRatio = widthRatio
        } else {
            adjustRatio = heightRatio
        }
        
        self.iconNode = SKSpriteNode(texture: iconTexture, color: SKColor(), size: CGSize(width: iconTexture.size().width / adjustRatio, height: iconTexture.size().height / adjustRatio))
        self.iconNode?.setScale(0.7)
        
        // Title and desc
        self.titleNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.titleNode!)
        self.descriptionNode = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.container.addChild(self.descriptionNode!)
        
        self.titleNode?.paragraphWidth = self.container.size.width - self.buttonBuffer - self.iconBackgroundNode!.size.width
        self.titleNode?.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.titleNode?.fontColor = MerpColors.darkFont
        self.titleNode?.text = "Heart Boost?"
        
        self.descriptionNode?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.descriptionNode?.fontColor = MerpColors.darkFont
        
        self.heartBoostGemsButton = HeartBoostGemButton(scene: scene, unlockAmount: gemCost)
        self.heartBoostVideoButton = HeartBoostVideoButton(scene: scene)
        self.closeButton = HeartBoostCloseButton(scene: scene)

        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        self.container.addChild(self.heartBoostGemsButton!)
        self.container.addChild(self.heartBoostVideoButton!)
        self.container.addChild(self.gemContainer)

        self.container.addChild(self.closeButton!)

        let width = max(self.heartBoostGemsButton!.size.width + self.heartBoostVideoButton!.size.width + self.buttonBuffer, self.iconBackgroundNode!.size.width + self.buttonBuffer / 2 + self.titleNode!.calculateAccumulatedFrame().size.width)
        
        self.descriptionNode?.paragraphWidth = width
        if GameData.sharedGameData.adsUnlocked {
            self.descriptionNode?.text = "Get 1 extra heart for 3 hours by watching a video or using gems."
        } else {
            self.descriptionNode?.text = "Get 1 extra heart for 1 hour by watching a video or using gems."
        }
        
        let height = self.iconBackgroundNode!.size.height + self.heartBoostGemsButton!.calculateAccumulatedFrame().size.height + self.buttonBuffer * 1 + /*self.videoCountdownBackground!.size.height +*/ self.buttonBuffer + self.closeButton!.size.height + self.descriptionNode!.calculateAccumulatedFrame().size.height
        
        self.iconBackgroundNode?.position = CGPoint(x: width / -2 + self.iconBackgroundNode!.size.width / 2, y: height / 2 - self.iconBackgroundNode!.size.height / 2)
        
        self.titleNode!.position = CGPoint(x: self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2, y: height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2)
        
        // Gem container is opposite side of title
        self.gemContainer.position = CGPoint(x: (width / 2) - self.gemContainer.calculateAccumulatedFrame().size.width / 2, y: self.titleNode!.position.y - self.gemContainer.size.height / 2)
        
        self.descriptionNode!.position = CGPoint(x: -width / 2 + self.descriptionNode!.calculateAccumulatedFrame().size.width / 2, y: self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2)
        
        self.heartBoostGemsButton!.position = CGPoint(x: self.heartBoostGemsButton!.size.width / 2 + self.buttonBuffer / 2, y: self.descriptionNode!.position.y - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer - self.heartBoostGemsButton!.calculateAccumulatedFrame().size.height / 2)
        
        self.heartBoostVideoButton!.position = CGPoint(x: -self.heartBoostVideoButton!.size.width / 2 - self.buttonBuffer / 2, y: self.descriptionNode!.position.y - self.descriptionNode!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer - self.heartBoostVideoButton!.calculateAccumulatedFrame().size.height / 2)
        
        self.closeButton!.position = CGPoint(x: self.heartBoostGemsButton!.position.x + (self.heartBoostGemsButton!.size.width - self.closeButton!.size.width) / 2, y: self.heartBoostGemsButton!.position.y - self.heartBoostGemsButton!.size.height / 2 - self.buttonBuffer / 2 - self.closeButton!.size.height / 2)
        
        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleheartBoostVideo() {
        if !self.dbScene!.viewController!.videoAdReady() || GameData.sharedGameData.getSelectedCharacterData().hasFreeHeartBoosts() {
            self.heartBoostVideoButton!.forceDisabled = true
            self.heartBoostVideoButton!.checkDisabled()
        }
    }
}
