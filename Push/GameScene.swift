//
//  GameScene.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import AVFoundation

@objc(GameScene)
class GameScene : DBScene, SKPhysicsContactDelegate {    
    var worldView: PreventUnpauseSKNode = PreventUnpauseSKNode()
    var player: Player = Monk()
    
    // Buttons
    var skill1Button: GameSkillButton?
    var skill2Button: GameSkillButton?
    var skill3Button: GameSkillButton?
    var skill4Button: GameSkillButton?
    var skill5Button: GameSkillButton?
    var skill6Button: GameSkillButton?
    
    // GUI Button
    var pauseButton: GamePauseButton?
    
    // Handle bug where touches arent getting properly passed to nodes below
    var objectThatHadATouchEventPassedIn: SKSpriteNode? = nil
    
    // Menu & Dialogs
    var pauseMenu: PauseMenu = PauseMenu()
    var endOfLevelDialog: EndOfLevelDialog = EndOfLevelDialog()
    var showPauseMenu = true
    
    var ground: SKSpriteNode = SKSpriteNode()
    var lastSpawnTimeInterval: TimeInterval = TimeInterval()
    var lastUpdateTimeInterval: TimeInterval = TimeInterval()
    
    // Level
    var currentLevel: Int = 0
    var totalLevelDistance: CGFloat = 0
    var totalLevelEnemyHealth: Int = 0
    var collectedLevelEnemyHealth: Int = 0
    var levelDistanceTraveled: CGFloat = 0
    var worldName: String = ""
    var totalLevelDestroyableObstacles: Int = 0
    var collectedLevelDestroyableObstacles: Int = 0
    
    // GUI
    var buttonSize: CGFloat = 0
    var buttonBuffer: CGFloat = 0
    
    // Setup physics bit masks
    static let deathCategory: UInt32 = 0x1 << 0
    static let groundCategory: UInt32 = 0x1 << 1
    static let playerCategory: UInt32 = 0x1 << 2
    static let transparentPlayerCategory: UInt32 = 0x1 << 3
    static let playerProjectileCategory: UInt32 = 0x1 << 4
    static let enemyCategory: UInt32 = 0x1 << 5
    static let obstacleCategory: UInt32 = 0x1 << 6
    static let projectileCategory: UInt32 = 0x1 << 7
    static let transparentEnemyCategory: UInt32 = 0x1 << 8
    static let transparentObstacleCategory: UInt32 = 0x1 << 9
    static let harmlessObjectCategory: UInt32 = 0x1 << 10
    
    // Z Positioning
    static let PLAYER_Z: CGFloat = 9
    static let ENEMY_Z: CGFloat = 4
    
    // Positioning
    var horizontalPlayerLimitRight: CGFloat = 0
    var horizontalPlayerLimitLeft: CGFloat = 0
    var groundPositionY: CGFloat = 0 // Ground position.
    var adjustedGroundPositionY: CGFloat = 0 // Adjusted ground position (where objects will intersect with it).
    
    // GUI Labels
    var heartsLabel: MultilineLabelWithShadow?
    var blackHeart: SKSpriteNode?
    var blackHeartAction: SKAction?
    var levelLabel: MultilineLabelWithShadow?
    var progressBar: SKSpriteNode = SKSpriteNode()
    var activeProgressBar: SKSpriteNode = SKSpriteNode()
    var pauseButtonAdjustment: CGFloat = 0
    var healthNodes = Array<PlayerHeartButton>()
    var progressBarAdjuster: CGFloat = 6.5
    
    // Enemy preloader
    var environmentObjectPreloader: SKSpriteNode
    
    // Object Arrays
    var mapObjectArray: [MapObject] = []
    var environmentObjectsToAdd: [EnvironmentObject] = []
    
    // Level
    var levelEnded: Bool = false
    var displayingEndOfLevel: Bool = false
    
    // World
    var world: String = ""
    var worldNumber: Int = 0
    
    // ui
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    // Time
    var timeSinceLast: CFTimeInterval = 0.0
    
    // Tutorial
    var tutorialDialogs: Array<TutorialDialog>? = Array<TutorialDialog>()
    
    // Story
    var storyDialogs: Array<StoryDialog>? = Array<StoryDialog>()
    var storyEndDialogs: Array<StoryDialog>? = Array<StoryDialog>()
    var score: LevelScore? = nil

    // Contacts
    var transparentObstacleContacts: Array<Obstacle> = Array<Obstacle>()
    var transparentEnemyContacts: Array<Enemy> = Array<Enemy>()
    var transparentProjectileContacts: Array<Projectile> = Array<Projectile>()
    var transparentObjectsAlreadyDamagedPlayer: Array<String> = Array<String>()
    
    // Challenges
    var levelChallenges = Array<LevelChallenge>()
    var gemsWon: Int = 0
    var completedChallenges = Array<LevelChallenge>()
    var challengeDialog: ChallengeDialog?
    
    // Sound
    var backgroundPlayer: AVAudioPlayer?
    
    // Level completion
    var levelCompletion = Array<Int>()
    
    // Just restarted
    var justRestarted: Bool = false
    
    // Rejuv
    var rejuvAllowed: Bool = true
    var rejuvHeartDialogAction: SKAction = SKAction()
    var rejuvHeartDialogDisplayAction: SKAction = SKAction()
    var rejuvHeartDialogDismissAction: SKAction = SKAction()
    var rejuvHeartDialogDismissStayPausedAction: SKAction = SKAction()
    var rejuvHeartDialogDismissAndEndLevelAction: SKAction = SKAction()
    var rejuvHeartDialogWaitThenDismissAndEndLevelAction: SKAction = SKAction()
    var rejuvHeartDialogWaitAction: SKAction = SKAction()
    
    var rejuvDialog: RejuvDialog?
    var rejuvPosition: CGPoint = CGPoint.zero
    var promptingForRejuv: Bool = false
    var playerRejuved: Bool = false
    var ACTION_KEY_REJUV_DIALOG: String = "rejuvDialog"
    
    // Cool text for level
    //var levelIntroText: LabelWithShadow?
    //var levelIntroTextAction: SKAction?
    //var levelIntroTextShown: Bool? = false
    
    // Heart boost
    var heartBoostReady = false
    var heartBoostDialog: HeartBoostDialog?
    var startingReviveHearts: Int = 0
    
    // Background
    var numberBackgroundNodes: Int = 4
    var totalBackgroundWidth: CGFloat = 0
    var totalForegroundWidth: CGFloat = 0
    
    // Performance Boosts - Worldview Arrays
    var worldViewBackgrounds = Array<SKSpriteNode>()
    var worldViewForegrounds = Array<SKSpriteNode>()
    var worldViewEnvironmentObjects = Array<EnvironmentObject>()
    var worldViewPlayerProjectiles = Array<PlayerProjectile>()
    
    // Used for displaying pregame pops
    var firstMoveToScene: Bool = true
    
    // Point functions
    func dbAdd(_ a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    func dbSub(_ a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(DBScene.pauseGame), name: NSNotification.Name(rawValue: "PauseGameScene"), object: nil)
        
        // Setup CUSTOM observer for rejuvenating the player
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(GameScene.rejuvenatePlayer),
                                                         name: NSNotification.Name(rawValue: "RejuvenatePlayer"),
                                                         object: nil)
        
        /* Let's not do anything if the video watching fails.. let them try another option and close manually
        // Setup CUSTOM observer for not rejuvenating the player
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(GameScene.dismissRejuvDialogWaitAndEndLevel),
                                                         name: NSNotification.Name(rawValue: "DontRejuvenatePlayer"),
                                                         object: nil)
        */
        
