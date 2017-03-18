//
//  MainMenuScene.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MainMenuScene)
class MainMenuScene : DBScene {
    var worldView: SKSpriteNode
    
    // Buttons
    var playButton: MainMenuPlayButton?
    var buyButton: MainMenuBuyButton?
    var skillsButton: DBSceneSkillsButton?
    var comingSoon: SKSpriteNode
    var storeButton: MainMenuStoreButton?
    
    // Character selectors
    var warriorSelector: SKSpriteNode
    var archerSelector: SKSpriteNode
    var mageSelector: SKSpriteNode
    var monkSelector: SKSpriteNode
    var activeSelector: SKSpriteNode
    var activeSelectorBackground: SKSpriteNode
    
    var backdropBar: SKSpriteNode
    var logoUnderlineBar: SKSpriteNode
    
    var charNames = [CharacterType : SKSpriteNode]()
    var charDescriptions = [CharacterType : DSMultilineLabelNode]()
    
    var settingsButton: MainMenuSettingsButton?
    var gameCenterButton: MainMenuGameCenterButton?
    var creditsButton: MainMenuCreditsButton?
    
    // Const
    var unselectedAlpha: CGFloat = 1.0
    let buttonBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    // Tutorial
    var tutorialDialogs: Array<WhatsNewDialog>? = Array<WhatsNewDialog>()
    
    // Story
    var storyDialogs: Array<StoryDialog>? = Array<StoryDialog>()
    
    override func didMove(to view: SKView) {
        // Setup CUSTOM observer for player is not authenticated
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(self.playerNotAuthenticated),
                                                 name: NSNotification.Name(rawValue: LocalPlayerNotAuthenticated),
                                                 object: nil)
        
