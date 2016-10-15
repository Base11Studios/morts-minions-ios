//
//  CharacterSkillScene.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(CharacterSkillScene)
class CharacterSkillScene : DBScene {
    // Scene to return to
    var returnScene: DBScene
    
    var worldView: SKSpriteNode

    // Skill selector
    var scrollingNode: VerticalScrollingSkillNode?
    var skillSelector: SKSpriteNode?
    var skillSelectorBackground: SKSpriteNode?
    
    
    // Active skill
    var selectedSkillIcon: SKSpriteNode?
    var selectedSkillBackground: SKSpriteNode?
    var selectedSkillTitle: DSMultilineLabelNode?
    var selectedSkillDescription: DSMultilineLabelNode?
    var selectedSkillCost: LabelWithShadow?
    var selectedSkillCostIcon: SKSpriteNode?
    var selectedSkillCostIconTextureStar: SKTexture
    var selectedSkillCostIconTextureCitrine: SKTexture
    var selectedSkillErrorText: DSMultilineLabelNode?
    
    var totalUnspentStars: LabelWithShadow?
    //var totalUnspentCitrine: LabelWithShadow?
    var totalUnspentStarsIcon: SKSpriteNode?
    //var totalUnspentCitrineIcon: SKSpriteNode?
    var totalUnspentDiamonds: LabelWithShadow?
    var totalUnspentDiamondsIcon: SKSpriteNode?
    
    var backdropBar: SKSpriteNode
    var selectedSkillAreaFlag: SKSpriteNode?
    var flagAdjuster: CGFloat = 60.0
    
    // Buttons
    var buySkillButton: CharacterPurchaseSkillButton?
    var removeSkillButton: CharacterRemoveSkillButton?
    var resetSkillsButton: CharacterResetSkillsButton?
    var backButton: CharacterBackButton?
    var tradeButton: CharacterTradeButton?

    // Buffer
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    var bufferSize: CGFloat = 2
    
    // TODO fyi ths is hard coded in case buttons change
    var topButtonHeight: CGFloat = 33
    
    // Flag for scene just initialized
    var justInitialized: Bool = true
    var needsUpdated: Bool = true
    
