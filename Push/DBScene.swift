//
//  DBScene.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 2/18/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class DBScene : SKScene {
    weak var viewController: GameViewController?
    
    /// ** IAPs
    var purchaseMenu: PurchaseMenu?
    // This list of available in-app purchases
    var products = [SKProduct]()
    
    // Rate me
    var rateMeDialog: RateMeDialog?
    
    // We need to be able to stop gesture recognizers in the background, so all grs should be added to this
    var gestureRecognizers = Array<UIGestureRecognizer>()
    
    // Loading overlay
    var loadingOverlay: LoadingOverlay?
    
    // Cloud data question dialog
    var cloudDataDialog: CloudDataDialog?
    
    // TODO on deinit stop the observer
    
    // Settings
    var settingsMenu: SettingsMenu?
    
    // Tutorials
    var uxTutorialTooltips: Array<UXTutorialDialog>? = Array<UXTutorialDialog>()
    
    // Credits
    var credits: DBSceneDialog?
    
    // Tutorial callback (default)
    var onCompleteUxTooltip: (() -> Void)? = {}
    
    init(size: CGSize, settings: Bool, loadingOverlay: Bool, purchaseMenu: Bool, rateMe: Bool) {
        super.init(size: size)
        
        // Need weak reference to prevent retain cycle
        self.onCompleteUxTooltip = {[weak self] in self!.displayTutorialTooltip()}
        
        self.cloudDataDialog = CloudDataDialog(frameSize: size, scene: self)
        self.cloudDataDialog!.zPosition = 50
        self.cloudDataDialog!.isHidden = true
        self.addChild(self.cloudDataDialog!)
        
        if settings {
            self.initializeSettingsMenu()
        }
        if loadingOverlay {
            self.initializeLoadingOverlay()
        }
        if purchaseMenu {
            self.initializePurchaseMenu()
        }
        if rateMe {
            self.initializeRateMeDialog()
        }
    }
    
    func initializeSettingsMenu() {
        self.settingsMenu = SettingsMenu(frameSize: size, scene: self)
        self.settingsMenu!.zPosition = 100
        self.settingsMenu!.isHidden = true
        self.addChild(self.settingsMenu!)
    }
    
    func initializePurchaseMenu() {
        self.purchaseMenu = PurchaseMenu(frameSize: size, scene: self)
        self.purchaseMenu!.zPosition = 20
        self.purchaseMenu!.isHidden = true
        self.addChild(self.purchaseMenu!)
    }
    
    func initializeRateMeDialog() {
        self.rateMeDialog = RateMeDialog(frameSize: size, scene: self)
        self.rateMeDialog!.zPosition = 100
        self.rateMeDialog!.isHidden = true
        self.addChild(self.rateMeDialog!)
    }
    
    func initializeLoadingOverlay() {
        self.loadingOverlay = LoadingOverlay(frameSize: size)
        self.loadingOverlay!.zPosition = 100
        self.loadingOverlay!.isHidden = true
        self.addChild(self.loadingOverlay!)
    }
    
    override func didMove(to view: SKView) {
        // Subscribe to a notification that fires when a product is purchased.
        NotificationCenter.default().addObserver(self, selector: #selector(DBScene.productPurchased(_:)), name: IAPHelperProductPurchasedNotification, object: nil)
        
        // Subscribe to a notification that fires when a product purchase is cancelled.
        NotificationCenter.default().addObserver(self, selector: #selector(DBScene.productPurchaseFailed(_:)), name: IAPHelperProductPurchaseFailedNotification, object: nil)
    }
    
    override func willMove(from view: SKView) {
        NotificationCenter.default().removeObserver(self, name: NSNotification.Name(rawValue: IAPHelperProductPurchasedNotification), object: nil)
        NotificationCenter.default().removeObserver(self, name: NSNotification.Name(rawValue: IAPHelperProductPurchaseFailedNotification), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayTutorialTooltip() -> Void {
    }
    
    func showPurchaseMenu(_ openedWithNotEnoughGems: Bool, itemCost: Int, onSuccess: (Bool) -> Void, onFailure: () -> Void) {
        
        // Load a spinner
        self.startLoadingOverlay()
        
        // Update the gem display
        self.purchaseMenu!.updateGemCounts()
        
        // First
        products = []
        IAPProducts.store.requestProductsWithCompletionHandler { success, products in
            self.products = products
            
            // Update the menu and display it
            self.purchaseMenu!.updateHeader(openedWithNotEnoughGems, errorConnecting: !success, itemCost: itemCost)
            self.purchaseMenu!.updateFooter()
            
            // TODO
            // Update products after header because produc avail might change header. Maybe that 1 function should do header and footer too
            self.purchaseMenu!.updateProductAvailability(products)
            self.purchaseMenu!.displayPurchaseMenu(itemCost, onSuccess: onSuccess, onFailure: onFailure)
            
            // Remove loading
            self.stopLoadingOverlay()
            
            for gesture in self.gestureRecognizers {
                gesture.isEnabled = false
            }
        }
    }
    
    func hidePurchaseMenu() {
        self.purchaseMenu!.isHidden = true
        
        for gesture in self.gestureRecognizers {
            gesture.isEnabled = true
        }
        
        self.purchaseMenu!.dismissPurchaseMenu()
    }
    
    // When a product is purchased, this notification fires -> Here we want to add the proper permissions and give gems
    func productPurchased(_ notification: Notification) {
        // Record gems purchased
        var gemsPurchased: Int = 0
        
        let productIdentifier = notification.object as! String
        for (_, product) in products.enumerated() {
            if product.productIdentifier == productIdentifier {
                gemsPurchased = IAPProducts.getProductGems(productIdentifier)
                GameData.sharedGameData.totalDiamonds = GameData.sharedGameData.totalDiamonds + gemsPurchased
                
                // Unlock ads
                if GameData.sharedGameData.adsUnlocked == false {
                    GameData.sharedGameData.adsUnlocked = true
                }
                
                // Save the game data
                GameData.sharedGameData.save()
                
                break
            }
        }
        
        // We need to update the gems on the screen
        self.updateGemCounts() // TODO implemnt on children scenes and call parent
        
        self.purchaseMenu!.updateHeaderPaymentSuccess(gemsPurchased)
        
        // TODO is there a way to select the proper heart boost now? For now can let the user do it
        
        // Remove loading
        self.stopLoadingOverlay()
    }
    
    // When a product purchase fails
    func productPurchaseFailed(_ notification: Notification) {
        let failReason = notification.object as! Int
        
        if failReason != SKErrorCode.paymentInvalid.rawValue {
            // TODO if failed because of error, show message in header
            self.purchaseMenu!.updateHeaderPaymentError()
            
        } // If failed because of user cancel, don't update header
        
        // Remove loading
        self.stopLoadingOverlay()
    }
    
    func updateGemCounts() {
        purchaseMenu?.updateGemCounts()
    }
    
    func startLoadingOverlay() {
        self.loadingOverlay!.isHidden = false
        self.loadingOverlay!.activate()
    }
    
    func stopLoadingOverlay() {
        self.loadingOverlay!.isHidden = true
        self.loadingOverlay!.deactivate()
    }
    
    // We want to ask the user if they want to load from cloud data
    func presentUserWithOptionToLoadCloudData() {
        // Pause the game by calling the common pause function
        self.pauseGame()
        
        // Create the dialog which will prompt them. Add the dialog to the scene.
        self.cloudDataDialog!.isHidden = false
        self.cloudDataDialog!.reset()
    }
    
    func presentUserWithRateMeDialog() {
        self.rateMeDialog!.isHidden = false
    }
    
    func hideRateMeMenu() {
        self.rateMeDialog!.isHidden = true
    }
    
    func keepLoadedLocalData() {
        // All we need to do is hide the dialog
        self.cloudDataDialog!.isHidden = true
        
        // We dont need to store the cloud data anymore
        GameData.sharedGameData.unarchivedCloudData = nil
    }
    
    func reloadDataFromCloud() {
        if self.viewController != nil && self.viewController?.isReloading == false {
            self.viewController?.isReloading = true
            
            // Hide the dialog
            self.cloudDataDialog?.isHidden = true

            // We need to call the reset data function on our controller
            self.viewController?.reloadData(GameData.sharedGameData.unarchivedCloudData!)
        }
    }
    
    func pauseGame() {
        // This can be overridden by scenes that need special logic
    }
    
    func unpauseGame() {
        // This can be overridden by scene that need special logic
    }
    
    func hasOwnMusic() -> Bool {
        return false
    }
    
    func impactsMusic() -> Bool {
        return true
    }
    
    func showSettingsMenu(_ show: Bool) {
        if show {
            self.settingsMenu!.isHidden = false
        } else {
            self.settingsMenu!.isHidden = true
        }
    }
    
    func initializeCredits() {
        self.credits = DBSceneDialog(title: "credits", description: "game created by Dan Bellinski", descriptionSize: 18, description2: "thanks to my wife, Megan, for inspiration", description3: "thanks to my beta testers: Brett, Eric, Tyler, Ryan, A.J., Jason, Megan, Rita, Kim, Chris, Kas, Neehar and everyone else", description4: "© 2016 Base11 Studios, Ltd", frameSize: self.size, scene: self, iconTexture: GameTextures.sharedInstance.buttonAtlas.textureNamed("trophygold"))
        self.credits!.zPosition = 30
        self.addChild(self.credits!)
    }
    
    func displayCredits() {
        self.credits!.isHidden = false
    }
}
