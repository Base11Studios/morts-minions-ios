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
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate {

//MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate {

    let REWARD_AD_ID = "b0ddefd0a8a14252a14a64da0728dade"
    
    //MoPubSDK
    //var interstitial: MPInterstitialAdController?
    
    static var AD_LOCATION_REVIVE: String = "revive"
    static var AD_LOCATION_HEART_BOOST: String = "heartBoost"
    
    // Admob
    var interstitial: GADInterstitial?
    
    // Video rewards
    var presentingVideo: Bool = false
    var completedVideo: Bool = false
    var dismissingVideo: Bool = false
    var videoAdLocation: String = ""
    
    var characterSkillSceneCharacter: CharacterType?
    
    var sceneBeforeSkills: DBSceneType?
    
    // Menu music?
    var backgroundPlayer: AVAudioPlayer = AVAudioPlayer()
    var buttonSoundPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var isReloading: Bool = false
    
    var gvcInitialized: Bool = false
    
    var firstTime: Bool = true
    
    // Cloud data flag - is there newer cloud data but we couldn't ask user yet
    var userNeedsToDecideOnCloudData: Bool = false
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
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
    
    override func willMove(toParentViewController parent: UIViewController?) {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: CloudHasMoreRecentDataThanLocal), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PresentAuthenticationViewController), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LocalPlayerIsAuthenticated), object: nil)
    }
    
    override func viewDidLoad() {
        // Setup observer for cloud data change
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameViewController.ubiquitousKeyValueStoreDidChangeExternally),
                                               name:  NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)
        
        // Setup CUSTOM observer for cloud has more recent data than local
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameViewController.handleCloudHasMoreRecentDataThanLocal),
                                               name: NSNotification.Name(rawValue: CloudHasMoreRecentDataThanLocal),
                                               object: nil)
        
        // Setup CUSTOM observer for gamekit auth
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameViewController.showAuthenticationViewController),
                                               name: NSNotification.Name(rawValue: PresentAuthenticationViewController),
                                               object: nil)
        
        // Setup CUSTOM observer for player is authenticated
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameViewController.playerAuthenticated),
                                               name: NSNotification.Name(rawValue: LocalPlayerIsAuthenticated),
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
        
        if UIDevice.current.userInterfaceIdiom == .phone && ScaleBuddy.sharedInstance.screenSize.width == 562.5 {
            ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.original4
        } else if UIDevice.current.userInterfaceIdiom == .phone && ScaleBuddy.sharedInstance.screenSize.width == 667 {
            ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.wide6
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.originaliPad
        }
        
        if firstTime {
            self.firstTime = true // ADDD SET TO FALSE
            
            // Setup the scale helpers
            ScaleBuddy.sharedInstance.screenSize = self.getScreenSize()
            if ScaleBuddy.sharedInstance.screenSize.width == 667 {
                ScaleBuddy.sharedInstance.playerHorizontalLeft = 8
                ScaleBuddy.sharedInstance.playerHorizontalRight = 3.5
            } else if ScaleBuddy.sharedInstance.screenSize.width == 562.5 || ScaleBuddy.sharedInstance.screenSize.width == 1024 {
                ScaleBuddy.sharedInstance.playerHorizontalLeft = 10
                ScaleBuddy.sharedInstance.playerHorizontalRight = 6
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone && ScaleBuddy.sharedInstance.screenSize.width == 562.5 {
                ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.original4
            } else if UIDevice.current.userInterfaceIdiom == .phone && ScaleBuddy.sharedInstance.screenSize.width == 667 {
                ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.wide6
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                ScaleBuddy.sharedInstance.deviceSize = DeviceSizes.originaliPad
            }
            
            // Try to auth user
            GameKitHelper.sharedInstance.authenticateLocalPlayer(false)
            
            // Cache ads and such
            // Instantiate the interstitial using the class convenience method.
            self.setupAdDelegate()
            
            //interstitial = self.createAndLoadInterstitial()
            self.cacheRewardedVideo()
            
            // Set restoration identifier
            self.restorationIdentifier = "GameViewController"
            
            // Setup Music
            self.setupMusic()
            
            // Setup sound
            self.setupButtonSound()
            
            // Setup sound props
            self.setSessionPlayerPassive()
            
            // Create loading
            //self.loadingScene = self.createLoadingScene()
            
            // Present first scene
            self.presentIntroductionScene()
            
            // Done loading
            isReloading = false
        }
    }
    
    func setupAdDelegate() {
        //GADRewardBasedVideoAd.sharedInstance().delegate = self
        //Appodeal.setRewardedVideoDelegate(self)
        //Appodeal.setInterstitialDelegate(self)
        
        //self.interstitial = MPInterstitialAdController(forAdUnitId: "af95a96f865b431197a07916fa38fffd")
        //self.interstitial!.delegate = self
        //MoPub.sharedInstance().initializeRewardedVideo(withGlobalMediationSettings: [], delegate: self)
        
        
    }
    
    func setupMusic() {
        guard let path = Bundle.main.url(forResource: "menu", withExtension: "m4a") else {
            return
        }
        
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: path)
            backgroundPlayer.numberOfLoops = -1
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
        guard let path = Bundle.main.url(forResource: "click-1", withExtension: "caf") else {
            return
        }
        
        do {
            buttonSoundPlayer = try AVAudioPlayer(contentsOf: path)
            buttonSoundPlayer.numberOfLoops = 0
        } catch {
            // No music :(
        }
    }
    
    @objc func ubiquitousKeyValueStoreDidChangeExternally() {
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
        //self.characterSkillScene = nil
        //self.characterSkillSceneCharacter = nil
        //self.levelSelectionScene = nil
        //self.mainMenuScene = nil
        
        // Now load the menu screen
        /*
         SKTextureAtlas.preloadTextureAtlases(GameTextures.sharedInstance.menuSceneAtlas) { () -> Void in
         self.presentIntroductionScene()
         }*/
        
        // Move to a background thread to do some long running work
        DispatchQueue.global().async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.presentIntroductionScene()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func createIntroductionScene() -> IntroductionScene {
        let scene: IntroductionScene = IntroductionScene(size: getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.viewController = self
        return scene
    }
    
    func presentIntroductionScene() {
        let introScene: IntroductionScene = self.createIntroductionScene()
        
        /*
         if self.characterSkillScene == nil {
         self.characterSkillScene = self.createCharacterSkillScene()
         }*/
        /*
         if self.levelSelectionScene == nil {
         self.levelSelectionScene = self.createLevelSelectionScene()
         }*/
        /*
         if self.mainMenuScene == nil {
         self.mainMenuScene = self.createMainMenuScene()
         }*/
        
        self.gvcInitialized = true
        
        let skView: SKView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: introScene, ignoreMusic: false)
    }
    
    func createCharacterSkillScene(returnScene: DBScene) -> CharacterSkillScene {
        let scene = CharacterSkillScene(size: self.getScreenSize(), returnScene: returnScene)
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.viewController = self
        
        // Also set the selected char
        self.characterSkillSceneCharacter = GameData.sharedGameData.selectedCharacter
        
        return scene
    }
    
    func presentCharacterSkillScene(returnScene: DBScene) {
        self.presentLoadingScreen(ignoreMusic: true)
        
        //if self.characterSkillSceneCharacter == nil || self.characterSkillScene == nil || self.characterSkillSceneCharacter! != GameData.sharedGameData.selectedCharacter {
        //    self.characterSkillScene = nil
        
        /*
         SKTextureAtlas.preloadTextureAtlases(GameTextures.sharedInstance.menuSceneAtlas) { () -> Void in
         self.characterSkillScene = self.createCharacterSkillScene()
         
         self.reallyPresentCharacterSkillScene(sceneType)
         }*/
        // Move to a background thread to do some long running work
        DispatchQueue.global().async {
            // Bounce back to the main thread to update the UI
            let characterSkillScene = self.createCharacterSkillScene(returnScene: returnScene)
            
            DispatchQueue.main.async {
                let skView: SKView = self.view as! SKView
                skView.isMultipleTouchEnabled = true
                
                // Save off the scene we came from
                //self.sceneBeforeSkills = sceneType
                
                // Present the scene - pass through regulator
                self.presentDBScene(skView, scene: characterSkillScene, ignoreMusic: false)
            }
        }
        //} else {
        // Character is same, don't need to reload scene
        //    self.reallyPresentCharacterSkillScene(sceneType)
        //}
    }
    /*
     func reallyPresentCharacterSkillScene(_ sceneType: DBSceneType) {
     // Get the view
     let skView: SKView = self.view as! SKView
     skView.isMultipleTouchEnabled = true
     
     // Save off the scene we came from
     self.sceneBeforeSkills = sceneType
     
     // Present the scene - pass through regulator
     self.presentDBScene(skView, scene: self.characterSkillScene!, ignoreMusic: false)
     }*/
    
    func endCharacterSkillScene(scene: DBScene) {
        // Get the view
        let skView: SKView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Present previous scene
        //if (self.sceneBeforeSkills == DBSceneType.gameScene) {
        self.presentDBScene(skView, scene: scene, ignoreMusic: false)
        /*} else if (self.sceneBeforeSkills == DBSceneType.mainMenuScene) {
         self.presentDBScene(skView, scene: self.mainMenuScene!, ignoreMusic: false)
         } else if (self.sceneBeforeSkills == DBSceneType.levelSelectionScene) {
         self.presentDBScene(skView, scene: self.levelSelectionScene!, ignoreMusic: false)
         }*/
    }
    
    /*
     func createCharacterSkillSceneAsCompletionHandler(completion: (result: CharacterSkillScene) -> Void) {
     let skillScene = self.createCharacterSkillScene()
     
     completion(result: skillScene)
     }*/
    
    func createMainMenuScene() -> MainMenuScene {
        let scene: MainMenuScene = MainMenuScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.viewController = self
        return scene
    }
    
    func presentMainMenuScene() {
        //autoreleasepool {
        //self.levelSelectionScene = nil
        //self.introScene = nil
        //}
        
        //if self.mainMenuScene == nil {
        self.presentLoadingScreen(ignoreMusic: true)
        
        // Move to a background thread to do some long running work
        DispatchQueue.global().async {
            let mainMenuScene = self.createMainMenuScene()
            
            DispatchQueue.main.async {
                let skView: SKView = self.view as! SKView
                skView.isMultipleTouchEnabled = true
                
                // Present the scene - pass through regulator
                self.presentDBScene(skView, scene: mainMenuScene, ignoreMusic: false)
            }
        }
        /*} else {
         let skView: SKView = self.view as! SKView
         skView.isMultipleTouchEnabled = true
         
         // Present the scene - pass through regulator
         self.presentDBScene(skView, scene: self.mainMenuScene!, ignoreMusic: false)
         }*/
    }
    
    func createLevelSelectionScene() -> LevelSelectionScene {
        let scene: LevelSelectionScene = LevelSelectionScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.viewController = self
        return scene
    }
    
    func presentLevelSelectionScene() {
        //autoreleasepool {
        // self.gameScene = nil - DONT RELEASE THIS IT WILL CRASH BAD_ACCESS
        //self.characterSkillScene = nil
        //self.levelSelectionScene = nil
        //self.mainMenuScene = nil
        //self.gameScene = nil
        //self.introScene = nil
        //}
        
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
        DispatchQueue.global().async {
            
            // Bounce back to the main thread to update the UI
            let levelSelectionScene = self.createLevelSelectionScene()
            DispatchQueue.main.async {
                let skView: SKView = self.view as! SKView
                skView.isMultipleTouchEnabled = true
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                // Present the scene - pass through regulator
                self.presentDBScene(skView, scene: levelSelectionScene, ignoreMusic: false)
            }
        }
    }
    
    func presentGameSceneLevel(_ level: Int, justRestarted: Bool) {
        //self.levelSelectionScene = nil
        
        self.presentLoadingScreen(ignoreMusic: false)
        
        //autoreleasepool {
        /*self.gameScene = nil
         self.levelSelectionScene = nil
         self.mainMenuScene = nil
         self.introScene = nil
         self.characterSkillScene = nil*/
        //}
        
        /*
        // Preload the texture atlases we need
        let world = GameData.sharedGameData.getSelectedCharacterData().getWorldForLevel(level)
        
        SKTextureAtlas.preloadTextureAtlases(GameTextures.sharedInstance.getAtlasArrayForWorld(world: world)) { () -> Void in
            let gameScene = GameScene(size: self.getScreenSize(), level: level, controller: self, justRestarted: justRestarted)
            gameScene.scaleMode = SKSceneScaleMode.aspectFit
            gameScene.viewController = self
            let skView: SKView = self.view as! SKView
            skView.isMultipleTouchEnabled = true
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            //skView.showsPhysics = true
            
            // Present the scene - pass through regulator
            self.presentDBScene(skView, scene: gameScene, ignoreMusic: false)
        }
 */
        
        // Move to a background thread to do some long running work
        DispatchQueue.global().async {
            let gameScene = GameScene(size: self.getScreenSize(), level: level, controller: self, justRestarted: justRestarted)
            gameScene.scaleMode = SKSceneScaleMode.aspectFit
            gameScene.viewController = self
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                let skView: SKView = self.view as! SKView
                skView.isMultipleTouchEnabled = true
                //skView.showsFPS = true
                //skView.showsNodeCount = true
                //skView.showsPhysics = true
                
                // Present the scene - pass through regulator
                self.presentDBScene(skView, scene: gameScene, ignoreMusic: false)
            }
        }
    }
    
    func representGameSceneLevel(_ level: Int, justRestarted: Bool) {
        //let loadingScene = LoadingScene(size: self.getScreenSize()) DJB removed on 3/13/16 - dont think I need to recreate it
        
        let skView: SKView = self.view as! SKView
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: self.createLoadingScene(), ignoreMusic: false)
        
        presentGameSceneLevel(level, justRestarted: justRestarted)
    }
    
    func presentLoadingScreen(ignoreMusic: Bool) {
        //if self.loadingScene == nil {
        //    self.loadingScene = self.createLoadingScene()
        //}
        
        let skView: SKView = self.view as! SKView
        
        // Present the scene - pass through regulator
        self.presentDBScene(skView, scene: self.createLoadingScene(), ignoreMusic: ignoreMusic)
    }
    
    func createLoadingScene() -> LoadingScene {
        let scene: LoadingScene = LoadingScene(size: self.getScreenSize())
        scene.scaleMode = SKSceneScaleMode.aspectFit
        scene.viewController = self
        return scene
    }
    
    @objc func showAuthenticationViewController() {
        self.present(GameKitHelper.sharedInstance.authenticationViewController!, animated: true, completion: nil)
        
    }
    
    @objc func playerAuthenticated() {
        DispatchQueue.global().async {
            // Get achievements
            GameKitHelper.sharedInstance.getAchievements()
            
            DispatchQueue.main.async {
                // Resync all the scores
                GameKitHelper.sharedInstance.resyncScores()
            }
            
            // Enable the trophy button
            //self.mainMenuScene?.gameCenterButton?.hidden = false
        }
    }
    
    func getScreenSize() -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let skView: SKView = self.view as! SKView
            
            //NSLog("\(Double(round(100*Double(skView.bounds.height / skView.bounds.width))/100))")
            //NSLog("\(Double(round(100*(9.0 / 16.0))/100))")
            let partial = round(100*Double(skView.bounds.height / skView.bounds.width))
            if Double(partial/100) == Double(round(100*(9.0 / 19.5))/100) {
                return CGSize(width: 667, height: 375)
            } else if Double(partial/100) == Double(round(100*(9.0 / 16.0))/100) {
                return CGSize(width: 667, height: 375)
            } else {
                return CGSize(width: 562.5, height: 375)
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
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
    
    @objc func handleCloudHasMoreRecentDataThanLocal() {
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
        
        if GameData.sharedGameData.preferenceMusic {
            if scene.impactsMusic() && !ignoreMusic {
                if scene.hasOwnMusic() && self.backgroundPlayer.isPlaying {
                    self.backgroundPlayer.stop()
                } else if !scene.hasOwnMusic() && !self.backgroundPlayer.isPlaying && GameData.sharedGameData.preferenceMusic {
                    self.backgroundPlayer.currentTime = 0
                    self.backgroundPlayer.play()
                }
            }
        }
        
        view.presentScene(scene)
    }
    
    func playMusic(_ play: Bool) {
        if play && GameData.sharedGameData.preferenceMusic == true && !self.backgroundPlayer.isPlaying {
            self.backgroundPlayer.currentTime = 0
            self.backgroundPlayer.play()
        } else if !play && GameData.sharedGameData.preferenceMusic == false && self.backgroundPlayer.isPlaying {
            self.backgroundPlayer.stop()
        }
    }
    
    func playButtonSound() {
        if GameData.sharedGameData.preferenceSoundEffects == true {
            self.buttonSoundPlayer.currentTime = 0
            self.buttonSoundPlayer.play()
        }
    }
    
    func videoAdReady() -> Bool {
        return GADRewardBasedVideoAd.sharedInstance().isReady //return MPRewardedVideo.hasAdAvailable(forAdUnitID: REWARD_AD_ID)
    }
    
    func showRewardedVideo(location: String) {
        self.videoAdLocation = location
        
        self.presentingVideo = true
        self.dismissingVideo = false
        
        if self.videoAdReady() {
            //MPRewardedVideo.presentAd(forAdUnitID: REWARD_AD_ID, from: self)
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    
    func showInterstitialAd() {
        if !GameData.sharedGameData.adsUnlocked {
            // Show interstitial at main menu
            if self.interstitialAdReady() {
                //self.interstitial!.show(from: self)
                interstitial!.present(fromRootViewController: self)
            }
        }
    }
 
    func heartBoostReady() -> Bool {
        // Get date minutes ago. If time last redeemed or seen > that, dont allow
        let calendar = NSCalendar.autoupdatingCurrent
        let requiredDate = calendar.date(byAdding: Calendar.Component.minute, value: GameData.sharedGameData.getHeartBoostCooldown(), to: Date())!
        
        // Reset heart boost if needed
        if requiredDate > GameData.sharedGameData.heartBoostLastUsed {
            GameData.sharedGameData.configureHeartBoost(enable: false)
        }

        let promptDate = calendar.date(byAdding: Calendar.Component.minute, value: GameData.heartBoostPromptCooldown, to: Date())!
        
        // If we have 0 heart boost and prompt time < now - 10, return true, else false
        return GameData.sharedGameData.heartBoostCount == 0 && promptDate > GameData.sharedGameData.heartBoostLastPrompted
    }
    
    func interstitialAdReady() -> Bool {
        return interstitial != nil && interstitial!.isReady && !interstitial!.hasBeenUsed //self.interstitial!.ready
    }
    
    func cacheInterstitialAd() {
        if !GameData.sharedGameData.adsUnlocked && !self.interstitialAdReady() {
            interstitial = createAndLoadInterstitial()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        // Fetch the interstitial ad.
        //self.interstitial!.loadAd()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4505737160765142/6044000311") // REAL
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") // TEST
        interstitial!.delegate = self
        interstitial!.load(GADRequest())
        return interstitial!
    }
    
    func cacheRewardedVideo() {
        if !self.videoAdReady() {
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                        //withAdUnitID: "ca-app-pub-3940256099942544/1712485313") // TEST
            GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                        withAdUnitID: "ca-app-pub-4505737160765142/1908178718") // REAL
            //MPRewardedVideo.loadAd(withAdUnitID: REWARD_AD_ID, withMediationSettings: [])
        }
    }
    
    // Game Center
    func getAchievements() {
        DispatchQueue.global().async {
            // Get achievements
            GameKitHelper.sharedInstance.getAchievements()
        }
    }
    
    func syncAchievements() {
        DispatchQueue.global().async {
            GameKitHelper.sharedInstance.syncAchievements()
        }
    }
    
    func resyncScore() {
        //DispatchQueue.global().async {
            GameKitHelper.sharedInstance.resyncScores()
        //}
    }
    
    func saveData() {
        //DispatchQueue.global(attributes: .qosUserInitiated).async {
        GameData.sharedGameData.save()
        //}
        
    }
    
    // ******************************** INTERSTITIAL ADS **********************
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ProgressPastInterstitialAd"), object: nil)
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        interstitial = createAndLoadInterstitial()
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        AdSupporter.sharedInstance.showPauseMenu = true
    }
    
    // ************************* REWARDED VIDEO CALLBACKS *************
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        // Remove the loading dialog
        //self.dismissLoadingDialog() Shouldn't need anymore
        
        // Store something to show we presented a video
        self.presentingVideo = true
        self.dismissingVideo = false
        self.completedVideo = false
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        //self.endVideoSuccessfully() - Don't complete here, just mark it was watched and let didDisappear handle it
        self.completedVideo = true
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        // If video was completed, dont do anything, otherwise send dismiss dialog if not done
        if !self.completedVideo && self.presentingVideo && !self.dismissingVideo {
            self.endVideoUnsuccessfully()
        } else if !self.dismissingVideo && self.completedVideo {
            self.endVideoSuccessfully()
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        self.cacheRewardedVideo()
    }

    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        // Store that the video was completed.
        if self.presentingVideo && !self.completedVideo {
            self.completedVideo = true
        }
    }
    
    private func dismissLoadingDialog() {
        // Send notification that gamescene will pick up
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissLoadingDialog"), object: nil)
    }
    
    private func endVideoSuccessfully() {
        if self.videoAdLocation == GameViewController.AD_LOCATION_REVIVE {
            // Update last watched flag to current time
            GameData.sharedGameData.lastVideoAdWatch = Date()
        
            // Send notification that gamescene will pick up
            NotificationCenter.default.post(name: Notification.Name(rawValue: "RejuvenatePlayer"), object: nil)
        } else if self.videoAdLocation == GameViewController.AD_LOCATION_HEART_BOOST {
            // Send notification that gamescene will pick up
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayerHeartBoost"), object: nil)
        }
        
        // Reset flags
        self.presentingVideo = false
        self.completedVideo = false
        self.dismissingVideo = true
    }
    
    private func endVideoUnsuccessfully() {
        //if self.videoAdLocation == GameViewController.AD_LOCATION_REVIVE {
            // Send notification that the gamescene will pick up
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "DontRejuvenatePlayer"), object: nil)
        //}
        
        // Reset flags
        self.presentingVideo = false
        self.completedVideo = false
        self.dismissingVideo = true
    }
}