        // Setup CUSTOM observer for adding heart boost to the player
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameScene.enableHeartBoost),
                                               name: NSNotification.Name(rawValue: "PlayerHeartBoost"),
                                               object: nil)
        
        // Setup CUSTOM observer for dismissing the loading dialog
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(GameScene.stopLoadingOverlay),
                                                 name: NSNotification.Name(rawValue: "DismissLoadingDialog"),
                                                 object: nil)
        
        // Setup CUSTOM observer for dismissing static ad
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(GameScene.dismissStaticAds),
                                                         name: NSNotification.Name(rawValue: "ProgressPastInterstitialAd"),
                                                         object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setStayPaused"), name: "StayPausedNotification", object: nil)
        
        super.didMove(to: view)
        
        if self.firstMoveToScene {
            self.firstMoveToScene = false
            
            // Kick off display of pre-game pops
            self.displayPregamePops()
        }
    }
    
    override func willMove(from view: SKView) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PauseGameScene"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RejuvenatePlayer"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayerHeartBoost"), object: nil)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DontRejuvenatePlayer"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DismissLoadingDialog"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ProgressPastInterstitialAd"), object: nil)
        
        if backgroundPlayer != nil {
            backgroundPlayer!.stop()
            backgroundPlayer = nil
        }
        
        super.willMove(from: view)
    }
    
    init(size: CGSize, level: Int, controller: GameViewController, justRestarted: Bool) {
        // Initialize the World VIEW Name
        self.worldView.name = "world"
        // Set level
        self.currentLevel = level
        self.justRestarted = justRestarted
        
        self.world = GameData.sharedGameData.getSelectedCharacterData().getWorldForLevel(level)
        self.worldNumber = GameData.sharedGameData.getSelectedCharacterData().getWorldNumber(self.world)
        
        // Read in level information from file
        // Create the path to the level
        let filePath: String = "level_\(level)"
        let path: String = Bundle.main.path(forResource: filePath, ofType: "plist")!
        
        // Read in the level
        let levelSetup: NSDictionary = NSDictionary(contentsOfFile: path)!
        self.worldName = levelSetup.value(forKey: "World") as! String
        
        self.environmentObjectPreloader = SKSpriteNode(texture: GameTextures.sharedInstance.getAtlasForWorld(world: self.world).textureNamed("1x1trans"))
        
        // Call super init
        super.init(size: size, settings: false, loadingOverlay: true, purchaseMenu: true, rateMe: false, trade: false)
        
        // Level intro text
        //self.initializeLevelIntroText()
        
        // Create rejuv dialog
        self.createRejuvDialog()
        
        // Initialize variables
        self.viewController = controller
        
        // Sound
        self.initializeSound()
        
        // Heart Boost -- MUST BE BEFORE PLAYER
        self.intializeHeartBoost()
        
        // Initialize Player
        if GameData.sharedGameData.selectedCharacter == .Warrior {
            self.player = Warrior(worldView: self.worldView, gameScene: self)
        } else if GameData.sharedGameData.selectedCharacter == .Archer {
            self.player = Archer(worldView: self.worldView, gameScene: self)
        } else if GameData.sharedGameData.selectedCharacter == .Mage {
            self.player = Mage(worldView: self.worldView, gameScene: self)
        } else { //if GameData.sharedGameData.selectedCharacter == .Monk {
            self.player = Monk(worldView: self.worldView, gameScene: self)
        }
        
        // Initialize Tutorial
        self.initializeTutorial(levelSetup)
        
        // Initialize Story
        self.initializeStory(levelSetup)
        
        // Log screen size
        //NSLog("Size: %@", NSStringFromCGSize(size))
        
        // Set background color to white in case anything is shown behind
        self.backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // Add physics to the World
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8 / ScaleBuddy.sharedInstance.getGameScaleAmount(false)) // We want gravity downward
        self.physicsWorld.contactDelegate = self // When contact is made, refer here
        
        // Add the world view
        self.addChild(self.worldView)
        
        // Set button size
        let buttonNode = GameTextures.sharedInstance.buttonGameAtlas.textureNamed("skillbutton")
        self.buttonSize = buttonNode.size().width
        self.buttonBuffer = 6.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Initialize the Ground
        self.initializeGroundTiles(size) // Used to be after map objects
        
        // Initialize the Background
        self.initializeScrollingBackground(size)
        
        // Add the map objects (enemies, obstacles, level end, etc)
        self.initializeMapObjects()
        
        // Now render env objects
        self.createEnvironmentalObjects()
        
        // Initialize the Player
        self.initializePlayer(size)
        
        // We need to know how many gold hearts we started with
        self.startingReviveHearts = self.player.goldHearts
        
        // Create the controls
        self.initializeControls()
        
        // Create HUD
        self.initializeHUD()
        
        // Set the boundaries for player and background interaction
        horizontalPlayerLimitRight = self.frame.size.width / ScaleBuddy.sharedInstance.playerHorizontalRight
        horizontalPlayerLimitLeft = self.frame.size.width / ScaleBuddy.sharedInstance.playerHorizontalLeft
        
        // Level data
        GameData.sharedGameData.getSelectedCharacterData().initializeLevel(level, maxHearts: self.totalLevelEnemyHealth, maxDistance: self.totalLevelDistance)
        GameData.sharedGameData.getSelectedCharacterData().lastPlayedLevelByWorld[self.world] = self.currentLevel
        GameData.sharedGameData.getSelectedCharacterData().lastPlayedWorld = self.world
        
        // Initialize Challenges
        self.initializeChallenges(levelSetup)
        
        // Check Achievements for Start of Level
        GameKitHelper.sharedInstance.checkLevelIntroAchievements(self)
        
        // Create pause menu
        self.initializePauseMenu()
        
        // Create credits if needed
        if self.currentLevel == 65 /*MAX*/ {
            self.initializeCredits()
        }
        
        // Create end of level dialog
        self.initializeEndOfLevelDialog()
        
        // Create UX
        self.createUxTutorials()
        
        
        // Determine level status
        var lockedLevelsAdded: Int = 0
        var checkLevel = level
        while checkLevel < 65 /*MAX*/ && lockedLevelsAdded < 2 {
            if GameData.sharedGameData.getSelectedCharacterData().isLevelLocked(checkLevel + 1) {
                self.levelCompletion.append(checkLevel + 1)
                lockedLevelsAdded += 1
            }
            
            checkLevel += 1
        }
        
        // Increment times played - this is at beginning now to prevent add avoidance
        GameData.sharedGameData.timesPlayed += 1
        
        //GameData.sharedGameData.save()
        
        self.showPauseMenu = false
        self.pauseGame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        // TODO implement this
    }
    
    func displayPregamePops() {
        // First story
        if self.storyDialogs!.count > 0 {
            self.showPauseMenu = false
            self.pauseGame()
            self.storyDialogs![0].isHidden = false
        } else if self.heartBoostReady {
            // Then ads
            self.displayHeartBoostDialog()
            
            self.heartBoostReady = false
            self.showPauseMenu = false
            self.pauseGame()
        } else { // Then tutorials
            self.addAllPlayerHearts()
            
            // Now tutorials
            if self.tutorialDialogs!.count > 0 {
                self.showPauseMenu = false
                self.pauseGame()
                self.tutorialDialogs![0].isHidden = false
            } else {
                self.showPauseMenu = false
                self.pauseGame()
                
                // Skip challenges if restarted
                if self.justRestarted {
                    self.displayTutorialTooltip()
                } else {
                    self.displayChallenges()
                }
            }
        }
    }
    
    func enableHeartBoost() {
        GameData.sharedGameData.heartBoostLastUsed = Date()
        GameData.sharedGameData.configureHeartBoost(enable: true)
        self.heartBoostDialog!.isHidden = true
        self.displayPregamePops()
    }
    
    func intializeHeartBoost() {
        self.heartBoostReady = GameData.sharedGameData.timesPlayed > 14 && self.viewController!.heartBoostReady()
        
        if self.heartBoostReady {
            self.heartBoostDialog = HeartBoostDialog(frameSize: self.size, scene: self, gemCost: 12)
            self.heartBoostDialog!.zPosition = 14
            self.addChild(self.heartBoostDialog!)
        }
    }
    
    func addAllPlayerHearts() {
        // Add hearts to player for rejuv boost. When we initialized player, if they had any carried over gold hearts it would be set in goldHearts
        if GameData.sharedGameData.heartBoostCount > 0 {
            self.addHeartsToPlayer(GameData.sharedGameData.heartBoostCount, special: true)
        }
        
        // Add hearts to player for rejuv boost. When we initialized player, if they had any carried over gold hearts it would be set in goldHearts
        if self.player.goldHearts > 0 {
            self.addHeartsToPlayer(self.player.goldHearts, special: true)
        }
    }
    
    func displayHeartBoostDialog() {
        GameData.sharedGameData.heartBoostLastPrompted = Date()
        self.heartBoostDialog!.toggleheartBoostVideo()
        self.heartBoostDialog!.isHidden = false
    }
    
    // Create a functon that will be called by posted notifications of interstitial being closed.
    func dismissStaticAds() {
        // Make sure it closes
        //Chartboost.closeImpression()
        
        self.displayPregamePops()
        //viewController!.cacheInterstitialAd()
    }
    
    func createUxTutorials() {
        // Hearts
        let tutorialKeyHearts = "UXTutorialHearts"
        let tutorialVersionHearts: Double = 1.0
        let storedTutorialHearts: Double? = GameData.sharedGameData.tutorialsAcknowledged[tutorialKeyHearts]
        
        if storedTutorialHearts == nil || floor(storedTutorialHearts!) != floor(tutorialVersionHearts) {
            // Red hearts
            let tutHp = UXTutorialDialog(frameSize: self.size, description: "Your health", scene: self, size: "Small", indicators: [UxTutorialIndicatorPosition.topLeft], key: tutorialKeyHearts, version: tutorialVersionHearts, onComplete: onCompleteUxTooltip!)
            tutHp.containerBackground.position = CGPoint(x: self.healthNodes[0].position.x + tutHp.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.frame.width/2, y: self.healthNodes[0].position.y - self.healthNodes[0].size.height / 2 - self.buttonBuffer * 2 - tutHp.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
            self.uxTutorialTooltips!.append(tutHp)
            self.addChild(tutHp)
        }
        
        // minion hearts
        let tutorialKeyBlackHearts = "UXTutorialBlackHearts"
        let tutorialVersionBlackHearts: Double = 1.0
        let storedTutorialBlackHearts: Double? = GameData.sharedGameData.tutorialsAcknowledged[tutorialKeyBlackHearts]
        
        if storedTutorialBlackHearts == nil || floor(storedTutorialBlackHearts!) != floor(tutorialVersionBlackHearts) {
            // minion hearts
            let tutBlackHearts = UXTutorialDialog(frameSize: self.size, description: "Minions defeated", scene: self, size: "Small", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKeyBlackHearts, version: tutorialVersionBlackHearts, onComplete: onCompleteUxTooltip!)
            tutBlackHearts.containerBackground.position = CGPoint(x: self.blackHeart!.position.x - self.blackHeart!.size.width - self.frame.width/2, y: self.healthNodes[0].position.y - self.healthNodes[0].size.height / 2 - self.buttonBuffer * 2 - tutBlackHearts.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
            self.uxTutorialTooltips!.append(tutBlackHearts)
            self.addChild(tutBlackHearts)
        }
        
        // Level progress
        let tutorialKeyLevelProgress = "UXTutorialLevelProgress"
        let tutorialVersionLevelProgress: Double = 1.0
        let storedTutorialLevelProgress: Double? = GameData.sharedGameData.tutorialsAcknowledged[tutorialKeyLevelProgress]
        
        if storedTutorialLevelProgress == nil || floor(storedTutorialLevelProgress!) != floor(tutorialVersionLevelProgress) {
            // Level progress
            let tutLevelProgress = UXTutorialDialog(frameSize: self.size, description: "Distance traveled", scene: self, size: "Small", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKeyLevelProgress, version: tutorialVersionLevelProgress, onComplete: onCompleteUxTooltip!)
            tutLevelProgress.containerBackground.position = CGPoint(x: self.progressBar.position.x - self.frame.width/2, y: self.healthNodes[0].position.y - self.healthNodes[0].size.height / 2 - self.buttonBuffer * 2 - tutLevelProgress.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
            self.uxTutorialTooltips!.append(tutLevelProgress)
            self.addChild(tutLevelProgress)
        }
        
        // Pause
        let tutorialKeyPause = "UXTutorialPause"
        let tutorialVersionPause: Double = 1.0
        let storedTutorialPause: Double? = GameData.sharedGameData.tutorialsAcknowledged[tutorialKeyPause]
        
        if storedTutorialPause == nil || floor(storedTutorialPause!) != floor(tutorialVersionPause) {
            // Pause
            let tutPause = UXTutorialDialog(frameSize: self.size, description: "Pause and settings", scene: self, size: "Small", indicators: [UxTutorialIndicatorPosition.topRight], key: tutorialKeyPause, version: tutorialVersionPause, onComplete: onCompleteUxTooltip!)
            let tutPauseXPosition = self.pauseButton!.position.x - tutPause.containerBackground.calculateAccumulatedFrame().size.width / 2 + self.buttonBuffer * 2 - self.frame.width/2
            let tutPauseYPosition = self.healthNodes[0].position.y - self.healthNodes[0].size.height / 2 - self.buttonBuffer * 2 - tutPause.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2
            tutPause.containerBackground.position = CGPoint(x: tutPauseXPosition, y: tutPauseYPosition)
            self.uxTutorialTooltips!.append(tutPause)
            self.addChild(tutPause)
        }
        
        // Always get the skill1button because it is hidden
        if true {
            let skillKey = GameData.sharedGameData.selectedCharacter.rawValue + "_skills_" + self.skill1Button!.upgradeDetails!.upgrade.rawValue
            let skillTutorialText = self.skill1Button!.upgradeDetails!.tutorialText
            let skillTutorialVersion = self.skill1Button!.upgradeDetails!.tutorialVersion
            
            let storedTutorialSkill: Double? = GameData.sharedGameData.tutorialsAcknowledged[skillKey]
            
            if storedTutorialSkill == nil || floor(storedTutorialSkill!) != floor(skillTutorialVersion) {
                let tutSkill = UXTutorialDialog(frameSize: self.size, description: skillTutorialText, scene: self, size: "Large", indicators: [UxTutorialIndicatorPosition.topCenter, UxTutorialIndicatorPosition.bottomCenter, UxTutorialIndicatorPosition.leftMiddle, UxTutorialIndicatorPosition.rightMiddle], key: skillKey, version: skillTutorialVersion, onComplete: onCompleteUxTooltip!)
                tutSkill.containerBackground.position = CGPoint(x: 0, y: 0)
                self.uxTutorialTooltips!.append(tutSkill)
                self.addChild(tutSkill)
            }
        }
        
        // For buttons 2-5, only get their skill if they aren't hidden
        if self.skill2Button?.isHidden == false {
            let skillKey = GameData.sharedGameData.selectedCharacter.rawValue + "_skills_" + self.skill2Button!.upgradeDetails!.upgrade.rawValue
            let skillTutorialText = self.skill2Button!.upgradeDetails!.tutorialText
            let skillTutorialVersion = self.skill2Button!.upgradeDetails!.tutorialVersion
            
            let storedTutorialSkill: Double? = GameData.sharedGameData.tutorialsAcknowledged[skillKey]
            
            if storedTutorialSkill == nil || floor(storedTutorialSkill!) != floor(skillTutorialVersion) {
                let tutSkill = UXTutorialDialog(frameSize: self.size, description: skillTutorialText, scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.bottomRight], key: skillKey, version: skillTutorialVersion, onComplete: onCompleteUxTooltip!)
                tutSkill.containerBackground.position = CGPoint(x: self.skill2Button!.position.x - tutSkill.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.frame.width/2, y: self.skill2Button!.position.y + self.skill2Button!.size.height / 2 + self.buttonBuffer * 4 + tutSkill.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
                self.uxTutorialTooltips!.append(tutSkill)
                self.addChild(tutSkill)
            }
        }
        
        if self.skill3Button?.isHidden == false {
            let skillKey = GameData.sharedGameData.selectedCharacter.rawValue + "_skills_" + self.skill3Button!.upgradeDetails!.upgrade.rawValue
            let skillTutorialText = self.skill3Button!.upgradeDetails!.tutorialText
            let skillTutorialVersion = self.skill3Button!.upgradeDetails!.tutorialVersion
            
            let storedTutorialSkill: Double? = GameData.sharedGameData.tutorialsAcknowledged[skillKey]
            
            if storedTutorialSkill == nil || floor(storedTutorialSkill!) != floor(skillTutorialVersion) {
                let tutSkill = UXTutorialDialog(frameSize: self.size, description: skillTutorialText, scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.bottomRight], key: skillKey, version: skillTutorialVersion, onComplete: onCompleteUxTooltip!)
                tutSkill.containerBackground.position = CGPoint(x: self.skill3Button!.position.x - tutSkill.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.frame.width/2, y: self.skill3Button!.position.y + self.skill3Button!.size.height / 2 + self.buttonBuffer * 4 + tutSkill.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
                self.uxTutorialTooltips!.append(tutSkill)
                self.addChild(tutSkill)
            }
        }
        
        if self.skill4Button?.isHidden == false {
            let skillKey = GameData.sharedGameData.selectedCharacter.rawValue + "_skills_" + self.skill4Button!.upgradeDetails!.upgrade.rawValue
            let skillTutorialText = self.skill4Button!.upgradeDetails!.tutorialText
            let skillTutorialVersion = self.skill4Button!.upgradeDetails!.tutorialVersion
            
            let storedTutorialSkill: Double? = GameData.sharedGameData.tutorialsAcknowledged[skillKey]
            
            if storedTutorialSkill == nil || floor(storedTutorialSkill!) != floor(skillTutorialVersion) {
                let tutSkill = UXTutorialDialog(frameSize: self.size, description: skillTutorialText, scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.bottomLeft], key: skillKey, version: skillTutorialVersion, onComplete: onCompleteUxTooltip!)
                tutSkill.containerBackground.position = CGPoint(x: self.skill4Button!.position.x + tutSkill.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.frame.width/2, y: self.skill4Button!.position.y + self.skill4Button!.size.height / 2 + self.buttonBuffer * 4 + tutSkill.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
                self.uxTutorialTooltips!.append(tutSkill)
                self.addChild(tutSkill)
            }
        }
        
        if self.skill5Button?.isHidden == false {
            let skillKey = GameData.sharedGameData.selectedCharacter.rawValue + "_skills_" + self.skill5Button!.upgradeDetails!.upgrade.rawValue
            let skillTutorialText = self.skill5Button!.upgradeDetails!.tutorialText
            let skillTutorialVersion = self.skill5Button!.upgradeDetails!.tutorialVersion
            
            let storedTutorialSkill: Double? = GameData.sharedGameData.tutorialsAcknowledged[skillKey]
            
            if storedTutorialSkill == nil || floor(storedTutorialSkill!) != floor(skillTutorialVersion) {
                let tutSkill = UXTutorialDialog(frameSize: self.size, description: skillTutorialText, scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.bottomLeft], key: skillKey, version: skillTutorialVersion, onComplete: onCompleteUxTooltip!)
                tutSkill.containerBackground.position = CGPoint(x: self.skill5Button!.position.x + tutSkill.containerBackground.calculateAccumulatedFrame().size.width / 2 - self.frame.width/2, y: self.skill5Button!.position.y + self.skill5Button!.size.height / 2 + self.buttonBuffer * 4 + tutSkill.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.frame.height/2)
                self.uxTutorialTooltips!.append(tutSkill)
                self.addChild(tutSkill)
            }
        }
    }
    
    func displayChallenges() {
        if self.levelChallenges.count > 0 && GameData.sharedGameData.getSelectedCharacterData().challengesUnlocked(self.currentLevel) {
            self.challengeDialog!.isHidden = false
            
            self.showPauseMenu = false
        } else {
            self.displayTutorialTooltip()
        }
    }
    
    func addHeartsToPlayer(_ hearts: Int, special: Bool) {
        //GameData.sharedGameData.getSelectedCharacterData().lastHeartBoost = hearts
        
        if hearts > 0 {
            // Need to add the hearts to the player. Need to update player and update UX and update GameData.sharedGameData.getSelectedCharacterData().lastHeartBoost
            self.player.updateMaxHearts(hearts)
            self.addHeartsToHud(hearts, special: special)
        }
    }

    func addHeartsToHud(_ hearts: Int, special: Bool) {
        // However many, create that many more heart buttons
        let currentHearts = self.healthNodes.count
        let maxHealth = Int(self.player.maxHealth)
        
        //for var i = currentHearts + 1; i <= maxHealth; i += 1 {
        for i in currentHearts + 1...maxHealth {
            let healthNode = PlayerHeartButton(scene: self)
            healthNode.position = CGPoint(x: healthNode.size.width * CGFloat(i) + (4.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * CGFloat(i)) - (healthNode.size.width / 2.0) + 4 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), y: self.healthNodes[0].position.y)
            
            self.addChild(healthNode)
            
            healthNode.releaseButtonSpecialColor()
            
            self.healthNodes.append(healthNode)
        }
    }
    
    override func displayTutorialTooltip() -> Void {
        // If the UX tut array has objects, pop one, display it.
        if (self.uxTutorialTooltips!.count > 0) {
            let tooltip = self.uxTutorialTooltips!.first
            self.uxTutorialTooltips!.remove(at: 0)
            tooltip!.zPosition = 14.0
            
            self.showPauseMenu = false
            tooltip!.isHidden = false
        } else {
            if AdSupporter.sharedInstance.showPauseMenu {
                self.unpauseGame()
                self.showPauseMenu = true
                self.pauseGame()
                AdSupporter.sharedInstance.showPauseMenu = false
            } else {
                self.unpauseGame()
                AdSupporter.sharedInstance.showPauseMenu = false
            }
        }
    }
    
    // This function is called for each frame
    override func update(_ currentTime: TimeInterval) {
        self.playMusic()
        
        /*
        if !self.levelIntroTextShown! {
            self.levelIntroText!.isHidden = false
            //self.levelIntroText!.run(self.levelIntroTextAction!)
            self.levelIntroTextShown = true
        }*/
        
        // Check for scene pausing by system so we stop the game
        if self.isPaused || (self.view != nil && self.view!.isPaused) {
            self.pauseGame()
        }
        
        // Only update if not paused
        if !self.worldView.isPaused {
            
            // Handle time delta.
            // If we drop below 60fps, we still want everything to move the same distance.
            self.timeSinceLast = currentTime - self.lastUpdateTimeInterval
            self.lastUpdateTimeInterval = currentTime
            
            if self.timeSinceLast > 1 {// more than a second since last update
                self.timeSinceLast = 1.0 / 60.0
                self.lastUpdateTimeInterval = currentTime
            }
            
            self.updateWithTime(timeSinceLast)
        }
    }
    
    func updateWithTime(_ timeSinceLast: CFTimeInterval) {
        // Calculate the time since last monster spawn
        // self.lastSpawnTimeInterval += timeSinceLast
        
        // Update the player
        self.player.update(timeSinceLast)
        
        // Update the buttons
        self.skill1Button!.update(self.player, timeSinceLast: timeSinceLast)
        self.skill2Button!.update(self.player, timeSinceLast: timeSinceLast)
        self.skill3Button!.update(self.player, timeSinceLast: timeSinceLast)
        self.skill4Button!.update(self.player, timeSinceLast: timeSinceLast)
        self.skill5Button!.update(self.player, timeSinceLast: timeSinceLast)
        self.skill6Button!.update(self.player, timeSinceLast: timeSinceLast)
        
        let updatePosition = (self.frame.size.width - horizontalPlayerLimitRight) + (100 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        let projectileDestroyPosition = (self.frame.size.width - horizontalPlayerLimitRight) + (20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        // Add environment objects
        for envObject in self.environmentObjectsToAdd {
            if envObject.type == EnvironmentObjectType.Enemy ||
                envObject.type == EnvironmentObjectType.Obstacle ||
                envObject.type == EnvironmentObjectType.Projectile {
                envObject.zPosition = GameScene.ENEMY_Z
                
                if envObject.position.x - self.player.position.x < updatePosition {
                    //self.addEnvironmentObject(environmentObject: envObject)
                    envObject.physicsBody!.isDynamic = true
                    envObject.runAnimation()
                    
                    // Remove it from the array
                    self.environmentObjectsToAdd.remove(at: self.environmentObjectsToAdd.index(of: envObject)!)
                }
            }
        }
        
        
        // Iterate through player projectiles and remove them if off screen
        for projectile in self.worldViewPlayerProjectiles {
            if projectile.type == EnvironmentObjectType.PlayerProjectile {
                if abs(projectile.position.x - self.player.position.x) > projectileDestroyPosition {
                    //if projectile.position.x - self.player.position.x > self.frame.size.width {
                        // This is off screen remove from parent
                        projectile.removeAllActions()
                        projectile.executeDeath()
                    //}
                }
            }
        }
        
        // Iterate through all enemies and update them
        for envObject in self.worldViewEnvironmentObjects {
            if (envObject.type == EnvironmentObjectType.Enemy ||
                envObject.type == EnvironmentObjectType.Obstacle ||
                envObject.type == EnvironmentObjectType.Projectile) && envObject.physicsBody!.isDynamic {
                // Check for destroyable obstacle destroyed
                if envObject is Obstacle && envObject.playerCanDamage && envObject.readyToBeDestroyed {
                    self.collectedLevelDestroyableObstacles += 1
                    
                    // Remove from parent
                    self.removeEnvironmentObject(environmentObject: envObject)
                } else if envObject.position.x - self.player.position.x < updatePosition {
                    // Update the enemy
                    envObject.update(timeSinceLast, withPlayer: self.player)
                    
                    // If the object is now dead, remove it. If it was an enemy, add to the collectedLevelEnemyHealth
                    if !envObject.isAlive && !envObject.heartsCollected && envObject.hasHeartsToCollect {
                        // Add to collectedEnemyHealth
                        self.collectedLevelEnemyHealth += envObject.maxHealth
                        
                        // Run the minion heart animation
                        self.blackHeart!.run(self.blackHeartAction!)
                        
                        // Mark so we don't double count it
                        envObject.heartsCollected = true
                    } else if envObject.position.x + 600 < self.player.position.x || envObject.readyToBeDestroyed { // Is off the screen enough so that if the player gets knocked back it is gone
                        // Remove from parent
                        self.removeEnvironmentObject(environmentObject: envObject)
                    }
                }
            }
        }
    }
    
    func createEnvironmentalObjects() {
        // Loop through the list and determine if anything is close to the player and is not createable
        for object: MapObject in mapObjectArray {
            // Add the object
            self.createEnvironmentalObjectWithName(object.name, andPosition: object.position, value1: object.value1, value2: object.value2)
        }
    }
    
    override func didSimulatePhysics() {
        // Only update if not paused
        if !self.worldView.isPaused {
            // Update player after physics
            self.player.updateAfterPhysics()
            
            // Iterate through all player projectiles
            for projectile in self.worldViewPlayerProjectiles {
                if projectile.type == EnvironmentObjectType.PlayerProjectile {
                    projectile.updateAfterPhysics()
                } else {
                    projectile.physicsBody!.velocity = CGVector()
                }
            }
            
            // Iterate through all enemies and update them after physics
            for envObject in self.worldViewEnvironmentObjects {
                if (envObject.type == EnvironmentObjectType.Enemy ||
                    envObject.type == EnvironmentObjectType.Obstacle ||
                    envObject.type == EnvironmentObjectType.Projectile) && envObject.physicsBody!.isDynamic {
                    if envObject.position.x - self.player.position.x < self.frame.size.width * 1.1 {
                        // Update the enemy
                        envObject.updateAfterPhysics()
                    }
                }
            }
            
            // Calculate player vs background movement
            // Player has moved beyond one of the left or right limits
            if (self.player.previousPosition.x >= (-self.worldView.position.x + horizontalPlayerLimitRight) && self.player.position.x > self.player.previousPosition.x) || (self.player.previousPosition.x <= (-self.worldView.position.x + horizontalPlayerLimitLeft) && self.player.position.x < self.player.previousPosition.x) {
                
                // Move the world
                self.moveWorld(CGPoint(x: self.player.position.x - self.player.previousPosition.x, y: 0.0))
                
                // We need to update the background in case one of the 2 tiles is now off the screen
                self.moveBackground(CGPoint(x: (self.player.position.x - self.player.previousPosition.x) * 0.8, y: 0), backgroundArray: worldViewBackgrounds)
                self.moveBackground(CGPoint(x: (self.player.position.x - self.player.previousPosition.x) * 0.0005, y: 0), backgroundArray: worldViewForegrounds)
            }
            
            // Move the ground along with the world view so that it is always there for objects to stand on
            self.ground.position = CGPoint(x: -self.worldView.position.x + self.frame.size.width, y: groundPositionY)
            
            // Update the heads up display
            self.updateHUD()
            
            if !levelEnded {
                // Check is the level is over
                self.checkLevelOver() // REJUV - check here?
            } else if !self.displayingEndOfLevel {
                self.displayingEndOfLevel = true
                
                self.beginLevelEnding()
            }
        }
    }
    
    override func didFinishUpdate() {
        // Only update if not paused
        if !self.worldView.isPaused {
            self.player.updateAfterConstraints()
        }
    }
    
    func checkLevelOver() {
        // End the scene.
        if self.player.position.x > self.totalLevelDistance || self.player.health <= 0 { // Player died
            self.levelEnded = true
        }
    }
    
    func beginLevelEnding() {
        // End the scene.
        if self.player.position.x > self.totalLevelDistance { // Victory
            // Have the player victory animation start
            self.player.completeLevel()
            
            SoundHelper.sharedInstance.playSound(self, sound: SoundType.Victory)
            
            // TODO eval - let's see if we stop memory leaks
            self.tearDownEnvObjects()
            self.endLevel(self.totalLevelDistance)
        }
        if self.player.health <= 0 { // Player died
            if self.rejuvAllowed {
                // TODO REJUV: If reivivng -  5. set rejuvallowed to false 6. stop the animation/hide dialog (actually do this when it is purchased)
                // REJUV purchase - can we make it purchase the heart boost automatically if the player goes and buys gems (same with other places in game when player gets purchase prompt?) - or instead, need it to stick around but have dismiss dialog, or just have it last 5 seconds or something a little longer
                
                // REJUV: Store position of player
                self.rejuvPosition = CGPoint(x: self.player.position.x, y: self.player.defaultPositionY)
                self.rejuvDialog!.run(self.rejuvHeartDialogAction, withKey: "rejuvDialog")
                self.rejuvAllowed = false
                self.promptingForRejuv = true
                self.showPauseMenu = false
                self.pauseGame()
            } else if !self.promptingForRejuv {
                // Note - due to player death and update phase, the death animation will automatically start
                SoundHelper.sharedInstance.playSound(self, sound: SoundType.Defeat)
                
                // TODO eval - let's see if we stop memory leaks
                self.tearDownEnvObjects()
                self.endLevel(self.player.position.x)
            }
        }
    }
    
    // Call when we're ready to rejuvenate
    func rejuvenatePlayer() {
        // Make sure we dismiss the video dialog
        //Chartboost.closeImpression()
        
        // Rejuvenate player and remove dialog through 1 sec slideout
        var hearts = 2
        if self.worldNumber > 3 {
            hearts += 1
        }
        if self.worldNumber > 5 {
            hearts += 1
        }
        if self.worldNumber > 6 {
            hearts += 1
        }
        self.rejuvPlayer(hearts)
        self.dismissRejuvDialogStayPaused()
        self.showPauseMenu = true
        self.pauseGame()
    }
    
    func setRejuvDialogDisplayed() {
        self.rejuvDialog!.removeAllActions()
        self.removeAction(forKey: ACTION_KEY_REJUV_DIALOG)
        self.rejuvDialog!.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.unhideRejuvDialog()
    }
    
    func unhideRejuvDialog() {
        self.rejuvDialog!.toggleRejuvVideo()
        self.rejuvDialog!.isHidden = false
    }
    
    func dismissRejuvDialog() {
        //setRejuvDialogDisplayed()
        self.rejuvDialog!.run(self.rejuvHeartDialogDismissAction, withKey: ACTION_KEY_REJUV_DIALOG)
        
        if self.playerRejuved == false {
            self.rejuvAllowed = false
        }
    }
    
    func dismissRejuvDialogStayPaused() {
        //setRejuvDialogDisplayed()
        self.rejuvDialog!.run(self.rejuvHeartDialogDismissStayPausedAction, withKey: ACTION_KEY_REJUV_DIALOG)
        
        if self.playerRejuved == false {
            self.rejuvAllowed = false
        }
    }
    
    func dismissRejuvDialogAndEndLevel() {
        if self.playerRejuved == false {
            self.rejuvAllowed = false
        }
        
        self.rejuvDialog!.removeAllActions() // Test
        self.rejuvDialog!.run(SKAction.sequence([self.rejuvHeartDialogDismissAction, SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.displayingEndOfLevel = true
            
                self?.beginLevelEnding()
            }
        })]), withKey: ACTION_KEY_REJUV_DIALOG)

    }
    
    func dismissRejuvDialogWaitAndEndLevel() {
        // Make sure we dismiss the video dialog
        //Chartboost.closeImpression()
        
        self.rejuvDialog!.run(self.rejuvHeartDialogWaitThenDismissAndEndLevelAction, withKey: ACTION_KEY_REJUV_DIALOG)
    }
    
    func createRejuvDialog() {
        self.rejuvDialog = RejuvDialog(frameSize: self.size, scene: self, gemCost: 2 + self.worldNumber)
        self.rejuvDialog!.color = MerpColors.nothing
        self.rejuvDialog!.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height + self.rejuvDialog!.calculateAccumulatedFrame().size.height / 2)
        self.addChild(self.rejuvDialog!)
        self.rejuvDialog!.zPosition = 14
        self.rejuvDialog!.isHidden = true
        
        // Start the new action
        // Main combos
        self.rejuvHeartDialogDisplayAction = SKAction.sequence([
            SKAction.run({
                [weak self] in
                
                if self != nil {
                    self?.rejuvDialog!.toggleRejuvVideo()
                    self?.rejuvDialog!.isHidden = false
                }
            }),
            SKAction.move(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2), duration: 0.25),
            ])
        
        self.rejuvHeartDialogDismissAction = SKAction.sequence([
            SKAction.move(to: CGPoint(x: self.frame.size.width / 2, y: 0 - self.rejuvDialog!.calculateAccumulatedFrame().size.height / 2), duration: 0.25),
            SKAction.run({
                [weak self] in
                
                if self != nil {
                    self?.rejuvDialog!.isHidden = true
                    self?.promptingForRejuv = false
                    self?.unpauseGame()
                }
                })
            ])
        
        self.rejuvHeartDialogDismissStayPausedAction = SKAction.sequence([
            SKAction.move(to: CGPoint(x: self.frame.size.width / 2, y: 0 - self.rejuvDialog!.calculateAccumulatedFrame().size.height / 2), duration: 0.25),
            SKAction.run({
                [weak self] in
                
                if self != nil {
                    self?.rejuvDialog!.isHidden = true
                    self?.promptingForRejuv = false
                }
                })
            ])
        
        self.rejuvHeartDialogWaitAction = SKAction.wait(forDuration: 3)
        
        // Other combos
        self.rejuvHeartDialogDismissAndEndLevelAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.dismissRejuvDialogAndEndLevel()
            }
        })
        
        self.rejuvHeartDialogWaitThenDismissAndEndLevelAction = SKAction.sequence([self.rejuvHeartDialogWaitAction, self.rejuvHeartDialogDismissAndEndLevelAction])
        
        self.rejuvHeartDialogAction = SKAction.sequence([self.rejuvHeartDialogDisplayAction, self.rejuvHeartDialogWaitAction, self.rejuvHeartDialogDismissAndEndLevelAction])
    }
    
    func rejuvPlayer(_ numberOfHearts: Int) {
        // We want these to go back to how they were
        self.levelEnded = false
        self.displayingEndOfLevel = false
        self.playerRejuved = true
        
        // Hide stuff
        self.rejuvDialog!.isHidden = true
        
        // Reset the player
        self.player.rejuvPlayer(position: self.rejuvPosition, numberOfHearts: numberOfHearts)
    }
    
    func endLevel(_ distance: CGFloat) {
        if self.score == nil {
            self.updateLevelData(distance)
        }
        
        if storyEndDialogs!.count <= 0 || GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.currentLevel]!.starsEarnedHighScore < 2 {
            self.unpauseGame()
            
            // Load the dialog
            self.loadEndOfLevelDialog(self.score!)
        } else {
            self.showPauseMenu = false
            self.pauseGame()
            self.storyEndDialogs![0].isHidden = false
        }
    }
    
    func updateLevelDataWithoutScore() {
        GameData.sharedGameData.getSelectedCharacterData().incrementTimesPlayed(levelNumber: self.currentLevel)
    }
    
    func updateLevelData(_ distance: CGFloat) {
        // Update and save data
        let score = GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.currentLevel]!.updateLevelData(self.collectedLevelEnemyHealth, distanceTraveled: distance, heartsRemaining: self.player.health, worldNumber: self.worldNumber, levelNumber: self.currentLevel)
        
        // Update all the score info
        GameData.sharedGameData.getSelectedCharacterData().updateScores(score, worldNumber: self.worldNumber, levelNumber: self.currentLevel)
        
        // Calculate scores
        self.calculateScores(score)
        
        // Store gold heart count
        GameData.sharedGameData.getSelectedCharacterData().goldHearts = self.player.goldHearts
        
        // Update times played for game
        GameData.sharedGameData.promptRateMeCountdown -= 1
        
        self.score = score
    }
    
    func loadEndOfLevelDialog(_ score: LevelScore) {
        // Video reward - cache
        //self.viewController!.cacheRewardedVideo()
        // Interstitial
        //self.viewController!.cacheInterstitialAd()
        
        // Check for levels completed if they are completed keep them in there
        var levelsUnlocked = Array<Int>()
        
        if self.levelCompletion.count > 0 {
            for i in 0...self.levelCompletion.count - 1 {
                if !GameData.sharedGameData.getSelectedCharacterData().isLevelLocked(self.levelCompletion[i]) {
                    levelsUnlocked.append(self.levelCompletion[i])
                }
            }
        }
        
        // Apply the score (includes challenges)
        self.endOfLevelDialog.applyScore(score, completedChallenges: self.completedChallenges, unlockedLevels: levelsUnlocked)
        
        // Check achievements
        GameKitHelper.sharedInstance.checkAchievements(score)
        self.viewController!.syncAchievements()
        
        // Display it
        self.endOfLevelDialog.displayEndOfLevelDialog()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Only do this if the game isn't paused
        
        if !self.worldView.isPaused {
            // Check for any children buttons to see if they were touches
            // For loop on touches and set boolean on which buttons contain a point
            for touch: UITouch in touches {
                
                // Get the location of the touch
                let location: CGPoint = touch.location(in: self)
                
                if !self.skill1Button!.isHidden && self.skill1Button!.contains(location) {
                    self.skill1Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill1Button
                } else if !self.skill2Button!.isHidden && self.skill2Button!.contains(location) {
                    self.skill2Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill2Button
                } else if !self.skill3Button!.isHidden && self.skill3Button!.contains(location) {
                    self.skill3Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill3Button
                } else if !self.skill4Button!.isHidden && self.skill4Button!.contains(location) {
                    self.skill4Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill4Button
                } else if !self.skill5Button!.isHidden && self.skill5Button!.contains(location) {
                    self.skill5Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill5Button
                } else if !self.skill6Button!.isHidden && self.skill6Button!.contains(location) {
                    self.skill6Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill6Button
                } else if !self.pauseButton!.isHidden && self.pauseButton!.contains(location) {
                    self.pauseButton?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.pauseButton
                } else { // We want any screen touch to jump
                    self.skill1Button?.allowAnywhereOnScreen = true
                    self.skill1Button?.touchesBegan(touches, with: event)
                    self.objectThatHadATouchEventPassedIn = self.skill1Button
                }
            }
            
            if self.objectThatHadATouchEventPassedIn == nil {
                super.touchesBegan(touches, with: event)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.objectThatHadATouchEventPassedIn != nil {
            self.objectThatHadATouchEventPassedIn?.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.objectThatHadATouchEventPassedIn != nil {
            self.objectThatHadATouchEventPassedIn?.touchesEnded(touches, with: event)
        } else {
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.objectThatHadATouchEventPassedIn != nil {
            self.objectThatHadATouchEventPassedIn?.touchesCancelled(touches, with: event)
        } else {
            super.touchesCancelled(touches, with: event)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Transparent Player and Enemy
        if self.transparentEnemyContacts.count > 0 && firstBody.categoryBitMask & GameScene.transparentPlayerCategory != 0 && ((secondBody.categoryBitMask & GameScene.enemyCategory) != 0 || (secondBody.categoryBitMask & GameScene.transparentEnemyCategory) != 0) {
            let enemy: Enemy = secondBody.node as! Enemy
            
            self.removeFromTransparentEnemyContacts(enemy)
        }
        
        // Transparent Player and Obstacle
        if self.transparentObstacleContacts.count > 0 && firstBody.categoryBitMask & GameScene.transparentPlayerCategory != 0 && ((secondBody.categoryBitMask & GameScene.obstacleCategory) != 0 || (secondBody.categoryBitMask & GameScene.transparentObstacleCategory) != 0) {
            let obstacle: Obstacle = secondBody.node as! Obstacle
            
            self.removeFromTransparentObstacleContacts(obstacle)
        }
        
        // Transparent Player and Projectile
        if self.transparentProjectileContacts.count > 0 && firstBody.categoryBitMask & GameScene.transparentPlayerCategory != 0 && (secondBody.categoryBitMask & GameScene.projectileCategory) != 0 {
            let projectile: Projectile = secondBody.node as! Projectile
            
            self.removeFromTransparentProjectileContacts(projectile)
        }
    }
    
    func removeFromTransparentEnemyContacts(_ object: SKNode) {
        let index = self.getIndexOfItemByName(object, list: self.transparentEnemyContacts)
        if index > -1  {
            self.transparentEnemyContacts.remove(at: index)
        }
    }
    
    func removeFromTransparentProjectileContacts(_ object: SKNode) {
        let index = self.getIndexOfItemByName(object, list: self.transparentProjectileContacts)
        if index > -1  {
            self.transparentProjectileContacts.remove(at: index)
        }
    }
    
    func removeFromTransparentObstacleContacts(_ object: SKNode) {
        let index = self.getIndexOfItemByName(object, list: self.transparentObstacleContacts)
        if index > -1  {
            self.transparentObstacleContacts.remove(at: index)
        }
    }
    
    func getIndexOfItemByName(_ item: SKNode, list: Array<SKNode>) -> Int {
        for listItem in list {
            if listItem.name == item.name {
                return list.index(of: listItem)!
            }
        }
        
        return -1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Player and Environment Object (Obstacle or Enemy) [Collisions]
        if (firstBody.categoryBitMask & GameScene.playerCategory) != 0 && ((secondBody.categoryBitMask & GameScene.obstacleCategory) != 0 || (secondBody.categoryBitMask & GameScene.enemyCategory) != 0) {
            self.playerDidCollideWithEnvironmentObject(firstBody.node as! Player, object: secondBody.node as! EnvironmentObject)
        }
        
        // Player and Environment Object (Obstacle or Enemy) [Contact]
        else if ((firstBody.categoryBitMask & GameScene.playerCategory) != 0 /*|| (firstBody.categoryBitMask & GameScene.transparentPlayerCategory) != 0*/) && ((secondBody.categoryBitMask & GameScene.transparentEnemyCategory) != 0 || (secondBody.categoryBitMask & GameScene.transparentObstacleCategory) != 0) {
            self.playerDidContactWithEnvironmentObject(firstBody.node as! Player, object: secondBody.node as! EnvironmentObject)
        }
        
        // Player and Environment Object (Projectile)
        else if (firstBody.categoryBitMask & GameScene.playerCategory) != 0 && (secondBody.categoryBitMask & GameScene.projectileCategory) != 0 {
            self.playerDidContactWithEnvironmentObject(firstBody.node as! Player, object: secondBody.node as! EnvironmentObject)
        }
        
        // Player Projectile and Environment Object
        else if (firstBody.categoryBitMask & GameScene.playerProjectileCategory) != 0 && ((secondBody.categoryBitMask & GameScene.obstacleCategory) != 0 || (secondBody.categoryBitMask & GameScene.enemyCategory) != 0) {
            self.playerProjectileDidCollideWithEnvironmentObject(firstBody.node as! PlayerProjectile, object: secondBody.node as! EnvironmentObject)
        }
            
        // Player Projectile and Ground
        else if (firstBody.categoryBitMask & GameScene.groundCategory) != 0 && (secondBody.categoryBitMask & GameScene.playerProjectileCategory) != 0 {
            self.playerProjectileDidCollideWithGround(secondBody.node as! PlayerProjectile)
        }
        
        // Ground and player collision
        else if (firstBody.categoryBitMask & GameScene.groundCategory) != 0 && ((secondBody.categoryBitMask & GameScene.playerCategory) != 0 || (secondBody.categoryBitMask & GameScene.transparentPlayerCategory) != 0) {
            
            // If the player was jumping, stop the jump // TODO integrate with new skill system
            if self.player.isJumping {
                self.player.isStoppingJump = true
            }
            
            // Player is back on the ground
            self.player.isOnGround = true
            
            // Update skills now that we're back on ground
            self.player.updateSkillsBasedOnPlayerPosition()
        }
        
        // Ground and Environment Object collision
        else if (firstBody.categoryBitMask & GameScene.groundCategory) != 0 && ((secondBody.categoryBitMask & GameScene.obstacleCategory) != 0 || (secondBody.categoryBitMask & GameScene.enemyCategory) != 0 || (secondBody.categoryBitMask & GameScene.projectileCategory) != 0) {
            let object: EnvironmentObject = secondBody.node as! EnvironmentObject
            
            object.collisionWithGround()
        }
        
        // **** Transparent ****
        // Transparent Player and Enemy
        else if (firstBody.categoryBitMask & GameScene.transparentPlayerCategory) != 0 && ((secondBody.categoryBitMask & GameScene.enemyCategory) != 0 || (secondBody.categoryBitMask & GameScene.transparentEnemyCategory) != 0) {
            self.transparentEnemyContacts.append(secondBody.node as! Enemy)
        }
        
        // Transparent Player and Obstacle
        else if (firstBody.categoryBitMask & GameScene.transparentPlayerCategory) != 0 && ((secondBody.categoryBitMask & GameScene.obstacleCategory) != 0 || (secondBody.categoryBitMask & GameScene.transparentObstacleCategory) != 0) {
            self.transparentObstacleContacts.append(secondBody.node as! Obstacle)
        }
        
        // Transparent Player and Projectile
        else if (firstBody.categoryBitMask & GameScene.transparentPlayerCategory) != 0 && (secondBody.categoryBitMask & GameScene.projectileCategory) != 0 {
            self.transparentProjectileContacts.append(secondBody.node as! Projectile)
        }
    }
    
    
    func playerProjectileDidCollideWithEnvironmentObject(_ projectile: PlayerProjectile, object: EnvironmentObject) {
        if object.isAlive {
            object.takeDamage(projectile.damage)
            
            projectile.takeHit()
        }
    }
    
    func playerProjectileDidCollideWithGround(_ projectile: PlayerProjectile) {
        projectile.contactWithGround()
    }
    
    func playerDidCollideWithEnvironmentObject(_ player: Player, object: EnvironmentObject) {
        player.engageWithEnvironmentObject(object)
        object.engageWithPlayer(player)
    }
    
    func playerDidContactWithEnvironmentObject(_ player: Player, object: EnvironmentObject) {
        player.contactWithEnvironmentObject(object)
            
        if (object.playerCanDamage) {
            object.engageWithPlayer(player)
        } else {
            object.playerContactWithoutDamage()
        }
    }
    
    func createEnvironmentalObjectWithName(_ name: String, andPosition position: CGFloat, value1: Double, value2: Double) {
        if let envObjectClass = NSClassFromString(name) as? EnvironmentObject.Type {
            let envObject = envObjectClass.init(scalar: 1, defaultYPosition: adjustedGroundPositionY, defaultXPosition: position, parent: self.worldView, value1: value1, value2: value2, scene: self)
            
            // If this is an enemy class, make sure the getHealth was implemented in the Enemy call
            if let enemyClass = NSClassFromString(name) as? Enemy.Type {
                if enemyClass.getHealth(enemyClass) != envObject.maxHealth {
                    preconditionFailure("The enemy health static function was not updated for this enemy type. See getHealth() in Enemy.swift.")
                }
            }
            
            // If this is an obstacle class, add destroyable count
            if (NSClassFromString(name) as? Obstacle.Type) != nil {
                if envObject.playerCanDamage {
                    self.totalLevelDestroyableObstacles += 1
                }
            }
            
            let updatedEnvObject : EnvironmentObject = envObject
            // Create the env object on the right of the screen. TODO change - for testing purposes only right now
            updatedEnvObject.position = CGPoint(x: position, y: updatedEnvObject.defaultYPosition)
            
            // Add the env object to the scene
            self.environmentObjectsToAdd.append(updatedEnvObject)
            self.addEnvironmentObject(environmentObject: updatedEnvObject)
            
        }
    }
    
    func moveBackground(_ delta: CGPoint, backgroundArray: Array<SKSpriteNode>) {
        for bg in backgroundArray {
            // We want to move the background almost all of what the world moved so it barely moves
            bg.position = self.dbAdd(bg.position, b: delta)
            
            // If the background is off of the screen, move it to the other side
            if bg.position.x + (bg.size.width - 2.0) <= -self.worldView.position.x && delta.x > 0 {
                
                // Player is moving right, bg is moving left
                bg.position = CGPoint(x: bg.position.x + self.totalBackgroundWidth, y: bg.position.y)
            }
            else {
                if bg.position.x >= (-self.worldView.position.x) + (self.frame.size.width - 2.0) && delta.x < 0 {
                    
                    // Player is moving left (backwards), bg is moving right
                    bg.position = CGPoint(x: bg.position.x - self.totalBackgroundWidth, y: bg.position.y)
                }
            }
        }
    }
    
    
    func moveWorld(_ delta: CGPoint) {
        self.worldView.position = dbSub(self.worldView.position, b: delta)
    }
    
    func updateHUD() {
        // HP
        var count = 0
        var nonGoldHearts = self.player.health - self.player.goldHearts
        
        // If the player hasn't lost any list
        if (self.player.maxHealth) <= self.player.health + self.startingReviveHearts {
            nonGoldHearts -= GameData.sharedGameData.heartBoostCount
        }
        
        for healthNode in self.healthNodes {
            // REJUV when we add the hearts after rejuv we also need to make them gold
            if self.player.health <= count {
                healthNode.pressButton()
            } else {
                if count < nonGoldHearts {
                    healthNode.releaseButton()
                } else {
                    healthNode.releaseButtonSpecialColor()
                }
            }
            
            count += 1
        }
        
        // Progress
        if self.player.isAlive {
            // Dont want the bar to go backwards
            var playerPositionX: CGFloat = 0.0
            
            if self.player.position.x > 0 {
                playerPositionX = CGFloat(Double(self.player.position.x))
            }
            activeProgressBar.size = CGSize(width: playerPositionX / self.totalLevelDistance * (self.frame.size.width / self.progressBarAdjuster), height: self.frame.size.height / 24.0)
            
            activeProgressBar.position = CGPoint(x: self.progressBar.position.x  - self.progressBar.size.width / 2 + self.activeProgressBar.size.width / 2, y: self.frame.size.height - 20.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        }
        
        // Text displays
        let newHeartLabel = "\(self.collectedLevelEnemyHealth)/\(self.totalLevelEnemyHealth)"
        if newHeartLabel != heartsLabel!.label.text {
            let buffer: CGFloat = 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            let yPosition: CGFloat = self.frame.size.height - 20.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            
            heartsLabel!.setText("\(self.collectedLevelEnemyHealth)/\(self.totalLevelEnemyHealth)")
            self.blackHeart!.position = CGPoint(x: self.heartsLabel!.position.x + self.blackHeart!.size.width/2 + buffer/2 + (self.heartsLabel!.calculateAccumulatedFrame().size.width / 2), y: yPosition)
        }
    }
    
    
    func endSceneLevelSelect() {
        // Tear the scene down
        self.tearDownScene()
        
        self.viewController!.presentLevelSelectionScene()
    }
    
    func endSceneMainMenu() {
        // Tear the scene down
        self.tearDownScene()
        
        self.viewController!.presentMainMenuScene()
    }
    
    func endSceneRetryLevel() {
        // Tear the scene down
        self.tearDownScene()
        
        self.viewController!.representGameSceneLevel(self.currentLevel, justRestarted: true)
    }
    
    func endSceneNextLevel() {
        // Tear the scene down
        self.tearDownScene()
        
        self.viewController!.representGameSceneLevel(self.currentLevel+1, justRestarted: false)
    }
    
    func tearDownScene() {
        // Save this bad boy
        //self.viewController!.saveData() OLD
        GameData.sharedGameData.save()

        // Stop audio
        self.backgroundPlayer?.stop()
        self.backgroundPlayer = nil
        
        // Remove all actions
        self.worldView.removeAllActions()
        self.worldView.removeAllChildren()
        self.removeAllActions()
        self.removeAllChildren()
        
        self.worldView.removeAllActions()
        self.rejuvDialog!.removeAllActions()
        self.endOfLevelDialog.removeAllActions()
        
        self.rejuvHeartDialogAction = SKAction()
        self.rejuvHeartDialogWaitAction = SKAction()
        self.rejuvHeartDialogDismissAction = SKAction()
        self.rejuvHeartDialogDismissStayPausedAction = SKAction()
        self.rejuvHeartDialogDisplayAction = SKAction()
        self.rejuvHeartDialogAction = SKAction()
        self.rejuvHeartDialogDismissAndEndLevelAction = SKAction()
        self.rejuvHeartDialogWaitThenDismissAndEndLevelAction = SKAction()
        
        
        //self.levelIntroText!.removeAllActions() OLD
        
        self.tearDownEnvObjects()
        self.tearDownPlayer()
    }
    
    func tearDownPlayer() {
        self.player.clearOutActions()
        self.player.removeAllActions()
        self.player.removeFromParent()
    }
    
    func tearDownEnvObjects() {
        // Iterate through all enemies and remove any double pointers
        for envObject in self.worldViewEnvironmentObjects {
            self.removeEnvironmentObject(environmentObject: envObject)
        }
        // Destroy ones not added yet too
        for envObject in self.environmentObjectsToAdd {
            self.clearEnvironmentObject(environmentObject: envObject)
        }
    }
    
    func clearEnvironmentObject(environmentObject: EnvironmentObject) {
        environmentObject.clearOutActions()
        environmentObject.removeAllActions()
        environmentObject.removeFromParent()
    }
    
    func removeEnvironmentObject(environmentObject: EnvironmentObject) {
        self.clearEnvironmentObject(environmentObject: environmentObject)
        
        // Remove from worldView array
        self.worldViewEnvironmentObjects.remove(at: self.worldViewEnvironmentObjects.index(of: environmentObject)!)
    }
    
    func addEnvironmentObject(environmentObject: EnvironmentObject) {
        self.worldView.addChild(environmentObject)
        self.worldViewEnvironmentObjects.append(environmentObject)
    }
    
    // Create the HUD
    func initializeHUD() {
        let buffer: CGFloat = 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        let yPosition: CGFloat = self.frame.size.height - 20.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        
        // Pause button
        if self.worldName == "spirit" {
            self.pauseButton = GamePauseButton(scene: self, light: true)
            self.pauseButton!.alpha = 0.85
        } else {
            self.pauseButton = GamePauseButton(scene: self, light: false)
            self.pauseButton!.alpha = 0.25
        }
        
        self.pauseButton!.size = CGSize(width: self.pauseButton!.size.width * 0.55, height: self.pauseButton!.size.height * 0.55)
        self.pauseButton!.position = CGPoint(x: self.frame.size.width - self.pauseButton!.size.width / 2.0 - buffer / 1.5, y: yPosition)
        self.addChild(self.pauseButton!)
        pauseButtonAdjustment = self.pauseButton!.size.width + buffer / 1.5
        
        // Env Object preloader - just put it to the right of pause
        self.environmentObjectPreloader.position = CGPoint(x: self.pauseButton!.position.x + self.pauseButton!.size.width / 2, y: self.pauseButton!.position.y)
        self.addChild(self.environmentObjectPreloader)
        
        // ****** HEALTH NODES ******
        //for var i = 1; i <= Int(self.player.maxHealth); i += 1 {
        for i in 1...Int(self.player.maxHealth) {
            let healthNode = PlayerHeartButton(scene: self)
            healthNode.position = CGPoint(x: healthNode.size.width * CGFloat(i) + (4.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) * CGFloat(i)) - (healthNode.size.width / 2.0) + 4 * ScaleBuddy.sharedInstance.getGameScaleAmount(false), y: yPosition)
            self.addChild(healthNode)
            
            self.healthNodes.append(healthNode)
        }
        
        // ******* PROGRESS BAR *******
        // Create background PROGRESS bar
        if self.worldName != "spirit" {
            progressBar = SKSpriteNode(color: UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 0.6), size: CGSize(width: self.frame.size.width / self.progressBarAdjuster, height: self.frame.size.height / 24.0))
        } else {
            progressBar = SKSpriteNode(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.85), size: CGSize(width: self.frame.size.width / self.progressBarAdjuster, height: self.frame.size.height / 24.0))
        }
        progressBar.position = CGPoint(x: self.frame.size.width - (self.frame.size.width / (self.progressBarAdjuster * 2) + buffer) - pauseButtonAdjustment, y: yPosition)
        self.addChild(progressBar)
        
        // Create player's PROGRESS bar
        activeProgressBar = SKSpriteNode(color: UIColor(red: 108 / 255.0, green: 190 / 255.0, blue: 69 / 255.0, alpha: 1.0), size: CGSize(width: CGFloat(self.player.health / (self.player.maxHealth)) * (self.frame.size.width / self.progressBarAdjuster), height: self.frame.size.height / 24.0))
        
        activeProgressBar.position = CGPoint(x: self.progressBar.position.x  - self.progressBar.size.width / 2 + self.activeProgressBar.size.width / 2, y: yPosition)
        self.addChild(activeProgressBar)
        
        /*
        // High score marker
        let highScoreMarker: SKSpriteNode = SKSpriteNode(color: UIColor(red: 255.0 / 255.0, green: 150.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), size: CGSizeMake(self.frame.size.width / 150.0, self.frame.size.height / 12.0))
        
        //temp = (1 - (GameData.sharedGameData.getSelectedCharacterData().levelsDistanceTraveled[self.currentLevel]! / self.totalLevelDistance))
        highScoreMarker.position = CGPointMake(self.frame.size.width - ((self.frame.size.width / 5.0) * temp + buffer) - pauseButtonAdjustment, yPosition)
        
        self.addChild(highScoreMarker)
        */
        
        // Level label - TODO replace this with a bar
        levelLabel = MultilineLabelWithShadow(fontNamed: "Avenir-Medium", scene: self, darkFont: false, borderSize: 1)
        levelLabel!.name = "hudLabel"
        levelLabel!.setText("\(self.worldNumber)-\(self.currentLevel)")
        levelLabel!.setFontSize(round(23 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        levelLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        levelLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)

        levelLabel!.position = CGPoint(x: self.progressBar.position.x - self.progressBar.size.width / 2 - buffer - (self.levelLabel!.calculateAccumulatedFrame().size.width / 2), y: yPosition - self.nodeBuffer * 0.4)
        self.addChild(levelLabel!)
        
        // Heart label - TODO replace this with a bar
        self.blackHeart = SKSpriteNode(texture: GameTextures.sharedInstance.uxGameAtlas.textureNamed("blackheartfilled"))
        self.blackHeart!.setScale(0.75)
        
        heartsLabel = MultilineLabelWithShadow(fontNamed: "Avenir-Medium", scene: self, darkFont: false, borderSize: 1)
        heartsLabel!.name = "hudLabel"
        heartsLabel!.setText("\(self.collectedLevelEnemyHealth)/\(self.totalLevelEnemyHealth)")
        heartsLabel!.setFontSize(round(23 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        heartsLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        heartsLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)

        heartsLabel!.position = CGPoint(x: self.levelLabel!.position.x - self.levelLabel!.calculateAccumulatedFrame().width - buffer * 2 - self.blackHeart!.size.width - buffer/2 - (self.heartsLabel!.calculateAccumulatedFrame().size.width / 2), y: yPosition - self.nodeBuffer * 0.4)
        self.addChild(heartsLabel!)
        
        self.blackHeart!.position = CGPoint(x: self.heartsLabel!.position.x + self.blackHeart!.size.width/2 + buffer/2 + (self.heartsLabel!.calculateAccumulatedFrame().size.width / 2), y: yPosition)
        self.addChild(self.blackHeart!)

        self.blackHeartAction = SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.15), SKAction.scale(to: 0.75, duration: 0.3)])
    }
    
    // Create all the buttons
    func initializeControls() {
        // skill 1 button
        self.skill1Button = GameSkillButton(scene: self, upgrade: self.player.skill1Details)
        self.skill1Button!.zPosition = 7
        self.addChild(self.skill1Button!)
        // For now skill1 will always be hidden and activated by screen press
        self.skill1Button?.isHidden = true
        
        // Setup button positions
        let leftMost = CGPoint(x: self.skill1Button!.size.width / 2.0 + self.buttonBuffer, y: self.buttonBuffer + self.skill1Button!.size.height / 2.0)
        let rightMost = CGPoint(x: self.frame.size.width - (self.skill1Button!.size.width / 2.0 + self.buttonBuffer), y: self.buttonBuffer + self.skill1Button!.size.height / 2.0)
        let secondLeftMost = CGPoint(x: self.skill1Button!.size.width * (3.0 / 2.0) + self.buttonBuffer * 2, y: self.buttonBuffer + self.skill1Button!.size.height / 2.0)
        let secondRightMostXPosition = self.frame.size.width - (self.skill1Button!.size.width * (3.0 / 2.0) + self.buttonBuffer * 2)
        let secondRightMostYPosition = self.buttonBuffer + self.skill1Button!.size.height / 2.0
        let secondRightMost = CGPoint(x: secondRightMostXPosition, y: secondRightMostYPosition)
        
        // skill 2 button
        self.skill2Button = GameSkillButton(scene: self, upgrade: self.player.skill2Details)
        self.skill2Button!.position = rightMost
        self.skill2Button!.zPosition = 7
        self.addChild(self.skill2Button!)
        
        // Hide the button if it isn't unlocked
        if !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(self.player.skill2Details.upgrade) {
            self.skill2Button?.isHidden = true
        }
        
        // Skill 3 button
        self.skill3Button = GameSkillButton(scene: self, upgrade: self.player.skill3Details)
        self.skill3Button!.position = secondRightMost
        self.skill3Button!.zPosition = 7
        self.addChild(self.skill3Button!)
        
        // Hide the button if it isn't unlocked
        if !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(self.player.skill3Details.upgrade) {
            self.skill3Button?.isHidden = true
        }
        
        // Skill 4 button
        self.skill4Button = GameSkillButton(scene: self, upgrade: self.player.skill4Details)
        self.skill4Button!.position = leftMost
        self.skill4Button!.zPosition = 7
        self.addChild(self.skill4Button!)
        
        // Hide the button if it isn't unlocked
        if !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(self.player.skill4Details.upgrade) {
            self.skill4Button?.isHidden = true
        }
        
        // Skill 5 button
        self.skill5Button = GameSkillButton(scene: self, upgrade: self.player.skill5Details)
        self.skill5Button!.position = secondLeftMost
        self.skill5Button!.zPosition = 7
        self.addChild(self.skill5Button!)
        
        // Hide the button if it isn't unlocked
        if !GameData.sharedGameData.getSelectedCharacterData().isUpgradeUnlocked(self.player.skill5Details.upgrade) {
            self.skill5Button?.isHidden = true
        }
        
        // Skill 6 button - never show
        self.skill6Button = GameSkillButton(scene: self, upgrade: self.player.skill6Details)
        self.addChild(self.skill6Button!)
        self.skill6Button?.isHidden = true
    }
    
    func initializePauseMenu() {
        // TODO replace with an image
        self.pauseMenu = PauseMenu(frameSize: CGSize(width: self.frame.size.width, height: self.frame.size.height), scene: self)
        
        // Put in center of screen
        self.pauseMenu.position = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        self.pauseMenu.zPosition = 14.0
        
        // Don't want to show the pause menu by default
        self.pauseMenu.isHidden = true
        
        self.addChild(self.pauseMenu)
    }
    
    func initializeMapObjects() {
        // Initialize the map object array
        mapObjectArray = [MapObject]()
        
        // Create the path to the level
        let filePath: String = "level_\(self.currentLevel)"
        let path: String = Bundle.main.path(forResource: filePath, ofType: "plist")!
        
        // Read in the level
        let levelSetup: NSDictionary = NSDictionary(contentsOfFile: path)!
        
        // Loop through each entry in the dictionary
        for element in levelSetup {
            if (element.key as! String).hasPrefix("EnvironmentObject") {
                
                // Create the dictionary referenced by the key
                let level: NSDictionary = element.value as! NSDictionary
                
                // Create and add the map object unit to the array
                let object: String = level["Object"] as! String
                var location: CGFloat = level["Location"] as! CGFloat + 60
                
                // Scale location
                location *= ScaleBuddy.sharedInstance.getGameScaleAmount(false)
                
                var value1: Double = 0
                var value2: Double = 0
                
                if let readValue1: NSNumber = level["Value1"] as? NSNumber {
                    value1 = readValue1.doubleValue
                }
                
                if let readValue2: NSNumber = level["Value2"] as? NSNumber {
                    value2 = readValue2.doubleValue
                }
                
                // If we find the level end obstacle, set the total level distance, otherwise add as a map object
                if object == "LevelEnd" {
                    self.totalLevelDistance = location
                }
                else {
                    mapObjectArray.append(MapObject(mapName: object, andPosition: location, andValue1: value1, andValue2: value2))
                }
                
                // If this is an enemy, add to the calculation of total enemy health
                // TODO try to first cast it as an enemy. If it fails, it is not one.
                if let enemyClass = NSClassFromString(object) as? Enemy.Type {
                    self.totalLevelEnemyHealth += enemyClass.getHealth(enemyClass)
                }
            }
        }
    }
    
    func initializeScrollingBackground(_ size: CGSize) {
        var backgroundYPosition: CGFloat = 0
        let foregroundYPosition: CGFloat = self.adjustedGroundPositionY
        
        // This is our scrolling background code.
        if self.worldName == "earth" {
            self.backgroundColor = MerpColors.earthBackground
            backgroundYPosition = self.adjustedGroundPositionY
        } else if self.worldName == "water" {
            self.backgroundColor = MerpColors.waterBackground
            backgroundYPosition = self.adjustedGroundPositionY
        } else if self.worldName == "fire" {
            self.backgroundColor = MerpColors.fireBackground
        } else if self.worldName == "air" {
            self.backgroundColor = MerpColors.airBackground
        } else if self.worldName == "spirit" {
            self.backgroundColor = MerpColors.spiritBackground
        }
        
        // Background
        for j in 0 ..< 2 {
            for i in 0 ..< self.numberBackgroundNodes {
                let bg = getLevelBackground(j, number: i+1)
                
                if self.worldName == "earth" || self.worldName == "water" {
                    backgroundYPosition = self.adjustedGroundPositionY
                } else if self.worldName == "fire" || self.worldName == "air" || self.worldName == "spirit" {
                    backgroundYPosition = size.height - bg.size.height
                }
                
                bg.anchorPoint = CGPoint.zero
                
                switch j {
                case 0:
                    bg.name = "background"
                    bg.position = CGPoint(x: self.totalBackgroundWidth, y: backgroundYPosition)
                    self.totalBackgroundWidth += bg.size.width - 2.0
                    self.worldViewBackgrounds.append(bg)
                case 1:
                    bg.name = "foreground"
                    bg.position = CGPoint(x: self.totalForegroundWidth, y: foregroundYPosition)
                    self.totalForegroundWidth += bg.size.width - 2.0
                    self.worldViewForegrounds.append(bg)
                default: break
                }
                
                self.worldView.addChild(bg)
            }
        }
    }
    
    func getLevelBackground(_ layer: Int, number: Int) -> SKSpriteNode {
        if layer == 0 {
            return SKSpriteNode(texture: SKTexture(imageNamed: ("\(self.worldName)background\(number)")))
        } else if layer == 1 {
            return SKSpriteNode(texture: SKTexture(imageNamed: ("\(self.worldName)foreground\(number)")))
        } else {
            return SKSpriteNode()
        }
    }
    
    func initializeGroundTiles(_ size: CGSize) {
        // Create the ground
        self.ground = SKSpriteNode(color: getGroundColor(), size: CGSize(width: self.frame.size.width * 5/* + self.totalLevelDistance*/, height: (self.buttonSize + self.buttonBuffer * 2.0) * 2.0))
        
        // Set the ground position
        groundPositionY = 0 // self.frame.size.height/3.25 - self.ground.size.height/2;
        //adjustedGroundPositionY = groundPositionY + (self.buttonSize + self.buttonBuffer * 2.0)
        self.ground.position = CGPoint(x: self.ground.size.width / 2, y: 0)
        self.adjustedGroundPositionY = self.ground.position.y + self.ground.size.height / 2
        
        // Set the ground physics
        self.ground.physicsBody = SKPhysicsBody(rectangleOf: self.ground.size)
        self.ground.physicsBody!.isDynamic = false // The ground will not change
        self.ground.physicsBody!.mass = 0.001 // Set a large mass
        self.ground.physicsBody!.usesPreciseCollisionDetection = OptimizerBuddy.sharedInstance.usePreciseCollisionDetection()
        self.ground.physicsBody!.affectedByGravity = false // The ground doesn't move
        self.ground.physicsBody!.friction = 0.1
        self.ground.physicsBody!.restitution = 0.0
        
        // Bit masks
        self.ground.physicsBody!.categoryBitMask = GameScene.groundCategory
        
        // Have these commented out. Don't think we need this as long as everything else refers to it.
        //self.ground.physicsBody.contactTestBitMask =  playerCategory | [GameScene getBitMaskDeathCategory];
        //self.ground.physicsBody.collisionBitMask = playerCategory | [GameScene getBitMaskDeathCategory];
        
        // We want the ground in front of everything else
        self.ground.zPosition = 5
        
        // Add the ground to the scene
        self.worldView.addChild(self.ground)
    }
    
    func getGroundColor() -> UIColor {
        if self.worldName == "earth" {
            return MerpColors.earthGround
        } else if self.worldName == "water" {
            return MerpColors.waterGround
        } else if self.worldName == "fire" {
            return MerpColors.fireGround
        } else if self.worldName == "air" {
            return MerpColors.airGround
        }else if self.worldName == "spirit" {
            return MerpColors.spiritGround
        }
        
        return SKColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
    }
    
    func initializePlayer(_ size: CGSize) {
        // Set the position of the player right above the ground // TODO move into player class
        self.player.defaultPositionY = adjustedGroundPositionY + self.player.size.height / 2
        
        self.player.position = CGPoint(x: self.player.size.width / 2, y: self.player.defaultPositionY)
        self.player.setPlayerAttachmentPositions(adjustedGroundPositionY + self.player.size.height / 2, position: CGPoint(x: self.player.size.width / 2, y: self.player.defaultPositionY))
        
        self.player.zPosition = GameScene.PLAYER_Z
        
        // Add the player to the scene
        self.worldView.addChild(self.player)
    }
    
    func initializeTutorial(_ levelSetup: NSDictionary) {
        // TODO read in the tutorial
        var count: Int = 0
        
        let tutorialArray = levelSetup.value(forKey: "Tutorial") as? Array<[String: AnyObject]>
        
        // Need to know the prev dialog
        var previousDialog: TutorialDialog?
        
        if tutorialArray != nil {
            for tutorialTipDictionary in tutorialArray! {
                // Get the version information
                var key = tutorialTipDictionary["Key"] as! String
                key = "level_\(self.currentLevel)_" + key// + CharacterType.getCharacterName(GameData.sharedGameData.selectedCharacter) // Make it level specific and character specific
                
                let version = tutorialTipDictionary["Version"] as! Double
                
                // If the player has already seen this version, don't bother showing it!
                let storedTutorial: Double? = GameData.sharedGameData.tutorialsAcknowledged[key]
                
                if storedTutorial == nil || floor(storedTutorial!) != floor(version) || GameData.sharedGameData.getSelectedCharacterData().godMode {
                    // Type information
                    let tipType = TipType(rawValue: tutorialTipDictionary["Type"] as! String)!
                    
                    var className: String
                    var iconTexture: SKTexture
                    var isCharacter = false
                    
                    if tipType == TipType.EnvironmentObject {
                        isCharacter = true
                        className = tutorialTipDictionary["Class"] as! String
                        
                        // First try to get the tutorial art if it exists
                        let lowerClassName = className.lowercased()
                        
                        let filePath: String = "tutorial_\(lowerClassName)"
                        iconTexture = SKTexture(imageNamed: filePath)
                    } else {
                        iconTexture = GameTextures.sharedInstance.splashAndStoryAtlas.textureNamed("tutorialicon")
                    }
                    
                    // Create dialog
                    let title = TextFormatter.formatText(tutorialTipDictionary["Title"] as! String)
                    let description = TextFormatter.formatText(tutorialTipDictionary["Description"] as! String)
                    
                    let tutorialDialog = TutorialDialog(title: title, description: description, frameSize: self.size, dialogs: self.tutorialDialogs!, dialogNumber: count, scene: self, iconTexture: iconTexture, isCharacter: isCharacter, key: key, version: version, prependText: true)
                    
                    tutorialDialog.zPosition = 19
                    
                    if count == 0 {
                        // This one is a "play" button
                        tutorialDialog.updateAsPlayOnly()
                    } else if count == 1 {
                        // This one is a "play" button and "previous" and the previous one needs to change to a "next" only button
                        tutorialDialog.updateAsPlayAndPrevious()
                        previousDialog!.updateAsNextOnly()
                    } else if count >= 2 {
                        // This one is a "play" button and "previous" and the previous one needs to change to a "next" and "previous" button
                        tutorialDialog.updateAsPlayAndPrevious()
                        previousDialog!.updateAsPreviousAndNext()
                    }
                    
                    self.tutorialDialogs!.append(tutorialDialog)
                    //self.addChild(tutorialDialog)
                    previousDialog = tutorialDialog
                    count += 1
                }
            }
        }
        
        // Occasionally we advertise in house purchases. Skip the first time, so start at frequency * 2
        var frequencyAds: Int = 10

        if !GameData.sharedGameData.adsUnlocked && GameData.sharedGameData.timesPlayed > frequencyAds && GameData.sharedGameData.timesPlayed % frequencyAds == 0 {
            // Get the version information
            let key = "timesPlayedAdvertisement\(GameData.sharedGameData.timesPlayed)"
            let version = 1.0
            let iconTexture: SKTexture
            var description = "Any purchase gives longer hero boosts!"
            // Create dialog
            var title = "Buy Gems!"
            
            if GameData.sharedGameData.timesPlayed % (frequencyAds * 2) == 0 {
                iconTexture = SKTexture(imageNamed: "tutorial_monk")
            } else {
                iconTexture = SKTexture(imageNamed: "tutorial_mage")
                title = "Be a Pal!"
                description = "Support indie games by purchasing gems!"
            }
            
            
            
            let tutorialDialog = TutorialDialog(title: title, description: description, frameSize: self.size, dialogs: self.tutorialDialogs!, dialogNumber: count, scene: self, iconTexture: iconTexture, isCharacter: true, key: key, version: version, prependText: false)
            
            tutorialDialog.zPosition = 19
            
            if count == 1 {
                // the previous one needs to change to a "next" only button
                previousDialog!.updateAsNextOnly()
            } else if count >= 2 {
                // the previous one needs to change to a "next" and "previous" button
                previousDialog!.updateAsPreviousAndNext()
            }
            
            tutorialDialog.updateAsPlayAndStore()
            
            self.tutorialDialogs!.append(tutorialDialog)
            //self.addChild(tutorialDialog)
            previousDialog = tutorialDialog
            count += 1
        }
    }
    
    func initializeStory(_ levelSetup: NSDictionary) {
        // TODO read in the tutorial
        var count: Int = 0
        var endCount: Int = 0
        
        let storyArray = levelSetup.value(forKey: "Story") as? Array<[String: AnyObject]>
        
        if storyArray != nil {
            for storyDictionary in storyArray! {
                // Get the version information
                let key = "story_\(self.currentLevel)_\(count)_\(self.player.name!)"
                
                let version = storyDictionary["Version"] as! Double
                
                // If the player has already seen this version, don't bother showing it!
                let storedTutorial: Double? = GameData.sharedGameData.tutorialsAcknowledged[key]
                
                if storedTutorial == nil || floor(storedTutorial!) != floor(version) || GameData.sharedGameData.getSelectedCharacterData().godMode {
                    // Get the class. If not null and equal to a character, only keep this story if it matches the selected character
                    let character = storyDictionary["Character"] as? String
                    
                    if character == nil || character == GameData.sharedGameData.selectedCharacter.rawValue.lowercased() {
                        // Image Info
                        var iconName: String = (storyDictionary["Icon"] as! String).lowercased()
                        
                        // Create dialog
                        var description = TextFormatter.formatText(storyDictionary["Description"] as! String)
                        
                        let nameReplace = "c_name"
                        let roleReplace = "c_role"
                        let relationshipReplace = "c_relationship"
                        
                        // Do some mods to the description
                        if GameData.sharedGameData.selectedCharacter == CharacterType.Archer {
                            description = description.replacingOccurrences(of: nameReplace, with: "May")
                            description = description.replacingOccurrences(of: roleReplace, with: "fearless Archer")
                            description = description.replacingOccurrences(of: relationshipReplace, with: "sister")
                            iconName = iconName.replacingOccurrences(of: roleReplace, with: "archer")
                        } else if GameData.sharedGameData.selectedCharacter == CharacterType.Warrior {
                            description = description.replacingOccurrences(of: nameReplace, with: "Jim")
                            description = description.replacingOccurrences(of: roleReplace, with: "fearless Warrior")
                            description = description.replacingOccurrences(of: relationshipReplace, with: "brother")
                            iconName = iconName.replacingOccurrences(of: roleReplace, with: "warrior")
                        } else if GameData.sharedGameData.selectedCharacter == CharacterType.Mage {
                            description = description.replacingOccurrences(of: nameReplace, with: "Gary")
                            description = description.replacingOccurrences(of: roleReplace, with: "fearless Mage")
                            description = description.replacingOccurrences(of: relationshipReplace, with: "brother")
                            iconName = iconName.replacingOccurrences(of: roleReplace, with: "mage")
                        } else if GameData.sharedGameData.selectedCharacter == CharacterType.Monk {
                            description = description.replacingOccurrences(of: nameReplace, with: "Leonard")
                            description = description.replacingOccurrences(of: roleReplace, with: "fearless Monk")
                            description = description.replacingOccurrences(of: relationshipReplace, with: "brother")
                            iconName = iconName.replacingOccurrences(of: roleReplace, with: "monk")
                        }
                        
                        var iconTexture: SKTexture
                        iconTexture = SKTexture(imageNamed: iconName)
                        
                        // Type - either beginning of level or end
                        let type = storyDictionary["Type"] as! String
                        
                        var storyDialog: StoryDialog
                        
                        if type == "Beginning" {
                            storyDialog = StoryDialog(description: description, frameSize: self.size, dialogNumber: count, scene: self, iconTexture: iconTexture, key: key, version: version, beginning: true)
                            self.storyDialogs!.append(storyDialog)
                            count += 1
                        } else {
                            storyDialog = StoryDialog(description: description, frameSize: self.size, dialogNumber: endCount, scene: self, iconTexture: iconTexture, key: key, version: version, beginning: false)
                            self.storyEndDialogs!.append(storyDialog)
                            endCount += 1
                        }
                        
                        storyDialog.zPosition = 20
                        self.addChild(storyDialog)
                    }
                }
            }
        }
    }
    
    func initializeChallenges(_ levelSetup: NSDictionary) {
        // Read in challenges from plist
        let challengeArray = levelSetup.value(forKey: "Challenges") as? Array<[String: AnyObject]>
        
        if challengeArray != nil { 
            for challengeDictionary in challengeArray! {
                
                // Type information
                let challengeType = ChallengeType(rawValue: challengeDictionary["Type"] as! String)!
                
                // Reward information
                let challengeReward = challengeDictionary["Reward"] as! Int
                
                // If the selected character hasnt completed the challenge for this level, add it to availableChgs
                let levelData: LevelData? = GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.currentLevel]
                
                // Get the challenge info
                if levelData != nil {
                    if !levelData!.challengeCompletion.contains(challengeType.rawValue) {
                        // This is a challenge the user has not done. Add it to the list of available ones.
                        self.levelChallenges.append(LevelChallenge(challengeType: challengeType, completed: false, reward: challengeReward))
                    } else {
                        // This is a challenge the user has done.
                        self.levelChallenges.append(LevelChallenge(challengeType: challengeType, completed: true, reward: challengeReward))
                    }
                }
            }
        }
        
        if self.levelChallenges.count > 0 {
            // Create the display
            self.challengeDialog = ChallengeDialog(frameSize: self.size, scene: self, challenges: self.levelChallenges)
            
            self.challengeDialog!.isHidden = true
            
            self.challengeDialog!.zPosition = 15
            self.addChild(self.challengeDialog!)
        }
    }
    
    func initializeEndOfLevelDialog() {
        // Completed challenges is an array so changes we make will successfully pass over
        self.endOfLevelDialog = EndOfLevelDialog(frameSize: self.size, scene: self, currentLevel: self.currentLevel, completedChallenges: self.levelChallenges)
        
        self.endOfLevelDialog.zPosition = 15
        
        self.addChild(self.endOfLevelDialog)
    }
    
    override func pauseGame() {
        if !self.levelEnded || self.promptingForRejuv {
            if (self.showPauseMenu) {
                self.pauseMenu.isHidden = false
            }
            self.physicsWorld.speed = 0.0
            
            self.worldView.isPaused = true
            self.worldView.stayPaused = true
            
            self.skill1Button?.isPaused = true
            self.skill2Button?.isPaused = true
            self.skill3Button?.isPaused = true
            self.skill4Button?.isPaused = true
            self.skill5Button?.isPaused = true
            self.skill6Button?.isPaused = true
        }
        
        self.backgroundPlayer?.volume = 0.0
    }
    
    func setStayPaused() {
        self.worldView.stayPaused = true
    }
    
    override func unpauseGame() {
        self.showPauseMenu = true
        
        // Hide menu, unpause
        self.worldView.stayPaused = false
        self.worldView.isPaused = false
        
        self.physicsWorld.speed = ScaleBuddy.sharedInstance.getGameScaleAmount(false) * 0.9999 //2.0
        self.pauseMenu.isHidden = true
        self.skill1Button?.isPaused = false
        self.skill2Button?.isPaused = false
        self.skill3Button?.isPaused = false
        self.skill4Button?.isPaused = false
        self.skill5Button?.isPaused = false
        self.skill6Button?.isPaused = false
        
        self.backgroundPlayer?.volume = 1.0
    }
    
    func getButtonWithSkill(_ skillAsUpgrade: CharacterUpgrade) -> GameSkillButton? {
        if self.skill1Button!.upgradeDetails?.upgrade == skillAsUpgrade {
            return self.skill1Button!
        } else if self.skill2Button!.upgradeDetails?.upgrade == skillAsUpgrade {
            return self.skill2Button!
        } else if self.skill3Button!.upgradeDetails?.upgrade == skillAsUpgrade {
            return self.skill3Button!
        } else if self.skill4Button!.upgradeDetails?.upgrade == skillAsUpgrade {
            return self.skill4Button!
        } else if self.skill5Button!.upgradeDetails?.upgrade == skillAsUpgrade {
            return self.skill5Button!
        } else if self.skill6Button!.upgradeDetails?.upgrade == skillAsUpgrade {
            return self.skill6Button!
        } else {
            return nil
        }
    }
    
    func calculateScores(_ score: LevelScore) {
        // We only want to calculate challenges if they are unlocked
        if GameData.sharedGameData.getSelectedCharacterData().challengesUnlocked(self.currentLevel) {
            self.checkChallenges(score)
        }
        
        // Always check leaderboards
        self.checkLeaderboards()
    }
    
    func checkChallenges(_ score: LevelScore) {
        // Determine if the player achieved a challenge they were trying to get
        for challenge: LevelChallenge in self.levelChallenges {
            if challenge.completed == false {
                // Case statement of challenge types to test if the challenge was met
                switch challenge.challengeType {
                case .FullHealth:
                    if (self.player.health >= self.player.maxHealth) {
                        self.completeChallenge(challenge)
                    }
                case .OneHeartLeft:
                    if (self.player.health == 1) {
                        self.completeChallenge(challenge)
                    }
                case .NoHeartsCollected:
                    if (self.player.health > 0 && self.collectedLevelEnemyHealth == 0) {
                        self.completeChallenge(challenge)
                    }
                case .OneHundredPercent:
                    if (self.player.health > 0 && self.collectedLevelEnemyHealth == self.totalLevelEnemyHealth) {
                        self.completeChallenge(challenge)
                    }
                case .OhSoClose:
                    if (self.player.health == 0 && self.collectedLevelEnemyHealth == self.totalLevelEnemyHealth) {
                        self.completeChallenge(challenge)
                    }
                case .DieByEnemies:
                    if self.player.health == 0 && self.player.challengeHurtByEnemy && !self.player.challengeHurtByObstacle && !self.player.challengeHurtByProjectile {
                        self.completeChallenge(challenge)
                    }
                case .DieByObstacles:
                    if self.player.health == 0 && !self.player.challengeHurtByEnemy && self.player.challengeHurtByObstacle && !self.player.challengeHurtByProjectile {
                        self.completeChallenge(challenge)
                    }
                case .DieByProjectiles:
                    if self.player.health == 0 && self.player.challengeKilledByProjectile {
                        self.completeChallenge(challenge)
                    }
                case .DontTouchEnemies:
                    if self.player.health > 0 && !self.player.challengeTouchedAnEnemy {
                        self.completeChallenge(challenge)
                    }
                case .DontTouchObstacles:
                    if self.player.health > 0 && !self.player.challengeTouchedAnObstacle {
                        self.completeChallenge(challenge)
                    }
                case .DontTouchProjectiles:
                    if self.player.health > 0 && !self.player.challengeTouchedAProjectile {
                        self.completeChallenge(challenge)
                    }
                case .ReachEndOfLevel:
                    if self.player.health > 0 {
                        self.completeChallenge(challenge)
                    }
                case .Score3Stars:
                    if score.starsRewarded >= 3 {
                        self.completeChallenge(challenge)
                    }
                case .Score80Percent:
                    if score.totalCompletePercent >= 0.80 {
                        self.completeChallenge(challenge)
                    }
                case .Collect75PercentHearts:
                    if score.heartsCollectedPercent >= 0.75 {
                        self.completeChallenge(challenge)
                    }
                case .DestroyAllObstacles:
                    if self.player.health > 0 && self.totalLevelDestroyableObstacles == self.collectedLevelDestroyableObstacles && self.totalLevelDestroyableObstacles > 0 {
                        self.completeChallenge(challenge)
                    }
                case .DontTouchAnything:
                    if self.player.health > 0 && !self.player.challengeTouchedAnEnemy && !self.player.challengeTouchedAnObstacle && !self.player.challengeTouchedAProjectile {
                        self.completeChallenge(challenge)
                    }
                }
            }
        }
    }
    
    func checkLeaderboards() {
        // This takes the best scores everywhere and applies it to the GameData then syncs it. Call LAST
        GameKitHelper.sharedInstance.updateScores()
        self.viewController!.resyncScore()
    }
    
    func completeChallenge(_ challenge: LevelChallenge) {
        GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.currentLevel]!.challengeCompletion.add(challenge.challengeType.rawValue)
        
        // Add gems to scene and to character data
        self.gemsWon += challenge.reward
        GameData.sharedGameData.totalDiamonds += challenge.reward
        
        // Add it to our completed challenges so we can show the user what they accomplished - DAWG
        self.completedChallenges.append(challenge)
    }
    
    func initializeSound() {
        // Init sound helper
        SoundHelper.sharedInstance.turnOn()
        
        // For now we are just going to have the sound icons in the game view controller... we will add here later
        if GameData.sharedGameData.preferenceMusic {
            guard let path = Bundle.main.url(forResource: self.worldName, withExtension: "m4a") else {
                //NSLog("The path could not be created.")
                return
            }
            
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: path)
                backgroundPlayer!.numberOfLoops = -1
                backgroundPlayer!.prepareToPlay()
            } catch {
                print(error)
                // No music :(
            }
        }
    }
    
    override func hasOwnMusic() -> Bool {
        return true
    }
    
    func playMusic() {
        if backgroundPlayer != nil && GameData.sharedGameData.preferenceMusic && !backgroundPlayer!.isPlaying {
            backgroundPlayer!.play()
        }
    }
    /*
    func initializeLevelIntroText() {
        self.levelIntroText = LabelWithShadow(fontNamed: "Avenir-Bold", darkFont:false, borderSize: 3)
        
        self.levelIntroText!.setFontSize(round(72 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.levelIntroText!.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.levelIntroText!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.levelIntroText!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.levelIntroText!.setScale(0.3)
        self.levelIntroText!.alpha = 0.0
        self.levelIntroText!.setText("level \(self.currentLevel) start!")
        self.levelIntroText!.isHidden = true
        self.levelIntroText!.zPosition = 10
        self.worldView.addChild(self.levelIntroText!)
        self.levelIntroTextAction = SKAction.sequence([SKAction.group([SKAction.fadeIn(withDuration: 0.25), SKAction.scale(by: 2.5, duration: 0.25)]), SKAction.wait(forDuration: 0.75), SKAction.fadeOut(withDuration: 0.25), SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.levelIntroText!.removeFromParent()
            }
        })])
    }*/
}