        // Setup CUSTOM observer for player is authenticated
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(self.playerAuthenticated),
                                                 name: NSNotification.Name(rawValue: LocalPlayerIsAuthenticated),
                                                 object: nil)
        
        // TODO check if enablegamecenter is false... show red trophy?
        if GameKitHelper.sharedInstance.enableGameCenter == false {
            self.gameCenterButton?.showError()
        } else {
            self.gameCenterButton?.hideError()
        }
        
        // Reduce count of rate me, if 0, pop it up
        if (GameData.sharedGameData.playerHasRatedGame == false && GameData.sharedGameData.promptRateMeCountdown <= 0) /*|| GameData.sharedGameData.getSelectedCharacterData().godMode*/ {
            // Display the rate me dialog
            self.presentUserWithRateMeDialog()
            
            // Reset the count
            GameData.sharedGameData.promptRateMeCountdown = GameData.sharedGameData.promptRateMeMax
        }
        
        // Get the achievements
        //self.viewController!.getAchievements()
        
        // Cache an ad so we're ready when we need it
        //self.viewController!.cacheInterstitialAd()
        
        super.didMove(to: view)
    }
    
    override func willMove(from view: SKView) {
        // Setup CUSTOM observer for player is/not authenticated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LocalPlayerNotAuthenticated), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LocalPlayerIsAuthenticated), object: nil)
        
        super.willMove(from: view)
    }
    
    init(size: CGSize) {
        // Initialize vars
        self.worldView = SKSpriteNode(color: MerpColors.background, size: size)
        self.archerSelector = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_large"))
        self.warriorSelector = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_large"))
        self.mageSelector = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_large"))
        self.monkSelector = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_large"))
        
        // Add characters
        let warriorProfile = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("warrior_character_profile"))
        warriorProfile.setScale(0.75)
        self.warriorSelector.addChild(warriorProfile)
        
        let archerProfile = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("archer_character_profile"))
        archerProfile.setScale(0.75)
        self.archerSelector.addChild(archerProfile)
        
        let monkProfile = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("monk_character_profile"))
        monkProfile.setScale(0.75)
        self.monkSelector.addChild(monkProfile)
        
        let mageProfile = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("mage_character_profile"))
        mageProfile.setScale(0.75)
        self.mageSelector.addChild(mageProfile)
        
        // Extras
        self.backdropBar = SKSpriteNode(texture: SKTexture(imageNamed: "backdrop_bar"))
        self.logoUnderlineBar = SKSpriteNode(texture: SKTexture(imageNamed: "underline_bar"))
        
        // Create the character buttons, and auto select the last played character
        self.archerSelector.position = CGPoint(x: 0 - self.archerSelector.size.width / 2.0 - (buttonBuffer / 2.0), y: size.height / 8 + buttonBuffer * (2.5))
        self.warriorSelector.position = CGPoint(x: 0 - (self.warriorSelector.size.width / 2.0) * 3.0 - (buttonBuffer * 3/2), y: size.height / 8 + buttonBuffer * (2.5))
        self.monkSelector.position = CGPoint(x: 0 + self.monkSelector.size.width / 2.0 + (buttonBuffer / 2.0), y: size.height / 8 + buttonBuffer * (2.5))
        self.mageSelector.position = CGPoint(x: 0 + (self.mageSelector.size.width / 2.0) * 3.0 + (buttonBuffer * 3/2), y: size.height / 8 + buttonBuffer * (2.5))
        
        // Backdrop bar for selectors
        self.backdropBar.position = CGPoint(x: 0, y: self.monkSelector.position.y - self.monkSelector.size.height / 2 + buttonBuffer/2)
        
        // Default select the warrior
        self.activeSelectorBackground = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("square_button_large_highlight"))
        self.activeSelector = self.warriorSelector
        
        self.comingSoon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("comingsoon"))
        
        // Call super init
        super.init(size: size, settings: true, loadingOverlay: true, purchaseMenu: true, rateMe: true, trade: false)
        
        // Center the "camera"
        self.worldView.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        self.addChild(self.worldView)
        
        // Character info
        for type in CharacterType.allCases {
            self.createCharacterInfo(type)
        }
        
        // Setup the buttons
        self.playButton = MainMenuPlayButton(scene: self)
        self.buyButton = MainMenuBuyButton(scene: self, unlockAmount: 0)
        self.skillsButton = DBSceneSkillsButton(scene: self, size: DBButtonSize.small)
        self.storeButton = MainMenuStoreButton(scene: self)
        self.settingsButton = MainMenuSettingsButton(scene: self)
        self.gameCenterButton = MainMenuGameCenterButton(scene: self)
        self.creditsButton = MainMenuCreditsButton(scene: self)
        
        // Disable the game center button to start. Only disable after player auth
        //self.gameCenterButton!.isDisabled = true
        //self.gameCenterButton!.checkDisabled()
        
        // Select character
        // Make sure we initialize the selectors to the right character
        if GameData.sharedGameData.selectedCharacter == .Warrior {
            self.selectWarrior()
        } else if GameData.sharedGameData.selectedCharacter == .Archer {
            self.selectArcher()
        } else if GameData.sharedGameData.selectedCharacter == .Mage {
            self.selectMage()
        } else {
            self.selectMonk()
        }
        
        // Now create the logo image and add to the scene
        let logo: SKSpriteNode = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("logo_small"))
        logo.position = CGPoint(x: self.size.width / 2.0 - logo.size.width / 2.0 - (buttonBuffer * 3.0), y: self.frame.size.height / 2.0 - logo.size.height / 2.0 - buttonBuffer / 2)
        
        // Set logo underline position
        self.logoUnderlineBar.position = CGPoint(x: 0, y: logo.position.y - logo.size.height * (3 / 6) - self.buttonBuffer / 5)
        
        // Button positioning
        self.playButton!.position = CGPoint(x: 0 - self.playButton!.size.width - buttonBuffer, y: 0 - self.frame.size.height / 2.0 + self.playButton!.size.height - buttonBuffer * 0.8)
        self.buyButton!.position = CGPoint(x: 0 - self.buyButton!.size.width - buttonBuffer, y: 0 - self.frame.size.height / 2.0 + self.buyButton!.size.height - buttonBuffer * 0.8)
        self.skillsButton!.position = CGPoint(x: 0 + 0, y: 0 - self.frame.size.height / 2.0 + self.playButton!.size.height - buttonBuffer * 0.8)
        self.storeButton!.position = CGPoint(x: 0 + self.storeButton!.size.width + buttonBuffer, y: 0 - self.frame.size.height / 2.0 + self.playButton!.size.height - buttonBuffer * 0.8)
        
        // Coming soon pos
        self.comingSoon.setScale(0.8)
        self.comingSoon.position = CGPoint(x: 0 + 0, y: 0 - self.frame.size.height / 2.0 + self.comingSoon.size.height - buttonBuffer * 0.8)
        self.comingSoon.isHidden = true
        
        self.worldView.addChild(self.playButton!)
        self.worldView.addChild(self.buyButton!)
        self.worldView.addChild(self.skillsButton!)
        self.worldView.addChild(self.storeButton!)
        self.worldView.addChild(self.comingSoon)
        
        // Settings
        let settingsButtonXPosition = -size.width / 2.0 + self.settingsButton!.size.width / 2 + self.buttonBuffer * 1.5
        let settingsButtonYPosition = size.height / 2 - self.settingsButton!.size.height / 2.3
        self.settingsButton!.position = CGPoint(x: settingsButtonXPosition, y: settingsButtonYPosition)
        
        // Gamecenter
        self.gameCenterButton!.position = CGPoint(x: self.settingsButton!.position.x + (self.settingsButton!.size.width / 2) + (self.buttonBuffer/2) + (self.gameCenterButton!.size.width / 2), y: self.settingsButton!.position.y)
        
        // Credits
        self.creditsButton!.position = CGPoint(x: self.gameCenterButton!.position.x + (self.gameCenterButton!.size.width / 2) + (self.buttonBuffer/2) + (self.creditsButton!.size.width / 2), y: self.gameCenterButton!.position.y)
        
        // Add everything to world view
        self.worldView.addChild(self.logoUnderlineBar)
        self.worldView.addChild(self.backdropBar)
        self.worldView.addChild(self.settingsButton!)
        self.worldView.addChild(self.gameCenterButton!)
        self.worldView.addChild(self.creditsButton!)
        
        self.worldView.addChild(self.activeSelectorBackground)
        self.worldView.addChild(self.warriorSelector)
        self.worldView.addChild(self.archerSelector)
        self.worldView.addChild(self.mageSelector)
        self.worldView.addChild(self.monkSelector)
        
        self.worldView.addChild(logo)
        
        self.initializeCredits()
        
        /*
         // Make sure we initialize the selectors to the right character
         if GameData.sharedGameData.selectedCharacter == .Warrior {
         self.selectWarrior()
         }
         else {
         if GameData.sharedGameData.selectedCharacter == .Archer {
         self.selectArcher()
         }
         }*/
        
        
        // Create tutorials
        // Read in level information from file
        // Create the path to the level
        let filePath: String = "main_menu"
        let path: String = Bundle.main.path(forResource: filePath, ofType: "plist")!
        
        // Read in the level
        let sceneSetup: NSDictionary = NSDictionary(contentsOfFile: path)!
        
        self.initializeTutorial(sceneSetup)
        self.displayTutorials()
    }
    
    func displayTutorials() {
        if self.tutorialDialogs!.count > 0 {
            self.tutorialDialogs![0].isHidden = false
        }
    }
    
    func initializeTutorial(_ levelSetup: NSDictionary) {
        // TODO read in the tutorial
        var count: Int = 0
        
        let tutorialArray = levelSetup.value(forKey: "Tutorial") as? Array<[String: AnyObject]>
        
        // Need to know the prev dialog
        var previousDialog: WhatsNewDialog?
        
        if tutorialArray != nil {
            for tutorialTipDictionary in tutorialArray! {
                // Get the version information
                var key = tutorialTipDictionary["Key"] as! String
                key = "main_menu_" + key // Make it level specific
                
                let version = tutorialTipDictionary["Version"] as! Double
                
                // If the player has already seen this version, don't bother showing it!
                let storedTutorial: Double? = GameData.sharedGameData.tutorialsAcknowledged[key]
                
                if storedTutorial == nil || floor(storedTutorial!) != floor(version) || GameData.sharedGameData.getSelectedCharacterData().godMode {
                    var iconTexture: SKTexture
                    
                    iconTexture = GameTextures.sharedInstance.splashAndStoryAtlas.textureNamed("tutorialicon")
                    
                    // Create dialog
                    var title = ""
                    var description = ""
                    var description2 = ""
                    var description3 = ""
                    var description4 = ""
                    var description5 = ""
                    if storedTutorial == nil {
                        title = TextFormatter.formatText(tutorialTipDictionary["FirstPlayTitle"] as! String)
                        description = TextFormatter.formatText(tutorialTipDictionary["FirstPlayDescription"] as! String)
                    } else {
                        title = TextFormatter.formatText(tutorialTipDictionary["Title"] as! String)
                        description = TextFormatter.formatText(tutorialTipDictionary["Description"] as! String)
                        description2 = TextFormatter.formatText(tutorialTipDictionary["Description2"] as! String)
                        description3 = TextFormatter.formatText(tutorialTipDictionary["Description3"] as! String)
                        description4 = TextFormatter.formatText(tutorialTipDictionary["Description4"] as! String)
                        description5 = TextFormatter.formatText(tutorialTipDictionary["Description5"] as! String)
                    }
                    
                    let tutorialDialog = WhatsNewDialog(title: title, description: description, description2: description2, description3: description3, description4: description4, description5: description5, frameSize: self.size, dialogs: self.tutorialDialogs!, dialogNumber: count, scene: self, iconTexture: iconTexture, key: key, version: version)
                    
                    tutorialDialog.zPosition = 20
                    
                    self.tutorialDialogs!.append(tutorialDialog)
                    //self.addChild(tutorialDialog)
                    previousDialog = tutorialDialog
                    count += 1
                }
            }
        }
    }
    
    func createCharacterInfo(_ type: CharacterType) {
        self.charNames[type] = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("char_name_\(type.rawValue.lowercased())"))
        
        self.charDescriptions[type] = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: self)
        
        self.charNames[type]!.isHidden = true
        self.charDescriptions[type]!.isHidden = true
        
        self.worldView.addChild(charNames[type]!)
        self.worldView.addChild(charDescriptions[type]!)
        
        self.charDescriptions[type]!.paragraphWidth = size.width * (8.5/10)
        self.charDescriptions[type]!.fontSize = round(15 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.charDescriptions[type]!.fontColor = MerpColors.darkFont
        self.charDescriptions[type]!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        switch type {
        case .Warrior:
            self.charDescriptions[type]!.text = "Jim is a feast of the eyes for the ladies. He’s a brute force and he stops for nothing. If you’re willing to charge into battle before sizing up your enemy, Jim is your man."
        case .Archer:
            self.charDescriptions[type]!.text = "May prefers to deal with her problems from afar. She's not too touchy feely so keep your distance. If you're not a fan of smelling minion breath, hold back with May."
        case .Mage:
            self.charDescriptions[type]!.text = "Gary is an amazing dude. He’ll shock the feeble minded with his magic tricks and surprise the brilliants with his wits. When the only way is the mystic way, call Gary."
        case .Monk:
            self.charDescriptions[type]!.text = "Leonard is a man of peace. If he must fight, he will disable a foe with perfect accuracy, hitting the right spot so they feel no pain. For the keen on fighting like a gentleman, Leonard won’t let you down."
        }
        
        // Positions for name and txt
        let charNamesTypeYPosition = self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.buttonBuffer * 0.5 - self.charNames[type]!.size.height / 2
        self.charNames[type]!.position = CGPoint(x: 0, y: charNamesTypeYPosition)
        
        let charDescriptionsXPosition = CGFloat(0)
        let charDescriptionsYPosition = self.charNames[type]!.position.y - self.charNames[type]!.size.height / 2 - self.buttonBuffer * 0.5 - self.charDescriptions[type]!.calculateAccumulatedFrame().height/2
        self.charDescriptions[type]!.position = CGPoint(x: charDescriptionsXPosition, y: charDescriptionsYPosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // For loop on touches and set boolean on which buttons contain a point
        for touch: UITouch in touches {
            
            // Get the location of the touch
            let location: CGPoint = touch.location(in: self)
            let translatedTouchLocation: CGPoint = self.convert(location, to: self.worldView)
            
            // Character selection press
            if self.activeSelector != self.warriorSelector && self.warriorSelector.contains(translatedTouchLocation) {
                self.selectWarrior()
                SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
            }
            if self.activeSelector != self.archerSelector && self.archerSelector.contains(translatedTouchLocation) {
                self.selectArcher()
                SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
            }
            if self.activeSelector != self.mageSelector && self.mageSelector.contains(translatedTouchLocation) {
                self.selectMage()
                SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
            }
            if self.activeSelector != self.monkSelector && self.monkSelector.contains(translatedTouchLocation) {
                self.selectMonk()
                SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
            }
        }
    }
    
    func lockOrUnlockCharacter() {
        if GameData.sharedGameData.getSelectedCharacterData().isCharacterUnlocked || GameData.sharedGameData.getSelectedCharacterData().godMode || CharacterType.getUnlockCost(GameData.sharedGameData.selectedCharacter) == 0 {
            
            // TODO remove after impl mage
            self.buyButton!.isHidden = false
            self.playButton!.isHidden = false
            self.storeButton!.isHidden = false
            self.skillsButton!.isHidden = false
            self.comingSoon.isHidden = true
            // END TODO
            
            if !GameData.sharedGameData.getSelectedCharacterData().isCharacterUnlocked {
                GameData.sharedGameData.getSelectedCharacterData().isCharacterUnlocked = true
            }
            
            self.updateButtonsUnlocked()
        } else {
            // This is the coming soon logic that we won't need right now
            //if GameData.sharedGameData.selectedCharacter != CharacterType.Mage {
            self.buyButton!.isHidden = false
            self.playButton!.isHidden = false
            self.storeButton!.isHidden = false
            self.skillsButton!.isHidden = false
            self.comingSoon.isHidden = true
            self.updateButtonsLocked()
            /*} else {
             self.buyButton!.isHidden = true
             self.playButton!.isHidden = true
             self.storeButton!.isHidden = true
             self.skillsButton!.isHidden = true
             self.comingSoon.isHidden = false
             }*/
        }
    }
    
    func selectWarrior() {
        // Change the bg to be behind the player
        self.activeSelectorBackground.position = self.warriorSelector.position
        
        resetCharacterSelection()
        selectCharacter(CharacterType.Warrior)
        
        // Set to full alpha
        self.warriorSelector.alpha = 1.0
        
        // Set this as selected player
        self.activeSelector = self.warriorSelector
        GameData.sharedGameData.selectedCharacter = .Warrior
        
        // Determine if we need to lock char
        self.lockOrUnlockCharacter()
    }
    
    func selectArcher() {
        // Change the bg to be behind the player
        self.activeSelectorBackground.position = self.archerSelector.position
        
        resetCharacterSelection()
        selectCharacter(CharacterType.Archer)
        
        // Set to full alpha
        self.archerSelector.alpha = 1.0
        
        // Set this as selected player
        self.activeSelector = self.archerSelector
        GameData.sharedGameData.selectedCharacter = .Archer
        
        // Determine if we need to lock char
        self.lockOrUnlockCharacter()
    }
    
    func selectMage() {
        // Change the bg to be behind the player
        self.activeSelectorBackground.position = self.mageSelector.position
        
        resetCharacterSelection()
        
        // Set to full alpha
        self.mageSelector.alpha = 1.0
        selectCharacter(CharacterType.Mage)
        
        // Set this as selected player
        self.activeSelector = self.mageSelector
        GameData.sharedGameData.selectedCharacter = .Mage
        
        // Determine if we need to lock char
        self.lockOrUnlockCharacter()
    }
    
    func selectMonk() {
        // Change the bg to be behind the player
        self.activeSelectorBackground.position = self.monkSelector.position
        
        resetCharacterSelection()
        
        // Set to full alpha
        self.monkSelector.alpha = 1.0
        selectCharacter(CharacterType.Monk)
        
        // Set this as selected player
        self.activeSelector = self.monkSelector
        GameData.sharedGameData.selectedCharacter = .Monk
        
        // Determine if we need to lock char
        self.lockOrUnlockCharacter()
    }
    
    func resetCharacterSelection() {
        for type in CharacterType.allCases {
            self.charNames[type]!.isHidden = true
            self.charDescriptions[type]!.isHidden = true
        }
        
        // Change the overlay of other chars to dim
        self.warriorSelector.alpha = self.unselectedAlpha
        self.mageSelector.alpha = self.unselectedAlpha
        self.monkSelector.alpha = self.unselectedAlpha
        self.archerSelector.alpha = self.unselectedAlpha
    }
    
    func updateButtonsUnlocked() {
        self.buyButton!.isHidden = true
        self.playButton!.isHidden = false
    }
    
    func updateButtonsLocked() {
        self.buyButton!.updateUnlockAmount(CharacterType.getUnlockCost(GameData.sharedGameData.selectedCharacter))
        self.buyButton!.isHidden = false
        self.playButton!.isHidden = true
    }
    
    func selectCharacter(_ type: CharacterType) {
        self.charNames[type]!.isHidden = false
        self.charDescriptions[type]!.isHidden = false
    }
    
    override func updateGemCounts() {
        // Determine if we need to lock char
        self.lockOrUnlockCharacter()
        
        super.updateGemCounts()
    }
    
    func playerNotAuthenticated() {
        // Make trophy red
        self.gameCenterButton!.showError()
        
        // Create dialog for error message
        if true { // TODO base on bool from notification
            let dialog = DBSceneDialog(title: "Unable to Connect to Game Center", description: "Ensure you're logged in by going to iOS settings then Game Center. If you're logged in and it still won't connect, try signing out then back in. Once you sign in to Game Center successfully, you will need to restart Mort's Minions.", descriptionSize: 14, description2: nil, description3: nil, description4: nil, description5: nil, frameSize : self.size, scene: self, iconTexture:  GameTextures.sharedInstance.buttonAtlas.textureNamed("trophyred"))
            
            self.addChild(dialog)
            dialog.isHidden = false
        }
    }
    
    func playerAuthenticated() {
        // Game center button should be blue
        self.gameCenterButton!.hideError()
    }
    
    /*
    func initializeStory() {
        // Add 2 storyboards
        // #1 - Morts Minions - The Story
        // #2 - Warning - contains spoilers
        
        let totalLevels: Int = GameData.sharedGameData.getSelectedCharacterData().totalLevels
        
        for level in 1...totalLevels {
            // Create the path to the level
            let filePath: String = "level_\(level)"
            let path: String = Bundle.main.pathForResource(filePath, ofType: "plist")!
            
            // Read in the level
            let levelSetup: NSDictionary = NSDictionary(contentsOfFile: path)!
            
            self.initializeStoryForLevel(levelSetup)
        }
    }
    
    func initializeStoryForLevel(_ levelSetup: NSDictionary) {
        // TODO read in the tutorial
        var count: Int = 0
        var endCount: Int = 0
        
        let storyArray = levelSetup.value(forKey: "Story") as? Array<[String: AnyObject]>
        
        // Need to know the prev dialog
        var previousDialog: StoryDialog?
        var previousEndDialog: StoryDialog?
        
        if storyArray != nil {
            for storyDictionary in storyArray! {
                // Get the class. If not null and equal to a character, only keep this story if it matches the selected character
                let character = storyDictionary["Character"] as? String
                
                if character == nil || character == GameData.sharedGameData.selectedCharacter.rawValue.lowercased() {
                    // Image Info
                    var iconName: String = (storyDictionary["Icon"] as! String).lowercased()
                    var iconTexture: SKTexture
                    iconTexture = SKTexture(imageNamed: iconName)
                    
                    // Create dialog
                    var description = TextFormatter.formatText(storyDictionary["Description"] as! String)
                    
                    let nameReplace = "c_name"
                    let roleReplace = "c_role"
                    
                    // Do some mods to the description
                    if GameData.sharedGameData.selectedCharacter == CharacterType.Archer {
                        description = description.replacingOccurrences(of: nameReplace, with: "may")
                        description = description.replacingOccurrences(of: roleReplace, with: "fearless archer")
                    } else if GameData.sharedGameData.selectedCharacter == CharacterType.Warrior {
                        description = description.replacingOccurrences(of: nameReplace, with: "jim")
                        description = description.replacingOccurrences(of: roleReplace, with: "fearless warrior")
                    } else if GameData.sharedGameData.selectedCharacter == CharacterType.Mage {
                        description = description.replacingOccurrences(of: nameReplace, with: "gary")
                        description = description.replacingOccurrences(of: roleReplace, with: "fearless mage")
                    } else if GameData.sharedGameData.selectedCharacter == CharacterType.Monk {
                        description = description.replacingOccurrences(of: nameReplace, with: "leonard")
                        description = description.replacingOccurrences(of: roleReplace, with: "fearless monk")
                    }

                    var storyDialog: StoryDialog
                    
                        storyDialog = StoryDialog(description: description, frameSize: self.size, dialogNumber: count, scene: self, iconTexture: iconTexture, key: "", version: 1, beginning: true)
                        self.storyDialogs!.append(storyDialog)
                        previousDialog = storyDialog
                    
                    storyDialog.zPosition = 20
                    self.addChild(storyDialog)
                }
            }
        }
    }*/
}
