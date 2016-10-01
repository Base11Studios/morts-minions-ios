//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class RejuvDialog: DialogBackground {

    // Rejuv Buttons
    var rejuvGemsButton: RejuvenateGemButton?
    var rejuvVideoButton: RejuvenateVideoButton?
    
    // Gem Container
    var gemContainer: GemContainer
    
    // Other items
    var titleNode: DSMultilineLabelNode?
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
    
        self.titleNode?.paragraphWidth = self.container.size.width - self.buttonBuffer - self.iconBackgroundNode!.size.width
        self.titleNode?.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.titleNode?.fontColor = MerpColors.darkFont
        self.titleNode?.text = "Revive?"
        
        self.rejuvGemsButton = RejuvenateGemButton(scene: scene, unlockAmount: gemCost)
        self.rejuvVideoButton = RejuvenateVideoButton(scene: scene)
        
        self.container.addChild(self.iconBackgroundNode!)
        self.iconBackgroundNode!.addChild(self.iconNode!)
        self.container.addChild(self.rejuvGemsButton!)
        self.container.addChild(self.rejuvVideoButton!)
        self.container.addChild(self.gemContainer)
        
        let height = self.iconBackgroundNode!.size.height + self.rejuvGemsButton!.calculateAccumulatedFrame().size.height + self.buttonBuffer * 1
        let width = max(self.rejuvGemsButton!.size.width + self.rejuvVideoButton!.size.width + self.buttonBuffer, self.iconBackgroundNode!.size.width + self.buttonBuffer / 2 + self.titleNode!.calculateAccumulatedFrame().size.width)
        
        self.iconBackgroundNode?.position = CGPoint(x: width / -2 + self.iconBackgroundNode!.size.width / 2, y: height / 2 - self.iconBackgroundNode!.size.height / 2)
        
        self.titleNode!.position = CGPoint(x: self.iconBackgroundNode!.position.x + self.iconBackgroundNode!.size.width / 2 + self.titleNode!.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer / 2, y: height / 2 - self.titleNode!.calculateAccumulatedFrame().size.height / 2)
        
        // Gem container is opposite side of title
        self.gemContainer.position = CGPoint(x: (width / 2) - self.gemContainer.calculateAccumulatedFrame().size.width / 2, y: self.titleNode!.position.y - self.gemContainer.size.height / 2)
        
        self.rejuvGemsButton!.position = CGPoint(x: -self.rejuvGemsButton!.size.width / 2 - self.buttonBuffer / 2, y: self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer - self.rejuvGemsButton!.calculateAccumulatedFrame().size.height / 2)
        
        self.rejuvVideoButton!.position = CGPoint(x: self.rejuvVideoButton!.size.width / 2 + self.buttonBuffer / 2, y: self.iconBackgroundNode!.position.y - self.iconBackgroundNode!.size.height / 2 - self.buttonBuffer - self.rejuvVideoButton!.calculateAccumulatedFrame().size.height / 2)
        
        // Reset the container size
        self.resetContainerSize()
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleRejuvVideo() {
        if !self.dbScene!.viewController!.videoAdReady() || GameData.sharedGameData.getSelectedCharacterData().hasFreeRejuvenations() {
            self.rejuvVideoButton!.forceDisabled = true
            self.rejuvVideoButton!.checkDisabled()
        }
    }
}
