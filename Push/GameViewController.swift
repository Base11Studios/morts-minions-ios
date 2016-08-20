//
//  GameViewController.swift
//  Merp
//
//  Created by Dan Bellinski on 10/27/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation
import GameKit
import AVFoundation
import LocalAuthentication

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var levelSelectionScene: LevelSelectionScene?
    var gameScene: GameScene?
    var introScene: IntroductionScene?
    var loadingScene: LoadingScene?
    var mainMenuScene: MainMenuScene?
    
    var characterSkillSceneCharacter: CharacterType?
    var characterSkillScene: CharacterSkillScene?
    
    var sceneBeforeSkills: DBSceneType?
    
    // Menu music?
    var backgroundPlayer: AVAudioPlayer?
    var buttonSoundPlayer: AVAudioPlayer?
    
    var isReloading: Bool = false
    
    var gvcInitialized: Bool = false
    
    // Cloud data flag - is there newer cloud data but we couldn't ask user yet
    var userNeedsToDecideOnCloudData: Bool = false
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    func gameCenterViewControllerDidFinish(_ gcViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // Setup observer for cloud data change
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(GameViewController.ubiquitousKeyValueStoreDidChangeExternally),
                                                 name:  NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                                 object: NSUbiquitousKeyValueStore.default())
        
        // Setup CUSTOM observer for cloud has more recent data than local
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(GameViewController.handleCloudHasMoreRecentDataThanLocal),
                                                 name: CloudHasMoreRecentDataThanLocal,
                                                 object: nil)
        
        // Setup CUSTOM observer for gamekit auth
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(GameViewController.showAuthenticationViewController),
                                                 name: PresentAuthenticationViewController,
                                                 object: nil)
        
        // Setup CUSTOM observer for player is authenticated
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(GameViewController.playerAuthenticated),
                                                 name: LocalPlayerIsAuthenticated,
                                                 object: nil)
        
        // Setup the scale helpers
        ScaleBuddy.sharedInstance.screenSize = self.getScreenSize()
        if ScaleBuddy.sharedInstance.screenSize.width == 667 {
            ScaleBuddy.sharedInstance.playerHorizontalLeft = 8
            ScaleBuddy.sharedInstance.playerHorizontalRight = 3.5
        } else if ScaleBuddy.sharedInstance.screenSize.width == 562.5 || ScaleBuddy.sharedInstance.screenSize.width == 1024 {
            ScaleBuddy.sharedInstance.playerHorizontalLeft = 10
            ScaleBuddy.sharedInstance.playerHorizontalRight = 6
        }
        
        if UIDevice.current().userInterfaceIdiom == .phone && ScaleBuddy.sharedInstance.screenSize.width == 562.5 {
            ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.original4
        } else if UIDevice.current().userInterfaceIdiom == .phone && ScaleBuddy.sharedInstance.screenSize.width == 667 {
            ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.wide6
        } else if UIDevice.current().userInterfaceIdiom == .pad {
            ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.originaliPad
        }
        
        // Present first scene
        self.presentIntroductionScene()
        
        // Try to auth user
        GameKitHelper.sharedInstance.authenticateLocalPlayer(false)
        
        // Set restoration identifier
        self.restorationIdentifier = "GameViewController"
        
        // Setup Music
        self.setupMusic()
        
        // Setup sound
        self.setupButtonSound()
        
        // Setup sound props
        self.setSessionPlayerPassive()
        
        // Done loading
        isReloading = false
    }
    
    func setupMusic() {
        guard let path = Bundle.main().urlForResource("menu", withExtension: "caf") else {
            return
        }
        
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: path)
            backgroundPlayer!.numberOfLoops = -1
            self.playMusic(GameData.sharedGameData.preferenceMusic)
        } catch {
            // No music :(
        }
    }
    
    func setSessionPlayerPassive() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryAmbient)
            try session.setActive(true)
        } catch {
            return
        }
    }
    
    func setupButtonSound() {
        guard let path = Bundle.main().urlForResource("click-1", withExtension: "caf") else {
            return
        }
        
        do {
            buttonSoundPlayer = try AVAudioPlayer(contentsOf: path)
            buttonSoundPlayer!.numberOfLoops = 0
        } catch {
            // No music :(
        }
    }
    
    func ubiquitousKeyValueStoreDidChangeExternally() {
        if !self.gvcInitialized || GameData.sharedGameData.cloudSyncing {
            // Get the game data from the cloud
            let cloudData = GameData.getCloudData()
            var unarchivedCloudData: GameData? = nil
            
            if cloudData != nil {
                unarchivedCloudData = NSKeyedUnarchiver.unarchiveObject(with: cloudData! as Data) as? GameData
                GameData.sharedGameData.unarchivedCloudData = unarchivedCloudData
            }
            
            // NEW LOGIC
            // If cloud > local, notify user of choice.
            let localTime = GameData.sharedGameData.timeLastUpdated
            let cloudTime = unarchivedCloudData!.timeLastUpdated
            
            if cloudTime.compare(localTime) == ComparisonResult.orderedDescending {
                // If the scene is not nil and the scene is a DBscene, make it ask user about cloud data
                let skView: SKView = self.view as! SKView
                
                // Not nil
                if skView.scene != nil {
                    // This is a DBSCene
                    if let dbScene = skView.scene as? DBScene {
                        dbScene.presentUserWithOptionToLoadCloudData()
                    } else {
                        // Else, store this so we can do it later once we present a DBScene that can prompt the user
                        self.userNeedsToDecideOnCloudData = true
                    }
                } else {
                    // Else, store this so we can do it later once we present a DBScene that can prompt the user
                    self.userNeedsToDecideOnCloudData = true
                }
            }
            
            // OLD LOGIC
            // Run a check. If this ends up finding that the cloud data is more recent then it will prompt the user. If not, dont need to prompt them, right?
            //GameData.getDesiredGameData(currentData, cloud: unarchivedCloudData!)
        }
    }
    
    // This starts the game over with the passed in data
    func reloadData(_ data: GameData) {
        // We want to reload the game data
        GameData.sharedGameData = data
        
        // Save the data locally so we have it now TODO may not need
        
        // Put up loading screen
        self.presentLoadingScreen(ignoreMusic: true)
        
        // Now clear all of the scenes impacted by game data
        self.characterSkillScene = nil
        self.characterSkillSceneCharacter = nil
        self.levelSelectionScene = nil
        self.mainMenuScene = nil
        
        // Now load the menu screen
        /*
         SKTextureAtlas.preloadTextureAtlases(GameTextures.sharedInstance.menuSceneAtlas) { () -> Void in
         self.presentIntroductionScene()
         }*/
        
        // Move to a background thread to do some long running work
        DispatchQueue.global(attributes: .qosUserInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.presentIntroductionScene()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.presentIntroductionScene()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func createIntroductionScene() -> IntroductionScene {
        let scene: IntroductionScene = IntroductionScene(size: getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.viewController = self
        return scene
    }
    
    func presentIntroductionScene() {
        if self.introScene == nil {
            self.introScene = self.createIntroductionScene()
        }
        /*
         if self.characterSkillScene == nil {
         self.characterSkillScene = self.createCharacterSkillScene()
         }*/
        /*
         if self.levelSelectionScene == nil {
         self.levelSelectionScene = self.createLevelSelectionScene()
         }*/
        if self.mainMenuScene == nil {
            self.mainMenuScene = self.createMainMenuScene()
        }
        
        self.gvcInitialized = true
        
        let skView: SKView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: self.introScene!, ignoreMusic: false)
    }
    
    func createCharacterSkillScene() -> CharacterSkillScene {
        let scene = CharacterSkillScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.viewController = self
        
        // Also set the selected char
        self.characterSkillSceneCharacter = GameData.sharedGameData.selectedCharacter
        
        return scene
    }
    
    func presentCharacterSkillScene(_ sceneType: DBSceneType) {
        self.presentLoadingScreen(ignoreMusic: true)
        
        if self.characterSkillSceneCharacter == nil || self.characterSkillScene == nil || self.characterSkillSceneCharacter! != GameData.sharedGameData.selectedCharacter {
            self.characterSkillScene = nil
            
            /*
             SKTextureAtlas.preloadTextureAtlases(GameTextures.sharedInstance.menuSceneAtlas) { () -> Void in
             self.characterSkillScene = self.createCharacterSkillScene()
             
             self.reallyPresentCharacterSkillScene(sceneType)
             }*/
            // Move to a background thread to do some long running work
            DispatchQueue.global(attributes: .qosUserInitiated).async {
                // Bounce back to the main thread to update the UI
                self.characterSkillScene = self.createCharacterSkillScene()
                DispatchQueue.main.async {
                    self.reallyPresentCharacterSkillScene(sceneType)
                }
            }
        } else {
            // Character is same, don't need to reload scene
            self.reallyPresentCharacterSkillScene(sceneType)
        }
    }
    
    func reallyPresentCharacterSkillScene(_ sceneType: DBSceneType) {
        // Get the view
        let skView: SKView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Save off the scene we came from
        self.sceneBeforeSkills = sceneType
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: self.characterSkillScene!, ignoreMusic: false)
    }
    
    func endCharacterSkillScene() {
        // Get the view
        let skView: SKView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Present previous scene
        if (self.sceneBeforeSkills == DBSceneType.gameScene) {
            self.presentDBScene(skView, scene: self.gameScene!, ignoreMusic: false)
        } else if (self.sceneBeforeSkills == DBSceneType.mainMenuScene) {
            self.presentDBScene(skView, scene: self.mainMenuScene!, ignoreMusic: false)
        } else if (self.sceneBeforeSkills == DBSceneType.levelSelectionScene) {
            self.presentDBScene(skView, scene: self.levelSelectionScene!, ignoreMusic: false)
        }
    }
    
    /*
     func createCharacterSkillSceneAsCompletionHandler(completion: (result: CharacterSkillScene) -> Void) {
     let skillScene = self.createCharacterSkillScene()
     
     completion(result: skillScene)
     }*/
    
    func createMainMenuScene() -> MainMenuScene {
        let scene: MainMenuScene = MainMenuScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.viewController = self
        return scene
    }
    
    func presentMainMenuScene() {
        autoreleasepool {
            self.levelSelectionScene = nil
            self.introScene = nil
        }
        
        if self.mainMenuScene == nil {
            self.presentLoadingScreen(ignoreMusic: true)
            
            // Move to a background thread to do some long running work
            DispatchQueue.global(attributes: .qosUserInitiated).async {
                self.mainMenuScene = self.createMainMenuScene()
                
                DispatchQueue.main.async {
                    let skView: SKView = self.view as! SKView
                    skView.isMultipleTouchEnabled = true
                    
                    // Present the scene - pass through regulator
                    self.presentDBScene(skView, scene: self.mainMenuScene!, ignoreMusic: false)
                }
            }
        } else {
            let skView: SKView = self.view as! SKView
            skView.isMultipleTouchEnabled = true
            
            // Present the scene - pass through regulator
            self.presentDBScene(skView, scene: self.mainMenuScene!, ignoreMusic: false)
        }
    }
    
    func createLevelSelectionScene() -> LevelSelectionScene {
        let scene: LevelSelectionScene = LevelSelectionScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.viewController = self
        return scene
    }
    
    func presentLevelSelectionScene() {
        autoreleasepool {
            // self.gameScene = nil - DONT RELEASE THIS IT WILL CRASH BAD_ACCESS
            self.characterSkillScene = nil
            self.levelSelectionScene = nil
            self.mainMenuScene = nil
        }
        
        self.gameScene = nil
        
        self.presentLoadingScreen(ignoreMusic: true)
        
        /*
         //SKTextureAtlas.preloadTextureAtlases(GameTextures.sharedInstance.menuSceneAtlas) { () -> Void in
         self.levelSelectionScene = self.createLevelSelectionScene()
         let skView: SKView = self.view as! SKView
         skView.isMultipleTouchEnabled = true
         skView.showsFPS = false
         skView.showsNodeCount = false
         
         // Present the scene - pass through regulator
         self.presentDBScene(skView, scene: self.levelSelectionScene!)
         //}*/
        
        // Move to a background thread to do some long running work
        DispatchQueue.global(attributes: .qosUserInitiated).async {
            // Bounce back to the main thread to update the UI
            self.levelSelectionScene = self.createLevelSelectionScene()
            DispatchQueue.main.async {
                let skView: SKView = self.view as! SKView
                skView.isMultipleTouchEnabled = true
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                // Present the scene - pass through regulator
                self.presentDBScene(skView, scene: self.levelSelectionScene!, ignoreMusic: false)
            }
        }
    }
    
    func presentGameSceneLevel(_ level: Int, justRestarted: Bool) {
        //self.levelSelectionScene = nil
        
        self.presentLoadingScreen(ignoreMusic: false)
        
        autoreleasepool {
            self.gameScene = nil
            self.levelSelectionScene = nil
            self.mainMenuScene = nil
            self.introScene = nil
            self.characterSkillScene = nil
        }
        
        // Preload the texture atlases we need
        let world = GameData.sharedGameData.getSelectedCharacterData().getWorldForLevel(level)
        
        
        // Move to a background thread to do some long running work
        DispatchQueue.global(attributes: .qosUserInitiated).async {
            self.gameScene = GameScene(size: self.getScreenSize(), level: level, controller: self, justRestarted: justRestarted)
            self.gameScene!.scaleMode = SKSceneScaleMode.aspectFill
            self.gameScene!.viewController = self
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                let skView: SKView = self.view as! SKView
                skView.isMultipleTouchEnabled = true
                //skView.showsFPS = true
                //skView.showsNodeCount = true
                //skView.showsPhysics = true
                
                // Present the scene - pass through regulator
                self.presentDBScene(skView, scene: self.gameScene!, ignoreMusic: false)
            }
        }
        
        /*
         SKTextureAtlas.preloadTextureAtlases([GameTextures.sharedInstance.waterStoryTutorialAtlas]) { () -> Void in
         self.gameScene = GameScene(size: self.getScreenSize(), level: level, controller: self, justRestarted: justRestarted)
         self.gameScene!.scaleMode = SKSceneScaleMode.aspectFill
         self.gameScene!.viewController = self
         let skView: SKView = self.view as! SKView
         skView.isMultipleTouchEnabled = true
         //skView.showsFPS = true
         //skView.showsNodeCount = true
         //skView.showsPhysics = true
         
         // Present the scene - pass through regulator
         self.presentDBScene(skView, scene: self.gameScene!)
         }
        */
    }
    
    func representGameSceneLevel(_ level: Int, justRestarted: Bool) {
        //let loadingScene = LoadingScene(size: self.getScreenSize()) DJB removed on 3/13/16 - dont think I need to recreate it
        
        let skView: SKView = self.view as! SKView
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: self.loadingScene!, ignoreMusic: false)
        
        presentGameSceneLevel(level, justRestarted: justRestarted)
    }
    
    func presentLoadingScreen(ignoreMusic: Bool) {
        if self.loadingScene == nil {
            self.loadingScene = self.createLoadingScene()
        }
        
        let skView: SKView = self.view as! SKView
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: self.loadingScene!, ignoreMusic: ignoreMusic)
    }
    
    func createLoadingScene() -> LoadingScene {
        let scene: LoadingScene = LoadingScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.viewController = self
        return scene
    }
    
    func showAuthenticationViewController() {
        self.present(GameKitHelper.sharedInstance.authenticationViewController!, animated: true, completion: nil)
        
    }
    
    func playerAuthenticated() {
        // Get achievements
        GameKitHelper.sharedInstance.getAchievements()
        
        // Resync all the scores
        GameKitHelper.sharedInstance.resyncScores()
        
        // Enable the trophy button
        //self.mainMenuScene?.gameCenterButton?.hidden = false
    }
    
    func getScreenSize() -> CGSize {
        
        if UIDevice.current().userInterfaceIdiom == .phone {
            let skView: SKView = self.view as! SKView
            
            //NSLog("\(Double(round(100*Double(skView.bounds.height / skView.bounds.width))/100))")
            //NSLog("\(Double(round(100*(9.0 / 16.0))/100))")
            
            if Double(round(100*Double(skView.bounds.height / skView.bounds.width))/100) == Double(round(100*(9.0 / 16.0))/100) {
                return CGSize(width: 667, height: 375)
            } else {
                return CGSize(width: 562.5, height: 375)
            }
        } else if UIDevice.current().userInterfaceIdiom == .pad {
            //return CGSizeMake(562.5, 421.875)
            return CGSize(width: 1024, height: 768)
        }
        
        return CGSize(width: 667, height: 375)
    }
    
    func showLeaderboardAndAchievements(_ showLeaderboard: Bool) {
        // Init the following view controller object.
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        
        // Set self as its delegate.
        gcViewController.gameCenterDelegate = self
        
        // Depending on the parameter, show either the leaderboard or the achievements.
        if showLeaderboard {
            gcViewController.viewState = .leaderboards
            gcViewController.leaderboardIdentifier = Leaderboards.GameProgressGroup.rawValue
        }
        else {
            gcViewController.viewState = .achievements
        }
        // Finally present the view controller.
        self.present(gcViewController, animated: true, completion: nil)
    }
    
    func handleCloudHasMoreRecentDataThanLocal() {
        if !self.gvcInitialized || GameData.sharedGameData.cloudSyncing {
            // Need a custom view controller and present it overtop this other one..
            //self.presentViewController(CloudDataViewController(), animated: true, completion: nil)
            //CloudDataViewController().performSegueWithIdentifier("g", sender: self)
            
            // If the scene is not nil and the scene is a DBscene, make it ask user about cloud data
            let skView: SKView = self.view as! SKView
            
            // Not nil
            if skView.scene != nil {
                // This is a DBSCene
                if let dbScene = skView.scene as? DBScene {
                    dbScene.presentUserWithOptionToLoadCloudData()
                }
            }
            
            // Else, store this so we can do it later once we present a DBScene that can prompt the user
            self.userNeedsToDecideOnCloudData = true
        }
    }
    
    // We want to control this
    func presentDBScene(_ view: SKView, scene: DBScene, ignoreMusic: Bool) {
        
        // If we need to ask the user about their cloud data load preference, do it
        if self.userNeedsToDecideOnCloudData {
            // Open up the prompt on the scene
            scene.presentUserWithOptionToLoadCloudData()
            
            // Don't want to prompt again
            self.userNeedsToDecideOnCloudData = false
        }
        
        if scene.impactsMusic() && !ignoreMusic {
            if scene.hasOwnMusic() && self.backgroundPlayer != nil {
                self.backgroundPlayer!.stop()
            } else if !scene.hasOwnMusic() && self.backgroundPlayer != nil && !self.backgroundPlayer!.isPlaying && GameData.sharedGameData.preferenceMusic {
                self.backgroundPlayer!.currentTime = 0
                self.backgroundPlayer!.play()
            }
        }
        
        view.presentScene(scene)
    }
    
    func playMusic(_ play: Bool) {
        if play && self.backgroundPlayer != nil && GameData.sharedGameData.preferenceMusic == true && !self.backgroundPlayer!.isPlaying {
            self.backgroundPlayer!.currentTime = 0
            self.backgroundPlayer!.play()
        } else if !play && self.backgroundPlayer != nil && GameData.sharedGameData.preferenceMusic == false && self.backgroundPlayer!.isPlaying {
            self.backgroundPlayer!.stop()
        }
    }
    
    func playButtonSound() {
        if GameData.sharedGameData.preferenceSoundEffects == true && self.buttonSoundPlayer != nil {
            self.buttonSoundPlayer!.currentTime = 0
            self.buttonSoundPlayer!.play()
        }
    }
    
    func showRewardedVideo() {
        // Show rewarded video pre-roll message and video ad at location MainMenu. See Chartboost.h for available location options.
        Chartboost.showRewardedVideo(CBLocationGameOver)
    }
    
    func showInterstitialAd() {
        if !GameData.sharedGameData.adsUnlocked {
            // App delegate needs to record we're trying to show
            AdSupporter.sharedInstance.adReady = false
            
            // Show interstitial at main menu
            Chartboost.showInterstitial(CBLocationMainMenu)
        }
    }
    
    func cacheInterstitialAd() {
        if !GameData.sharedGameData.adsUnlocked {
            Chartboost.cacheInterstitial(CBLocationMainMenu)
        }
    }
    
    // Game Center
    func getAchievements() {
        GameKitHelper.sharedInstance.getAchievements()
    }
    
    func syncAchievements() {
        GameKitHelper.sharedInstance.syncAchievements()
    }
    
    func resyncScore() {
        GameKitHelper.sharedInstance.resyncScores()
    }
    
    func saveData() {
        //DispatchQueue.global(attributes: .qosUserInitiated).async {
        GameData.sharedGameData.save()
        //}
        
    }
}
