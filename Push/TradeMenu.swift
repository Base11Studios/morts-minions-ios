//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class TradeMenu: DialogBackground {
    var buy1Button: TradeGemsForStarsButton
    //var buy2Button: TradeGemsForStarsButton
    
    var backButton: TradeBackButton
    
    var headerText: DSMultilineLabelNode?

    var totalGemsText: LabelWithShadow
    var totalGemsIcon: SKSpriteNode
    
    var totalStarsText: LabelWithShadow
    var totalStarsIcon: SKSpriteNode
    
    //var totalSuperstarsText: LabelWithShadow
    //var totalSuperstarsIcon: SKSpriteNode
    
    var title: SKLabelNode
    
    // Sizing and Positioning helpers
    var totalWidth: CGFloat?
    var totalHeight: CGFloat?
    var buffer: CGFloat
    
    // Item Cost
    var itemCost: Int = 0
    
    // Callbacks
    var onSuccess: ((Bool)-> Void)? = {Bool in}
    var onFailure: (()-> Void)? = {}
    
    // priceFormatter is used to show proper, localized currency
    lazy var priceFormatter: NumberFormatter = {
        let pf = NumberFormatter()
        pf.formatterBehavior = .behavior10_4
        pf.numberStyle = .currency
        return pf
    }()
    
    func defaultFunction(_ bool: Bool) -> Void {}
    
    init(frameSize : CGSize, scene: DBScene) {
        // Create the buttons
        self.buy1Button = TradeGemsForStarsButton(scene: scene, amount: 3, cost: 50, type: "star")
        //self.buy2Button = TradeGemsForStarsButton(scene: scene, amount: 1, cost: 50, type: "superstar")
        
        self.backButton = TradeBackButton(scene: scene)
        
        self.totalGemsText = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.totalGemsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        
        self.totalStarsText = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.totalStarsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
        
        //self.totalSuperstarsText = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        //self.totalSuperstarsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("superstar"))
        
        self.title = SKLabelNode(fontNamed: "Avenir-Medium")
        
        self.headerText = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)

        self.buffer = 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        super.init(frameSize: frameSize)
        
        
        // Gem icon
        self.totalGemsIcon.setScale(0.74)
        
        // Gem label
        self.totalGemsText.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalGemsText.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalGemsText.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.totalGemsText.setText("\(GameData.sharedGameData.totalDiamonds)")
        
        // Star icon
        self.totalStarsIcon.setScale(0.74)
        
        // Star label
        self.totalStarsText.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalStarsText.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalStarsText.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.totalStarsText.setText("\(GameData.sharedGameData.totalDiamonds)")
        
        /*
        // SS icon
        self.totalSuperstarsIcon.setScale(0.74)
        
        // SS label
        self.totalSuperstarsText.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalSuperstarsText.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalSuperstarsText.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.totalSuperstarsText.setText("\(GameData.sharedGameData.totalDiamonds)")
        */
        
        // Title
        self.title.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.title.text = "Trade Gems"
        self.title.fontColor = MerpColors.darkFont
        self.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        // Header and footer
        // Header
        self.headerText!.paragraphWidth = self.buy1Button.size.width + buffer
        self.headerText!.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.headerText!.fontColor = MerpColors.darkFont
        self.headerText!.text = "Use gems to boost " + CharacterType.getCharacterName(GameData.sharedGameData.selectedCharacter) + "'s stars and superstars."
        
        // Positioning
        let buttonAndBufferWidth = self.buy1Button.size.width / 2 + buffer / 2
        let buttonAndBufferHeight = self.buy1Button.size.height / 2 + buffer / 2
        self.totalWidth = self.buy1Button.size.width// + buffer
        self.totalHeight = self.buy1Button.size.height + self.backButton.size.height + self.title.calculateAccumulatedFrame().size.height + self.headerText!.calculateAccumulatedFrame().size.height + self.buttonBuffer * 3
        
        self.title.position = CGPoint(x: -buttonAndBufferWidth - self.buy1Button.size.width / 2 + self.title.calculateAccumulatedFrame().size.width / 2, y: self.totalHeight! / 2 - self.title.calculateAccumulatedFrame().size.height / 2)
        
        self.headerText!.position = CGPoint(x: (-self.totalWidth! + self.headerText!.calculateAccumulatedFrame().size.width) / 2, y: self.title.position.y - self.title.calculateAccumulatedFrame().size.height / 2 - self.headerText!.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer)
        
        self.buy1Button.position = CGPoint(x: -buttonAndBufferWidth, y: self.headerText!.position.y - self.headerText!.calculateAccumulatedFrame().size.height / 2 - self.buy1Button.size.height / 2 - self.buttonBuffer)
        //self.buy2Button.position = CGPoint(x: buttonAndBufferWidth, y: self.buy1Button.position.y)
        
        // Footer
        self.backButton.position = CGPoint(x: self.buy1Button.position.x + self.buy1Button.size.width / 2 - self.backButton.size.width / 2, y: self.buy1Button.position.y - self.buy1Button.size.height / 2 - self.backButton.size.height / 2 - self.buffer)
        
        self.container.addChild(self.buy1Button)
        //self.container.addChild(self.buy2Button)
        self.container.addChild(self.totalGemsIcon)
        self.container.addChild(self.totalGemsText)
        self.container.addChild(self.totalStarsIcon)
        self.container.addChild(self.totalStarsText)
        //self.container.addChild(self.totalSuperstarsIcon)
        //self.container.addChild(self.totalSuperstarsText)
        self.container.addChild(self.backButton)
        self.container.addChild(self.title)
        self.container.addChild(self.headerText!)
        
        self.updateGemCounts()
        
        // Reset the container size
        self.resetContainerSize()
        
        // We want the background to stop clicks
        self.isUserInteractionEnabled = true
    }
    
    func updateGemCounts() {
        self.totalGemsText.setText("\(GameData.sharedGameData.totalDiamonds)")
        self.totalStarsText.setText("\(GameData.sharedGameData.getSelectedCharacterData().unspentStars)")
        //self.totalSuperstarsText.setText("\(GameData.sharedGameData.getSelectedCharacterData().unspentCitrine)")
        
        // Diamonds icon
        self.totalStarsIcon.position = CGPoint(x: self.buy1Button.size.width / 2 + buffer / 2 + self.buy1Button.size.width / 2 - self.totalStarsIcon.size.width/2, y: self.title.position.y)
        
        self.totalStarsText.position = CGPoint(x: self.totalStarsIcon.position.x - self.totalStarsIcon.size.width/2 - buffer/5, y: self.totalStarsIcon.position.y)
        
        //self.totalSuperstarsIcon.position = CGPoint(x: self.totalStarsText.position.x - self.totalStarsText.calculateAccumulatedFrame().size.width / 2 - self.totalSuperstarsIcon.size.width/2 - self.buffer, y: self.title.position.y)
        
        //self.totalSuperstarsText.position = CGPoint(x: self.totalSuperstarsIcon.position.x - self.totalSuperstarsIcon.size.width/2 - buffer/5, y: self.totalSuperstarsIcon.position.y)
        
        self.totalGemsIcon.position = CGPoint(x: self.totalStarsText.position.x - self.totalStarsText.calculateAccumulatedFrame().size.width / 2 - self.totalGemsIcon.size.width/2 - self.buffer, y: self.title.position.y)
        
        self.totalGemsText.position = CGPoint(x: self.totalGemsIcon.position.x - self.totalGemsIcon.size.width/2 - buffer/5, y: self.totalGemsIcon.position.y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