    init(size: CGSize, returnScene: DBScene) {
        self.returnScene = returnScene
        
        // Setup buffer size
        self.bufferSize = floor(ScaleBuddy.sharedInstance.getScaleAmount() * 2.0)
        
        self.selectedSkillCostIconTextureStar = GameTextures.sharedInstance.buttonAtlas.textureNamed("star")
        self.selectedSkillCostIconTextureCitrine = GameTextures.sharedInstance.buttonAtlas.textureNamed("superstar")
        
        // World selector view ( this is the background & parent that everything is added to)
        self.worldView = SKSpriteNode(color: MerpColors.background, size: size)
        
        // Init stuff
        self.backdropBar = SKSpriteNode(texture: SKTexture(imageNamed: "backdrop_bar"))
        
        // Call super init
        super.init(size: size, settings: false, loadingOverlay: true, purchaseMenu: true, rateMe: false, trade: true)
        
        // Level selector view ( this is the background & parent that everything is added to)
        self.skillSelectorBackground = ScaleBuddy.sharedInstance.getScreenAdjustedSpriteWithModifier("skill_prop_outline", textureAtlas: GameTextures.sharedInstance.uxMenuAtlas, modifier: 2.4)
        self.skillSelector = SKSpriteNode(color: MerpColors.background, size: CGSize(width: self.skillSelectorBackground!.size.width - nodeBuffer * 1.5, height: self.skillSelectorBackground!.size.height - nodeBuffer * 1.3))
        
        //self.skillSelectorBackground = SKSpriteNode(color: UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 60 / 255.0, alpha: 1.0), size: CGSizeMake(self.skillSelector!.size.width + self.nodeBuffer * 2, self.skillSelector!.size.height + self.nodeBuffer * 2))
        
        self.scrollingNode = VerticalScrollingSkillNode(size: self.skillSelector!.size, scene: self)
        
        // Center the "camera"
        self.worldView.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        self.addChild(self.worldView)
        
        self.backgroundColor = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
        
        // Level Selector
        self.initSkillSelector()
        
        // Reset skills button... using the height for alignment of other elements
        self.resetSkillsButton = CharacterResetSkillsButton(scene: self)
        self.backButton = CharacterBackButton(scene: self)
        self.tradeButton = CharacterTradeButton(scene: self)
        
        self.buySkillButton = CharacterPurchaseSkillButton(scene: self)
        self.removeSkillButton = CharacterRemoveSkillButton(scene: self)
        self.selectedSkillTitle = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: self)
        self.selectedSkillDescription = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: self)
        self.selectedSkillErrorText = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: self)
        self.selectedSkillCost = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: true)
        self.selectedSkillCostIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
        self.selectedSkillCostIcon?.setScale(0.65)
        
        self.totalUnspentStars = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        self.totalUnspentDiamonds = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        //self.totalUnspentCitrine = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        //self.totalUnspentCitrineIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("superstar"))
        self.totalUnspentStarsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
        self.totalUnspentDiamondsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem"))
        
        // Operation buttons
        self.backdropBar.position = CGPoint(x: 0, y: self.size.height / 2 - self.nodeBuffer - self.backdropBar.size.height / 2)
        self.backButton!.position = CGPoint(x: -self.size.width/2 + nodeBuffer + self.backButton!.size.width/2, y: self.backdropBar.position.y)
        self.resetSkillsButton!.position = CGPoint(x: self.size.width/2 - nodeBuffer - self.resetSkillsButton!.size.width/2, y: self.backdropBar.position.y)
        self.tradeButton!.position = CGPoint(x: self.resetSkillsButton!.position.x - self.resetSkillsButton!.size.width/2 - self.tradeButton!.size.width/2 - nodeBuffer, y: self.backdropBar.position.y)
        
        // Backdrop bar for selectors
        self.selectedSkillBackground = ScaleBuddy.sharedInstance.getScreenAdjustedSprite("flag_monster_chubby", textureAtlas: GameTextures.sharedInstance.uxMenuAtlas)
        // Boost the height for smaller screen
        if ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.original4 || ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.originaliPad {
            self.selectedSkillBackground!.size = CGSize(width: self.selectedSkillBackground!.size.width * 0.935, height: self.selectedSkillBackground!.size.height)
        } else {
            self.selectedSkillBackground!.size = CGSize(width: self.selectedSkillBackground!.size.width * 1, height: self.selectedSkillBackground!.size.height)
        }
        
        let selectedSkillBackgroundXPosition = (self.nodeBuffer / 2 - 1) * self.bufferSize - (self.size.width - self.selectedSkillBackground!.size.width) / 2
        let selectedSkillBackgroundYPosition = self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.selectedSkillBackground!.size.height / 2 + self.nodeBuffer * 0.1
        self.selectedSkillBackground?.position = CGPoint(x: selectedSkillBackgroundXPosition, y: selectedSkillBackgroundYPosition)
        
        self.worldView.addChild(self.selectedSkillBackground!)

        self.selectedSkillBackground!.addChild(self.selectedSkillTitle!)
        self.selectedSkillBackground!.addChild(self.selectedSkillDescription!)
        self.selectedSkillBackground!.addChild(self.selectedSkillErrorText!)
        self.selectedSkillBackground!.addChild(self.selectedSkillCost!)
        self.selectedSkillBackground!.addChild(self.selectedSkillCostIcon!)
        self.selectedSkillBackground!.addChild(self.buySkillButton!)
        self.selectedSkillBackground!.addChild(self.removeSkillButton!)
        
        self.reselectSkillNode()
        self.worldView.addChild(self.backdropBar)
        
        // Create tutorials
        self.createUxTutorials()
        self.displayTutorialTooltip()
        //self.updateSuperstarPurchasing()
        
        self.worldView.addChild(self.totalUnspentStars!)
        //self.worldView.addChild(self.totalUnspentCitrine!)
        self.worldView.addChild(self.totalUnspentDiamonds!)
        self.worldView.addChild(self.totalUnspentStarsIcon!)
        //self.worldView.addChild(self.totalUnspentCitrineIcon!)
        self.worldView.addChild(self.totalUnspentDiamondsIcon!)
    
        self.worldView.addChild(self.resetSkillsButton!)
        self.worldView.addChild(self.tradeButton!)
        self.worldView.addChild(self.backButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSkillSelector() {
        let convertedBackdropBar = self.convert(self.backdropBar.position, from: self.worldView)
        self.skillSelector!.position = CGPoint(x: (self.size.width / 2) - (self.skillSelectorBackground!.size.width / 2) - (self.nodeBuffer / 2 - self.nodeBuffer / 10) * self.bufferSize, /*self.size.height / 2 - self.skillSelectorBackground!.size.height / 2 - self.backdropBar.size.height / 2 - self.nodeBuffer * 2.0)*/ y: convertedBackdropBar.y - self.backdropBar.size.height / 2 - self.skillSelectorBackground!.size.height / 2 - self.nodeBuffer * 3.5)
        
        // Mask and crop nodes
        //self.skillSelectorBackground.zPosition = -1
        self.worldView.addChild(self.skillSelectorBackground!)
        
        let maskNode: SKSpriteNode = self.skillSelector!.copy() as! SKSpriteNode
        let cropNode: SKCropNode = SKCropNode() // TODO make it SKNode()??
        cropNode.maskNode = maskNode
        cropNode.addChild(self.skillSelector!)
        self.worldView.addChild(cropNode)
        
        // Create the upgrade nodes
        self.addSkillsToScrollingNode()
        
        // Add scrolling nodes
        self.scrollingNode!.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.skillSelector!.addChild(self.scrollingNode!)
        
        // Create the background
        self.skillSelectorBackground!.position = self.skillSelector!.position
        
        // Move to the top
        self.scrollingNode!.scrollToTop()
    }
    
    override func didMove(to view: SKView) {
        /*
        self.scrollingNode!.enableScrollingOnView(view)
        */
        
        if self.justInitialized {
            self.justInitialized = false
        } else {
            self.createUxTutorials()
            self.displayTutorialTooltip()
        }
        
        // Update the star counts
        //self.updateSuperstars()
        //self.reselectSkillNode()
        self.needsUpdated = true
        
        super.didMove(to: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.needsUpdated {
            self.updateSuperstars()
            self.reselectSkillNode()
            self.needsUpdated = false
        }
    }
    
    override func willMove(from view: SKView) {
        /*
        self.scrollingNode!.disableScrollingOnView(view)
        */
        //self.viewController!.saveData()
        GameData.sharedGameData.save()
        
        super.willMove(from: view)
    }
    
    func createUxTutorials() {
        var displayedBuySkill: Bool = false
        var displayedResetSkill: Bool = false
        var tutorialAck: Double?
        var tutorialKey: String
        var tutorialVersion: Double
        
        // First Skill
        tutorialKey = "UXTutorialFirstSkill"
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        // Show the first skill being unlocked already
        if ((tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion))) || GameData.sharedGameData.getSelectedCharacterData().godMode {
            let tutorial = UXTutorialDialog(frameSize: self.size, description: "This is your first skill. It was unlocked for you so it is already activated.", scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip!)
            
            // First skill - convert it to the right coords
            let point: CGPoint = self.convert(self.scrollingNode!.firstSkill!.position, from: self.scrollingNode!.firstSkill!.parent!)
            let point2: CGPoint = self.convert(point, to: tutorial.containerBackground)
            
            tutorial.containerBackground.position = CGPoint(x: point2.x, y: point2.y - self.scrollingNode!.firstSkill!.size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2)
            self.uxTutorialTooltips!.append(tutorial)
            
            displayedBuySkill = true
            self.addChild(tutorial)
        }
        
        // Upgrade Skills
        tutorialKey = "UXTutorialUpgradeJumpSkill"
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        // We don't want to show this if the character has the upgrade skills already
        if (GameData.sharedGameData.getSelectedCharacterData().levelProgress[4] != nil && GameData.sharedGameData.getSelectedCharacterData().levelProgress[4]!.timesLevelPlayed > 0 && !GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.contains(CharacterUpgrade.TeleCharge.rawValue) && !GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.contains(CharacterUpgrade.RubberSneakers.rawValue) && (tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion))) || GameData.sharedGameData.getSelectedCharacterData().godMode {
            let tutorial = UXTutorialDialog(frameSize: self.size, description: "Use stars to buy and upgrade skills. Upgrade jump at least once by level 5.", scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip!)
            
            // First upgrade for jump - convert it to the right coords
            let point: CGPoint = self.convert(self.scrollingNode!.firstJumpUpgradeSkill!.position, from: self.scrollingNode!.firstJumpUpgradeSkill!.parent!)
            let point2: CGPoint = self.convert(point, to: tutorial.containerBackground)
            
            tutorial.containerBackground.position = CGPoint(x: point2.x, y: point2.y - self.scrollingNode!.firstJumpUpgradeSkill!.size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2)
            self.uxTutorialTooltips!.append(tutorial)
            
            displayedBuySkill = true
            self.addChild(tutorial)
        }
        
        if !displayedBuySkill {
            // Reset Skills
            tutorialKey = "UXTutorialSkillsReset"
            tutorialVersion = 1.0
            tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
            
            // We don't want to show this until the character has 2 skills total
            if GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.count > 1 && (tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion)) || GameData.sharedGameData.getSelectedCharacterData().godMode {
                let tutorial = UXTutorialDialog(frameSize: self.size, description: "Reset your skills for free to get back all stars and superstars spent. Unlimited resets!", scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.rightTop], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip!)
                tutorial.containerBackground.position = CGPoint(x: self.resetSkillsButton!.position.x - self.resetSkillsButton!.size.width / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.nodeBuffer, y: self.resetSkillsButton!.position.y + self.resetSkillsButton!.size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2)
                self.uxTutorialTooltips!.append(tutorial)
                
                displayedResetSkill = true
                self.addChild(tutorial)
            }
        }
        
        if !displayedBuySkill && !displayedResetSkill && GameData.sharedGameData.getSelectedCharacterData().levelProgress[10] != nil && GameData.sharedGameData.getSelectedCharacterData().levelProgress[10]!.timesLevelPlayed > 0 {
            tutorialKey = "UXTutorialSkillsTrade"
            tutorialVersion = 1.0
            tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
            
            if self.superStarPurchasingUnlocked() && (tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion)) || GameData.sharedGameData.getSelectedCharacterData().godMode {
                let tutorial = UXTutorialDialog(frameSize: self.size, description: "Trade your gems for stars for skill upgrades!", scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.rightTop], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip!)
                tutorial.containerBackground.position = CGPoint(x: self.tradeButton!.position.x - self.tradeButton!.size.width / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.nodeBuffer, y: self.tradeButton!.position.y + self.tradeButton!.size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2)
                self.uxTutorialTooltips!.append(tutorial)
                
                self.addChild(tutorial)
            }
        }
    }
    
    override func displayTutorialTooltip() -> Void {
        // If the UX tut array has objects, pop one, display it.
        if (self.uxTutorialTooltips!.count > 0) {
            let tooltip = self.uxTutorialTooltips!.first
            self.uxTutorialTooltips!.remove(at: 0)
            tooltip!.zPosition = 14.0
            tooltip!.isHidden = false
        }
    }
    
    func superStarPurchasingUnlocked() -> Bool {
        // Level 6 needs to be unlocked
        if !GameData.sharedGameData.getSelectedCharacterData().isLevelLocked(6) /*&& GameData.sharedGameData.getTotalGemsEarned() > 0*/ || GameData.sharedGameData.getSelectedCharacterData().godMode {
            return true
        } else {
            return false
        }
    }
    
    override func updateGemCounts() {
        super.updateGemCounts()
        
        self.updateHeader()
    }
    
    func addSkillsToScrollingNode() {
        // Create the path to the level - UPGRADE
        let filePath: String = "upgrades_\(GameData.sharedGameData.selectedCharacter.rawValue)".lowercased()
        let path: String = Bundle.main.path(forResource: filePath, ofType: "plist")!
        let upgradeList = NSMutableArray(contentsOfFile: path) as! Array<Array<[String: AnyObject]>>
        
        /********* COST */
        // Create the path to the level
        let costFilePath: String = "upgrades_cost".lowercased()
        let costPath: String = Bundle.main.path(forResource: costFilePath, ofType: "plist")!
        let costList = NSMutableArray(contentsOfFile: costPath) as! Array<Array<[String: AnyObject]>>
        
        // Loop through each entry in the dictionary
        for i in 0...upgradeList.count-1 {
            let upgradeColumn = upgradeList[i]
            let costColumn = costList[i]
            
            var upgradeParentId: CharacterUpgrade = .None
            var upgradeParentNode: ScrollingSkillNode? = nil
            let skillRow = ScrollingSkillNodeRow()
            
            for j in 0...upgradeColumn.count-1 {
                let upgrade = upgradeColumn[j]
                let cost = costColumn[j]
                
                // Read in upgrade info from dictionary
                let upgradeName = TextFormatter.formatTextUppercase(upgrade["Name"] as! String)
                let upgradeId = CharacterUpgrade(rawValue: upgrade["Id"] as! String)!
                let upgradeCost = cost["Cost"] as! Int
                let upgradeCurrency = Currency(rawValue: cost["Currency"] as! String)!
                let upgradeDescription = TextFormatter.formatText(upgrade["Description"] as! String)
                let upgradeIconName = upgrade["IconName"] as? String
                let upgradeType: UpgradeType = UpgradeType(rawValue: upgrade["Type"] as! String)!
                
                // Create the skill node
                let skillNode = ScrollingSkillNode(upgradeName: upgradeName, upgradeId: upgradeId, upgradeCost: upgradeCost, upgradeCurrency: upgradeCurrency, upgradeDescription: upgradeDescription, upgradeParentId: upgradeParentId, upgradeIcon: upgradeIconName, upgradeType: upgradeType)
                
                // Tell the parent you are its child
                if upgradeParentNode != nil {
                    upgradeParentNode!.childSkillId = upgradeId
                }
                
                upgradeParentId = upgradeId
                upgradeParentNode = skillNode
                
                skillRow.addChild(skillNode)
            }
            
            // Add the skill row
            self.scrollingNode!.addChild(skillRow)
        }
    }
    
    // TODO see if this can be opitmized to not recreate these
    func reselectSkillNode() {
        // Icon
        self.selectedSkillIcon?.removeFromParent()
        let skillRow = self.scrollingNode!.selectedSkillNode!.parent as! ScrollingSkillNodeRow
        self.selectedSkillIcon = (skillRow.firstSkillNode!.nodeContent!.copy() as! SKSpriteNode)
        self.selectedSkillIcon?.childNode(withName: "upgradelock")?.removeFromParent()
        
        //self.selectedSkillIcon!.size = CGSizeMake(self.selectedSkillIcon!.size.width * 1.2, self.selectedSkillIcon!.size.height * 1.2)
        self.selectedSkillIcon!.position = CGPoint(x: nodeBuffer + self.selectedSkillIcon!.size.width / 2 - self.selectedSkillBackground!.size.width/2, y: self.selectedSkillBackground!.size.height/2 - self.selectedSkillIcon!.size.height / 2 - nodeBuffer)
        
        // Title
        self.selectedSkillTitle?.fontSize = round(32 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.selectedSkillTitle?.paragraphWidth = self.selectedSkillBackground!.size.width - nodeBuffer*3 - selectedSkillIcon!.size.width
        if ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.original4 || ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.originaliPad {
            self.selectedSkillTitle?.fontSize = round(20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)) // We need to make this a lot smaller for this screen dimension due to cramming it in to less width
        }
        
        // Scale icon smaller for skinny res
        if ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.original4 || ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.originaliPad {
            self.selectedSkillIcon!.setScale(0.85)
        }
        
        self.selectedSkillTitle?.fontColor = MerpColors.darkFont
        self.selectedSkillTitle?.text = self.scrollingNode!.selectedSkillNode!.skillTitle
        
        let selectedSkillTitleXPosition = 0 + self.selectedSkillIcon!.size.width + nodeBuffer*2 + self.selectedSkillTitle!.calculateAccumulatedFrame().width/2 - self.selectedSkillBackground!.size.width/2
        let selectedSkillTitleYPosition = self.selectedSkillBackground!.size.height/2 - self.selectedSkillTitle!.calculateAccumulatedFrame().height / 2 - self.nodeBuffer * 1.5
        self.selectedSkillTitle?.position = CGPoint(x: selectedSkillTitleXPosition, y: selectedSkillTitleYPosition)
        
        // Description
        self.selectedSkillDescription?.paragraphWidth = self.selectedSkillBackground!.size.width - nodeBuffer*1.65
        self.selectedSkillDescription?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(true))
        self.selectedSkillDescription?.fontColor = MerpColors.darkFont
        
        self.selectedSkillDescription?.text = self.scrollingNode!.selectedSkillNode!.skillDescription
        
        let topYPosition = self.selectedSkillBackground!.size.height/2 - self.selectedSkillDescription!.calculateAccumulatedFrame().height/2
        
        var descYPos: CGFloat
        if ScaleBuddy.sharedInstance.getScaleAmount() < 1 { // TODOSCALE haven't updated yet
            descYPos = 2
        } else {
            descYPos = 3
        }
        
        let selectedSkillDescriptionXPosition = -(self.selectedSkillBackground!.size.width - self.nodeBuffer * 2 - (self.selectedSkillDescription?.calculateAccumulatedFrame().width)!) / 2
        let selectedSkillDescriptionYPosition = topYPosition - self.nodeBuffer * 1.2 * descYPos - self.selectedSkillIcon!.size.height
        self.selectedSkillDescription?.position = CGPoint(x: selectedSkillDescriptionXPosition, y: selectedSkillDescriptionYPosition)
        
        // Buy skill button
        var scaler: CGFloat = 0
        if ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.wide6 || ScaleBuddy.sharedInstance.deviceSize == DeviceSizes.original4 { // TODOSCALE this changes now with new resolution
            scaler = 4.5
        } else {
            scaler = 3.25
        }
        
        let buyButtonPos = self.selectedSkillBackground!.position.y - self.selectedSkillBackground!.size.height / scaler
        self.buySkillButton!.position = CGPoint(x: self.selectedSkillBackground!.size.width/2 - nodeBuffer - self.buySkillButton!.size.width/2, y: buyButtonPos)
        self.removeSkillButton!.position = CGPoint(x: self.buySkillButton!.position.x, y: self.buySkillButton!.position.y)
        
        // Cost
        self.selectedSkillCost?.setText("\(self.scrollingNode!.selectedSkillNode!.skillCost)")
        self.selectedSkillCost?.setFontSize(round(26 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.selectedSkillCost?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)

        self.selectedSkillCost?.position = CGPoint(x: -self.selectedSkillBackground!.size.width/2 + self.selectedSkillCost!.label.calculateAccumulatedFrame().width/2 + self.nodeBuffer, y: self.buySkillButton!.position.y)
        
        switch self.scrollingNode!.selectedSkillNode!.skillCurrency {
        case .Stars:
            self.selectedSkillCostIcon?.texture = self.selectedSkillCostIconTextureStar
        case .Citrine:
            self.selectedSkillCostIcon?.texture = self.selectedSkillCostIconTextureCitrine
        }
        
        self.selectedSkillCostIcon?.position = CGPoint(x: self.selectedSkillCost!.position.x + self.selectedSkillCost!.calculateAccumulatedFrame().width/2 + self.nodeBuffer * 1.5, y: self.buySkillButton!.position.y)
        
        // Unspent gems and citrine
        self.updateSuperstars()
        
        self.selectedSkillBackground!.addChild(self.selectedSkillIcon!)
        
        // See if the player can buy the skill now
        
        self.buySkillButton!.checkDisabled()
        if self.buySkillButton!.errorText != nil {
            // Error Text
            self.selectedSkillErrorText?.paragraphWidth = self.selectedSkillBackground!.size.width - nodeBuffer*1.65
            self.selectedSkillErrorText?.fontSize = round(14 * ScaleBuddy.sharedInstance.getGameScaleAmount(true))
            self.selectedSkillErrorText?.fontColor = MerpColors.merpRed
            self.selectedSkillErrorText?.text = self.buySkillButton!.errorText!
            
            // Positioning
            let errorTopYPosition = self.buySkillButton!.position.y + self.buySkillButton!.size.height/2
            let selectedSkillErrorTextXPosition = -(self.selectedSkillBackground!.size.width - self.nodeBuffer * 2 - (self.selectedSkillErrorText?.calculateAccumulatedFrame().width)!) / 2
            let selectedSkillErrorTextYPosition = errorTopYPosition + self.nodeBuffer + self.selectedSkillErrorText!.calculateAccumulatedFrame().size.height / 2
            self.selectedSkillErrorText?.position = CGPoint(x: selectedSkillErrorTextXPosition, y: selectedSkillErrorTextYPosition)
            
            // Unhide
            self.selectedSkillErrorText?.isHidden = false
        } else {
            self.selectedSkillErrorText?.isHidden = true // Hide the error - we don't need it
        }
        self.removeSkillButton!.checkDisabled()
    }
    
    func updateSuperstars() {
        self.updateHeader()
        //self.updateSuperstarPurchasing()
    }
    
    func updateHeader() {
        // Unspent skill points
        // Star icon
        self.totalUnspentStarsIcon?.setScale(0.74)
        self.totalUnspentStarsIcon?.position = CGPoint(x: self.tradeButton!.position.x - self.tradeButton!.size.width/2 - self.totalUnspentStarsIcon!.size.width / 2 - nodeBuffer * 2, y: self.resetSkillsButton!.position.y)
        
        // Star label
        self.totalUnspentStars?.setText("\(GameData.sharedGameData.getSelectedCharacterData().unspentStars)")
        self.totalUnspentStars?.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalUnspentStars?.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalUnspentStars?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.totalUnspentStars?.position = CGPoint(x: self.totalUnspentStarsIcon!.position.x - self.totalUnspentStarsIcon!.size.width/2 - nodeBuffer/5, y: self.resetSkillsButton!.position.y)
        
        /*
        // Citrine icon
        self.totalUnspentCitrineIcon?.setScale(0.74)
        self.totalUnspentCitrineIcon?.position = CGPoint(x: self.totalUnspentStars!.position.x - self.totalUnspentStars!.calculateAccumulatedFrame().width - nodeBuffer * 1 - self.totalUnspentCitrineIcon!.size.width/2, y: self.resetSkillsButton!.position.y)
        
        // Citrine label
        self.totalUnspentCitrine?.setText("\(GameData.sharedGameData.getSelectedCharacterData().unspentCitrine)")
        self.totalUnspentCitrine?.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalUnspentCitrine?.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalUnspentCitrine?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.totalUnspentCitrine?.position = CGPoint(x: self.totalUnspentCitrineIcon!.position.x - self.totalUnspentCitrineIcon!.size.width/2 - nodeBuffer/5, y: self.resetSkillsButton!.position.y)
        */
        
        // Diamonds icon
        self.totalUnspentDiamondsIcon?.setScale(0.74)
        self.totalUnspentDiamondsIcon?.position = CGPoint(x: self.totalUnspentStars!.position.x - self.totalUnspentStars!.calculateAccumulatedFrame().width - nodeBuffer * 1 - self.totalUnspentDiamondsIcon!.size.width/2, y: self.resetSkillsButton!.position.y)
        
        // Diamons label
        self.totalUnspentDiamonds?.setText("\(GameData.sharedGameData.totalDiamonds)")
        self.totalUnspentDiamonds?.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalUnspentDiamonds?.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalUnspentDiamonds?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.totalUnspentDiamonds?.position = CGPoint(x: self.totalUnspentDiamondsIcon!.position.x - self.totalUnspentDiamondsIcon!.size.width/2 - nodeBuffer/5, y: self.resetSkillsButton!.position.y)
    }
    
    override func impactsMusic() -> Bool {
        return true // This was false at one point... to allow for the scene's music to carry forward. It isn't working now because the loading screen kills the music.
    }
}
