//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class PurchaseMenu: DialogBackground {
    var buy1Button: IAPPurchaseGemsButton
    var buy2Button: IAPPurchaseGemsButton
    var buy3Button: IAPPurchaseGemsButton
    var buy4Button: IAPPurchaseGemsButton
    
    var backButton: IAPPurchaseBackButton
    
    var headerText: DSMultilineLabelNode?
    var footerText: DSMultilineLabelNode?
    
    var totalGemsText: LabelWithShadow
    var totalGemsIcon: SKSpriteNode
    
    var title: SKLabelNode
    
    // Sizing and Positioning helpers
    var totalWidth: CGFloat?
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
        self.buy1Button = IAPPurchaseGemsButton(scene: scene, amount: IAPProducts.getProductGems(IAPProducts.GemA), cost: "N/A", product: IAPProducts.GemA)
        self.buy2Button = IAPPurchaseGemsButton(scene: scene, amount: IAPProducts.getProductGems(IAPProducts.GemB), cost: "N/A", product: IAPProducts.GemB)
        self.buy3Button = IAPPurchaseGemsButton(scene: scene, amount: IAPProducts.getProductGems(IAPProducts.GemC), cost: "N/A", product: IAPProducts.GemC)
        self.buy4Button = IAPPurchaseGemsButton(scene: scene, amount: IAPProducts.getProductGems(IAPProducts.GemD), cost: "N/A", product: IAPProducts.GemD)
        
        self.backButton = IAPPurchaseBackButton(scene: scene)
        
        self.totalGemsText = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.totalGemsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem_blue"))
        
        self.title = SKLabelNode(fontNamed: "Avenir-Medium")
        
        self.headerText = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.footerText = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        
        self.buffer = 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        super.init(frameSize: frameSize)
        
        let buttonAndBufferWidth = self.buy2Button.size.width / 2 + buffer / 2
        let buttonAndBufferHeight = self.buy2Button.size.height / 2 + buffer / 2
        self.totalWidth = self.buy2Button.size.width * 2 + buffer
        
        self.buy1Button.position = CGPoint(x: -buttonAndBufferWidth, y: buttonAndBufferHeight)
        self.buy2Button.position = CGPoint(x: buttonAndBufferWidth, y: buttonAndBufferHeight)
        self.buy3Button.position = CGPoint(x: -buttonAndBufferWidth, y: -buttonAndBufferHeight)
        self.buy4Button.position = CGPoint(x: buttonAndBufferWidth, y: -buttonAndBufferHeight)
        
        // Header and footer
        // Header
        self.headerText!.paragraphWidth = self.buy2Button.size.width * 2 + buffer
        self.headerText!.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.headerText!.fontColor = MerpColors.darkFont
        self.headerText!.text = "Accelerate your experience. Buy gems to unlock characters and use revives."
        self.headerText!.position = CGPoint(x: (-self.totalWidth! + self.headerText!.calculateAccumulatedFrame().size.width) / 2, y: self.buy1Button.position.y + self.buy1Button.size.height / 2 + self.headerText!.calculateAccumulatedFrame().size.height / 2 + self.buffer)
        
        // Footer
        self.footerText!.paragraphWidth = self.buy2Button.size.width * 2 + buffer
        self.footerText!.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.footerText!.fontColor = MerpColors.darkFont
        
        if GameData.sharedGameData.adsUnlocked {
            self.footerText!.text = "Thank you for your previous purchase! We won't show static ads."
        } else {
            self.footerText!.text = "* If you purchase any gems, we won't show static ads."
        }
        self.footerText!.position = CGPoint(x: (-self.totalWidth! + self.footerText!.calculateAccumulatedFrame().size.width) / 2, y: self.buy3Button.position.y - self.buy3Button.size.height / 2 - self.footerText!.calculateAccumulatedFrame().size.height / 2 - self.buffer)
        
        self.backButton.position = CGPoint(x: self.buy4Button.position.x + self.buy4Button.size.width / 2 - self.backButton.size.width / 2, y: self.footerText!.position.y - self.footerText!.calculateAccumulatedFrame().size.height / 2 - self.backButton.size.height / 2 - self.buffer)
        
        // Gem icon
        self.totalGemsIcon.setScale(0.74)
        
        // Gem label
        self.totalGemsText.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalGemsText.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalGemsText.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        // Title
        self.title.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.title.text = "Purchase Gems"
        self.title.fontColor = MerpColors.darkFont
        self.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        
        self.title.position = CGPoint(x: self.buy1Button.position.x - self.buy1Button.size.width / 2 + self.title.calculateAccumulatedFrame().size.width / 2, y: self.headerText!.position.y + self.headerText!.calculateAccumulatedFrame().size.height / 2 + self.title.calculateAccumulatedFrame().size.height / 2)
        
        // Diamonds label
        self.totalGemsText.setText("\(GameData.sharedGameData.totalDiamonds)")
        
        
        self.container.addChild(self.buy1Button)
        self.container.addChild(self.buy2Button)
        self.container.addChild(self.buy3Button)
        self.container.addChild(self.buy4Button)
        self.container.addChild(self.totalGemsIcon)
        self.container.addChild(self.totalGemsText)
        self.container.addChild(self.backButton)
        self.container.addChild(self.title)
        self.container.addChild(self.headerText!)
        self.container.addChild(self.footerText!)
        
        // Reset the container size
        self.resetContainerSize()
        
        // Diamonds icon
        self.totalGemsIcon.position = CGPoint(x: self.container.size.width / 2 - self.totalGemsIcon.size.width/2 - buffer, y: self.title.position.y + self.title.calculateAccumulatedFrame().size.height / 2)
        
        self.totalGemsText.position = CGPoint(x: self.totalGemsIcon.position.x - self.totalGemsIcon.size.width/2 - buffer/5, y: self.totalGemsIcon.position.y)
        
        // We want the background to stop clicks
        self.isUserInteractionEnabled = true
    }
    
    func updateHeader(_ openedWithNotEnoughGems: Bool, errorConnecting: Bool, itemCost: Int) {
        if !errorConnecting {
            if openedWithNotEnoughGems {
                self.headerFontColor(false)
                self.headerText!.text = "Darn, you need \(itemCost) gems to make the purchase. Buy more gems below."
            } else {
                self.headerFontColor(false)
                self.headerText!.text = "Accelerate your experience. Buy gems to unlock characters and use revives."
            }
        } else {
            if openedWithNotEnoughGems {
                self.headerFontColor(true)
                self.headerText!.text = "Darn, you need \(itemCost) gems. We could not connect to the store. Try again."
            } else {
                self.headerFontColor(true)
                self.headerText!.text = "Unfortunately we could not connect to the store. Please try again."
            }
        }
        
        self.resetHeaderPosition()
    }
    
    func updateHeaderPaymentError() {
        self.headerFontColor(true)
        self.headerText!.text = "We were unable to complete the payment transaction. Please try again."
        
        self.resetHeaderPosition()
    }
    
    func updateHeaderPaymentNotAllowed() {
        self.headerFontColor(true)
        self.headerText!.text = "Unfortunately your apple ID is not allowed to make payments."
        
        self.resetHeaderPosition()
    }
    
    func updateHeaderPaymentNoProducts() {
        self.headerFontColor(true)
        self.headerText!.text = "No products are available for purchase at this time. Try again later."
        
        self.resetHeaderPosition()
    }
    
    func updateHeaderPaymentSuccess(_ gemsPurchased: Int) {
        self.headerFontColor(false)
        self.headerText!.text = "Successfuly purchased \(gemsPurchased) gems. Thank you for your purchase!"
        
        self.resetHeaderPosition()
    }
    
    func headerFontColor(_ isError: Bool) {
        if isError {
            if self.headerText!.fontColor == MerpColors.darkFont {
                self.headerText!.fontColor = MerpColors.merpRed
            }
        } else {
            if self.headerText!.fontColor == MerpColors.merpRed {
                self.headerText!.fontColor = MerpColors.darkFont
            }
        }
    }
    
    func resetHeaderPosition() {
        self.headerText!.position = CGPoint(x: (-self.totalWidth! + self.headerText!.calculateAccumulatedFrame().size.width) / 2, y: self.buy1Button.position.y + self.buy1Button.size.height / 2 + self.headerText!.calculateAccumulatedFrame().size.height / 2 + self.buffer)
    }

    func updateFooter() {
        // Footer
        if GameData.sharedGameData.adsUnlocked {
            self.footerText!.text = "Thank you for your previous purchase! We won't show static ads."
        } else {
            self.footerText!.text = "* if you purchase any gems, we won't show static ads."
        }
        self.footerText!.position = CGPoint(x: (-self.totalWidth! + self.footerText!.calculateAccumulatedFrame().size.width) / 2, y: self.buy3Button.position.y - self.buy3Button.size.height / 2 - self.footerText!.calculateAccumulatedFrame().size.height / 2 - self.buffer)
    }
    
    func updateGemCounts() {
        self.totalGemsText.setText("\(GameData.sharedGameData.totalDiamonds)")
    }
    
    func updateProductAvailability(_ products: [SKProduct]) {
        // Disable all buttons
        self.disableAllButtons()
        
        // Determine if we found a product
        var atLeastOneProduct: Bool = false
        
        // Determine if the user can buy IAPs
        let userCanBuyFromIAP: Bool = IAPHelper.canMakePayments()
        
        // If the user can't buy from the store
        if !userCanBuyFromIAP {
            self.updateHeaderPaymentNotAllowed()
        } else {
            // Try to enable buttons if the product is available
            for product in products {
                if product.productIdentifier == self.buy1Button.product {
                    atLeastOneProduct = true
                    self.disableButton(self.buy1Button, disable: false)
                    
                    // Update currency
                    priceFormatter.locale = product.priceLocale
                    buy1Button.updateCost(priceFormatter.string(from: product.price)!)
                } else if product.productIdentifier == self.buy2Button.product {
                    atLeastOneProduct = true
                    self.disableButton(self.buy2Button, disable: false)
                    
                    // Update currency
                    priceFormatter.locale = product.priceLocale
                    buy2Button.updateCost(priceFormatter.string(from: product.price)!)
                } else if product.productIdentifier == self.buy3Button.product {
                    atLeastOneProduct = true
                    self.disableButton(self.buy3Button, disable: false)
                    
                    // Update currency
                    priceFormatter.locale = product.priceLocale
                    buy3Button.updateCost(priceFormatter.string(from: product.price)!)
                } else if product.productIdentifier == self.buy4Button.product {
                    atLeastOneProduct = true
                    self.disableButton(self.buy4Button, disable: false)
                    
                    // Update currency
                    priceFormatter.locale = product.priceLocale
                    buy4Button.updateCost(priceFormatter.string(from: product.price)!)
                }
            }
        }
        
        if atLeastOneProduct {
            // TODO If only some products are available, update header info to indicate so.
            
        } else {
            // No products available
            self.updateHeaderPaymentNoProducts()
        }
    }
    
    func disableAllButtons() {
        self.disableButton(self.buy1Button, disable: true)
        self.disableButton(self.buy2Button, disable: true)
        self.disableButton(self.buy3Button, disable: true)
        self.disableButton(self.buy4Button, disable: true)
    }
    
    func disableButton(_ button: IAPPurchaseGemsButton, disable: Bool) {
        if disable {
            button.isDisabled = true
        } else {
            button.isDisabled = false
        }
        button.checkDisabled()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayPurchaseMenu(_ itemCost: Int, onSuccess: (Bool)->Void, onFailure: ()->Void) {
        self.isHidden = false
        self.itemCost = itemCost
        
        // Store completion handlers
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    func dismissPurchaseMenu() {
        self.isHidden = true
        
        // Determine if we purchased what was needed
        if GameData.sharedGameData.totalDiamonds >= self.itemCost {
            // Call the success handler
            self.onSuccess!(true)
        } else {
            self.onFailure!()
        }
    }
}
