//
//  LevelSelectionScene.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(LevelSelectionScene)
class LevelSelectionScene : DBScene {
    var scrollingLevelsContainer: SKSpriteNode
    
    // Levels
    var scrollingEarthLevels: ScrollingLevelNodeRow?
    var scrollingWaterLevels: ScrollingLevelNodeRow?
    var scrollingFireLevels: ScrollingLevelNodeRow?
    var scrollingAirLevels: ScrollingLevelNodeRow?
    var scrollingSpiritLevels: ScrollingLevelNodeRow?
    var centerNodeBackground: SKSpriteNode?
    
    var levelSelector: SKSpriteNode
    var backButton: LevelSelectBackButton?
    var skillsButton: DBSceneSkillsButton?
    var startButton: LevelSelectStartButton?
    
    var backdropBar: SKSpriteNode
    
    // Consts
    let numberOfLevels: Int = 5 // TODO Update
    var levelSelected: Int = 1 // Default level
    let nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    // Flag for scene just initialized
    var justInitialized: Bool = true
    
    // Character stars
    var totalStars: LabelWithShadow?
    var totalCitrine: LabelWithShadow?
    var totalDiamonds: LabelWithShadow?
    var totalStarsIcon: SKSpriteNode?
    var totalCitrineIcon: SKSpriteNode?
    var totalDiamondsIcon: SKSpriteNode?
    
    var totalLevels: Int = 0
    
    // Worlds
    var earthWorld: WorldNode?
    var waterWorld: WorldNode?
    var airWorld: WorldNode?
    var fireWorld: WorldNode?
    var spiritWorld: WorldNode?
    var worldSeparator: SKSpriteNode?
    var selectedWorld: WorldNode?
    
    var sceneView: UIView?
    
    // Hearts
    //var heartBoostContainer: HeartBoostContainer?
    
    init(size: CGSize) {
        // Initialize variables
        //var worldSelected = GameData.sharedGameData.getSelectedCharacterData().lastPlayedWorld
        //self.levelSelected = GameData.sharedGameData.getSelectedCharacterData().getLastPlayedLevelByWorld(worldSelected)
        
        // Level selector view ( this is the background & parent that everything is added to)
        self.levelSelector = SKSpriteNode(color: MerpColors.background, size: CGSize(width: size.width, height: size.height))
        self.scrollingLevelsContainer = SKSpriteNode(texture: nil, size: CGSize(width: size.width, height: size.height * 7/15))
        
        // Init stuff
        self.backdropBar = SKSpriteNode(texture: SKTexture(imageNamed: "backdrop_bar"))
        
        // Call super init
        super.init(size: size, settings: false, loadingOverlay: false, purchaseMenu: false, rateMe: false)
        
        // Heart Boosts
        //self.heartBoostContainer = HeartBoostContainer(scene: self, selectedLevel: GameData.sharedGameData.getSelectedCharacterData().lastHeartBoost)
        //self.heartBoostContainer!.position = CGPoint(x: 0, y: -self.frame.size.height / 2 + self.heartBoostContainer!.calculateAccumulatedFrame().height * 1.0 - self.nodeBuffer * 0.5)
        
        // Create levels
        self.scrollingEarthLevels = ScrollingLevelNodeRow(size: CGSize(width: self.levelSelector.size.width, height: self.levelSelector.size.height), worldName: "earth", scene: self)
        self.scrollingWaterLevels = ScrollingLevelNodeRow(size: CGSize(width: self.levelSelector.size.width, height: self.levelSelector.size.height), worldName: "water", scene: self)
        self.scrollingFireLevels = ScrollingLevelNodeRow(size: CGSize(width: self.levelSelector.size.width, height: self.levelSelector.size.height), worldName: "fire", scene: self)
        self.scrollingAirLevels = ScrollingLevelNodeRow(size: CGSize(width: self.levelSelector.size.width, height: self.levelSelector.size.height), worldName: "air", scene: self)
        self.scrollingSpiritLevels = ScrollingLevelNodeRow(size: CGSize(width: self.levelSelector.size.width, height: self.levelSelector.size.height), worldName: "spirit", scene: self)
        
        self.levelSelector.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)

        // Create a button just to see the size
        let sampleLevelButton: SKSpriteNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("button_level_selector"))
        // Buffer size between buttons
        
        // Level progress
        self.totalStars = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        self.totalCitrine = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        self.totalDiamonds = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false)
        
        self.totalStarsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
        self.totalCitrineIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("superstar"))
        self.totalDiamondsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem"))

        // Mask and crop nodes
        let maskNode: SKSpriteNode = self.levelSelector.copy() as! SKSpriteNode
        let cropNode: SKCropNode = SKCropNode() // TODO make it SKNode()??
        cropNode.maskNode = maskNode
        cropNode.addChild(self.levelSelector)
        self.addChild(cropNode)
        
        // Operation buttons
        self.backButton = LevelSelectBackButton(scene: self)
        //self.startButton = LevelSelectStartButton(scene: self)
        self.skillsButton = DBSceneSkillsButton(scene: self, sceneType: DBSceneType.levelSelectionScene, size: DBButtonSize.extrasmall)
        
        self.backdropBar.position = CGPoint(x: 0, y: self.size.height / 2 - self.nodeBuffer - self.backdropBar.size.height / 2)
        self.backButton!.position = CGPoint(x: -self.size.width/2 + nodeBuffer + self.backButton!.size.width/2, y: self.backdropBar.position.y)
        //self.skillsButton!.position = CGPointMake(self.backButton!.position.x + nodeBuffer + self.backButton!.size.width/2 + self.skillsButton!.size.width / 2, self.backdropBar.position.y)
        self.skillsButton!.position = CGPoint(x: self.size.width/2 - nodeBuffer - self.skillsButton!.size.width/2, y: self.backdropBar.position.y)
        
        // Background of the center node
        self.centerNodeBackground = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("button_level_selector_highlight"))
        
        self.centerNodeBackground!.position = CGPoint(x: 0, y: getLevelNodeHeight(sampleLevelButton.size.height))
        self.centerNodeBackground!.setScale(0.8)

        self.scrollingLevelsContainer.addChild(self.centerNodeBackground!)
        
        // Add scrolling nodes
        self.levelSelector.addChild(self.scrollingLevelsContainer)
        self.scrollingLevelsContainer.addChild(self.scrollingEarthLevels!)
        self.scrollingLevelsContainer.addChild(self.scrollingWaterLevels!)
        self.scrollingLevelsContainer.addChild(self.scrollingFireLevels!)
        self.scrollingLevelsContainer.addChild(self.scrollingAirLevels!)
        self.scrollingLevelsContainer.addChild(self.scrollingSpiritLevels!)
        
        // Create the level buttons/nodes
        self.createLevelNodes(sampleLevelButton.size.height)
        
        var challengeAdjuster: CGFloat = 0
        //if GameData.sharedGameData.getSelectedCharacterData().challengesUnlocked(1) {
        challengeAdjuster = self.nodeBuffer * 1.7
        //}
        
        self.scrollingLevelsContainer.position = CGPoint(x: 0,y: -64 * ScaleBuddy.sharedInstance.getGameScaleAmount(false) - challengeAdjuster)
        self.scrollingEarthLevels!.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.scrollingWaterLevels!.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.scrollingFireLevels!.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.scrollingAirLevels!.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.scrollingSpiritLevels!.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        // Move to the selected node
        self.moveToSelectedNode()
        
        // Update details
        self.scrollingEarthLevels!.displayLevelDetails(self.scrollingEarthLevels!.levelSelected)
        self.scrollingWaterLevels!.displayLevelDetails(self.scrollingWaterLevels!.levelSelected)
        self.scrollingFireLevels!.displayLevelDetails(self.scrollingFireLevels!.levelSelected)
        self.scrollingAirLevels!.displayLevelDetails(self.scrollingAirLevels!.levelSelected)
        self.scrollingSpiritLevels!.displayLevelDetails(self.scrollingSpiritLevels!.levelSelected)
        
        // Unspent skill points
        // Star icon
        self.totalStarsIcon?.setScale(0.74)
        
        // Star label
        self.totalStars?.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalStars?.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalStars?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        // Citrine icon
        self.totalCitrineIcon?.setScale(0.74)
        
        // Citrine label
        self.totalCitrine?.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalCitrine?.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalCitrine?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        // Diamonds icon
        self.totalDiamondsIcon?.setScale(0.74)
        
        // Diamonds label
        self.totalDiamonds?.setFontSize(round(25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.totalDiamonds?.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
        self.totalDiamonds?.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        
        self.updateRewards()
        
        // Worlds
        self.earthWorld = WorldNode(levelNumber: 1, worldNumber: 1, worldName: "earth", relatedLevelSelector: self.scrollingEarthLevels!, dbScene: self)
        self.waterWorld = WorldNode(levelNumber: 17, worldNumber: 2, worldName: "water", relatedLevelSelector: self.scrollingWaterLevels!, dbScene: self)
        self.fireWorld = WorldNode(levelNumber: 33, worldNumber: 3, worldName: "fire", relatedLevelSelector: self.scrollingFireLevels!, dbScene: self)
        self.airWorld = WorldNode(levelNumber: 49, worldNumber: 4, worldName: "air", relatedLevelSelector: self.scrollingAirLevels!, dbScene: self)
        self.spiritWorld = WorldNode(levelNumber: 65, worldNumber: 5, worldName: "spirit", relatedLevelSelector: self.scrollingSpiritLevels!, dbScene: self)
        
        // NOTE - HIDING SPIRIT TEMPORARILY WHILE IN PROGRESS
        self.spiritWorld!.isHidden = true
        
        // Worlds
        self.earthWorld?.setScale(0.85)
        self.waterWorld?.setScale(0.85)
        self.fireWorld?.setScale(0.85)
        self.airWorld?.setScale(0.85)
        self.spiritWorld?.setScale(0.85)
        
        // Worlds
        var worldAdjuster: CGFloat = 1.0
        let fourAdjuster = (self.earthWorld!.size.width / 2)
        self.earthWorld!.position = CGPoint(x: (self.earthWorld!.size.width + self.nodeBuffer/2) * -2 + fourAdjuster, y: self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.earthWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.waterWorld!.position = CGPoint(x: (self.waterWorld!.size.width + self.nodeBuffer/2) * -1 + fourAdjuster, y: self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.waterWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.fireWorld!.position = CGPoint(x: 0 + fourAdjuster, y: self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.fireWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.airWorld!.position = CGPoint(x: (self.airWorld!.size.width + self.nodeBuffer/2) * 1 + fourAdjuster, y: self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.airWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        
        // NOTE - BELOW POSITIONING IS FOR 5 WORLDS
        /*
        var worldAdjuster: CGFloat = 0.4
        self.earthWorld!.position = CGPointMake((self.earthWorld!.size.width + self.nodeBuffer/2) * -2, self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.earthWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.waterWorld!.position = CGPointMake((self.waterWorld!.size.width + self.nodeBuffer/2) * -1, self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.waterWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.fireWorld!.position = CGPointMake(0, self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.fireWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.airWorld!.position = CGPointMake((self.airWorld!.size.width + self.nodeBuffer/2) * 1, self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.airWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
        self.spiritWorld!.position = CGPointMake((self.spiritWorld!.size.width + self.nodeBuffer/2) * 2, self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.spiritWorld!.size.height / 2 - self.nodeBuffer*worldAdjuster)
         */
        
        // Separator
        self.worldSeparator = SKSpriteNode(texture: SKTexture(imageNamed: "underline_bar"))
        
        self.worldSeparator!.position = CGPoint(x: 0, y: self.waterWorld!.position.y - self.waterWorld!.size.height / 2 - self.nodeBuffer * 1.2 - challengeAdjuster)
        
        self.levelSelector.addChild(self.worldSeparator!)
        //self.levelSelector.addChild(self.heartBoostContainer!)
        
        // Add to level selector
        self.levelSelector.addChild(self.earthWorld!)
        self.levelSelector.addChild(self.waterWorld!)
        self.levelSelector.addChild(self.fireWorld!)
        self.levelSelector.addChild(self.airWorld!)
        self.levelSelector.addChild(self.spiritWorld!)
        
        self.levelSelector.addChild(self.backdropBar)
        self.levelSelector.addChild(self.totalStars!)
        self.levelSelector.addChild(self.totalStarsIcon!)
        
        self.levelSelector.addChild(self.totalCitrine!)
        self.levelSelector.addChild(self.totalCitrineIcon!)
        
        self.levelSelector.addChild(self.totalDiamonds!)
        self.levelSelector.addChild(self.totalDiamondsIcon!)
        
        //self.levelSelector.addChild(self.startButton!)
        self.levelSelector.addChild(self.backButton!)
        self.levelSelector.addChild(self.skillsButton!)
        
        // Select the world
        let worldSelected = GameData.sharedGameData.getSelectedCharacterData().lastPlayedWorld
        
        if worldSelected == "earth" {
            self.selectWorld(self.earthWorld!)
        } else if worldSelected == "water" {
            self.selectWorld(self.waterWorld!)
        } else if worldSelected == "fire" {
            self.selectWorld(self.fireWorld!)
        } else if worldSelected == "air" {
            self.selectWorld(self.airWorld!)
        } else if worldSelected == "spirit" {
            self.selectWorld(self.spiritWorld!)
        }
        
        // Tutorials for UX
        self.createUxTutorials()
    }
    
    func createUxTutorials() {
        var tutorialAck: Double?
        var tutorialKey: String
        var tutorialVersion: Double
        
        // First Skill
        tutorialKey = "UXTutorialLevelSelectionPickLevel"
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        // Show the first skill being unlocked already
        if ((tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion))) || GameData.sharedGameData.getSelectedCharacterData().godMode {
            let tutorial = UXTutorialDialog(frameSize: self.size, description: "click the level number to start playing.", scene: self, size: "Medium", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip!)
            
            // First skill - convert it to the right coords
            let point: CGPoint = self.convert(self.centerNodeBackground!.position, from: self.centerNodeBackground!.parent!)
            let point2: CGPoint = self.convert(point, to: tutorial.containerBackground)
            
            tutorial.containerBackground.position = CGPoint(x: point2.x, y: point2.y - self.selectedWorld!.relatedLevelSelector!.levelSelectedNode!.calculateAccumulatedFrame().size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2 + self.nodeBuffer * 7)
            self.uxTutorialTooltips!.append(tutorial)
            self.addChild(tutorial)
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
    
    func getLevelNodeHeight(_ buttonSize: CGFloat) -> CGFloat {
        return self.backdropBar.position.y - self.backdropBar.size.height / 2 - self.nodeBuffer * 2 - buttonSize / 2
    }
    
    func createLevelNodes(_ buttonSize: CGFloat) {
        var level: Int = 1
        var moreLevels: Bool = true
        
        while moreLevels {
            // Create the path to the level
            let filePath: String = "level_\(level)"
            if let path: String = Bundle.main().pathForResource(filePath, ofType: "plist") {
                // Read in the level
                let levelSetup: NSDictionary = NSDictionary(contentsOfFile: path)!
                
                let worldName = levelSetup.value(forKey: "World") as! String
                
                // Set the total levels for the gamedata
                // TODO introduce as function on GameData
                if let data: CharacterData = GameData.sharedGameData.archerCharacter {
                    data.totalLevels = 64 //level TODO SPIRIT set back to level
                    
                    // Setup the level data only if it doesnt exist already
                    if data.levelProgress[level] == nil {
                        data.initializeLevel(level, maxHearts: 100, maxDistance: 10000)
                    }
                }
                if let data: CharacterData = GameData.sharedGameData.monkCharacter {
                    data.totalLevels = 64 //level TODO SPIRIT set back to level
                    
                    // Setup the level data only if it doesnt exist already
                    if data.levelProgress[level] == nil {
                        data.initializeLevel(level, maxHearts: 100, maxDistance: 10000)
                    }
                }
                if let data: CharacterData = GameData.sharedGameData.mageCharacter {
                    data.totalLevels = 64 //level TODO SPIRIT set back to level
                    
                    // Setup the level data only if it doesnt exist already
                    if data.levelProgress[level] == nil {
                        data.initializeLevel(level, maxHearts: 100, maxDistance: 10000)
                    }
                }
                if let data: CharacterData = GameData.sharedGameData.warriorCharacter {
                    data.totalLevels = 64 //level TODO SPIRIT set back to level
                    
                    // Setup the level data only if it doesnt exist already
                    if data.levelProgress[level] == nil {
                        data.initializeLevel(level, maxHearts: 100, maxDistance: 10000)
                    }
                }
                
                /*
                // Setup the level data only if it doesnt exist already
                if GameData.sharedGameData.getSelectedCharacterData().levelProgress[level] == nil {
                    GameData.sharedGameData.getSelectedCharacterData().initializeLevel(level, maxHearts: 100, maxDistance: 10000)
                }*/
                
                // Update all of the challenges
                let challengeSet: [String : Bool] = self.updateChallenges(levelSetup, level: level)
                
                //GameData.sharedGameData.save()
                
                var worldForLevel: ScrollingLevelNodeRow?
                
                if worldName == "earth" {
                    worldForLevel = self.scrollingEarthLevels
                } else if worldName == "water" {
                    worldForLevel = self.scrollingWaterLevels
                } else if worldName == "fire" {
                    worldForLevel = self.scrollingFireLevels
                } else if worldName == "air" {
                    worldForLevel = self.scrollingAirLevels
                } else if worldName == "spirit" {
                    worldForLevel = self.scrollingSpiritLevels
                }
                
                worldForLevel!.numberOfLevels += 1
                
                let node: ScrollingLevelNode = ScrollingLevelNode(imageName: "button_level_selector", textureAtlas: GameTextures.sharedInstance.buttonAtlas, levelNumber: level, worldName: worldName, scene: self, challengeSet: challengeSet)
                
                worldForLevel!.addChild(node)
                
                let scale: CGFloat = 0.8
                node.setScale(scale)
                
                node.position = CGPoint(x: (worldForLevel!.buttonBuffer + node.levelSelectionBackground.size.width * scale) * CGFloat(worldForLevel!.numberOfLevels - 1), y: getLevelNodeHeight(buttonSize))
                
                // If this level node is the one that we last played, set it in focus
                if level == GameData.sharedGameData.getSelectedCharacterData().getLastPlayedLevelByWorld(worldName) {
                    worldForLevel!.levelSelectedNode = node
                }
                
                level += 1
            } else {
                moreLevels = false
            }
        }
    }
    
    func updateChallenges(_ levelSetup: NSDictionary, level: Int) -> [String : Bool] {
        // Read in challenges from plist
        var challengeSet: [String : Bool] = [String : Bool]()
        let challengeArray = levelSetup.value(forKey: "Challenges") as? Array<[String: AnyObject]>
        
        if challengeArray != nil {
            for challengeDictionary in challengeArray! {
                
                // Type information
                let challengeType = ChallengeType(rawValue: challengeDictionary["Type"] as! String)!
                
                // If the selected character hasnt completed the challenge for this level, add it to availableChgs
                let levelData: LevelData? = GameData.sharedGameData.getSelectedCharacterData().levelProgress[level]
                
                // Get the challenge info
                if levelData != nil {
                    if !levelData!.challengeCompletion.contains(challengeType.rawValue) {
                        // This is a challenge the user has not done. Add it to the list of available ones.
                        GameData.sharedGameData.getSelectedCharacterData().levelProgress[level]?.availableChallenges.add(challengeType.rawValue)
                        challengeSet[challengeType.rawValue] = false
                    } else {
                        challengeSet[challengeType.rawValue] = true
                    }
                }
            }
        }
        
        return challengeSet
    }
    
    func updateRewards() {
        // Star icon
        self.totalStarsIcon?.position = CGPoint(x: self.skillsButton!.position.x - self.skillsButton!.size.width/2 - self.totalStarsIcon!.size.width / 2 - nodeBuffer * 2, y: self.backdropBar.position.y)
        
        // Star label
        self.totalStars?.setText("\(GameData.sharedGameData.getSelectedCharacterData().totalStars)")
        self.totalStars?.position = CGPoint(x: self.totalStarsIcon!.position.x - self.totalStarsIcon!.size.width/2 - nodeBuffer/5, y: self.backdropBar.position.y)
        
        // Citrine icon
        self.totalCitrineIcon?.position = CGPoint(x: self.totalStars!.position.x - self.totalStars!.calculateAccumulatedFrame().width - nodeBuffer * 1 - self.totalCitrineIcon!.size.width/2, y: self.backdropBar.position.y)
        
        // Citrine label
        self.totalCitrine?.setText("\(GameData.sharedGameData.getSelectedCharacterData().totalCitrine)")
        self.totalCitrine?.position = CGPoint(x: self.totalCitrineIcon!.position.x - self.totalCitrineIcon!.size.width/2 - nodeBuffer/5, y: self.backdropBar.position.y)
        
        // Diamonds icon
        self.totalDiamondsIcon?.position = CGPoint(x: self.totalCitrine!.position.x - self.totalCitrine!.calculateAccumulatedFrame().width - nodeBuffer * 1 - self.totalDiamondsIcon!.size.width/2, y: self.backdropBar.position.y)
        
        // Diamonds label
        self.totalDiamonds?.setText("\(GameData.sharedGameData.totalDiamonds)")
        self.totalDiamonds?.position = CGPoint(x: self.totalDiamondsIcon!.position.x - self.totalDiamondsIcon!.size.width/2 - nodeBuffer/5, y: self.backdropBar.position.y)
    }
    
    func updateScene() {
        // Select the world
        let worldSelected = GameData.sharedGameData.getSelectedCharacterData().lastPlayedWorld
        
        if worldSelected == "earth" {
            self.selectWorld(self.earthWorld!)
        } else if worldSelected == "water" {
            self.selectWorld(self.waterWorld!)
        } else if worldSelected == "fire" {
            self.selectWorld(self.fireWorld!)
        } else if worldSelected == "air" {
            self.selectWorld(self.airWorld!)
        } else if worldSelected == "spirit" {
            self.selectWorld(self.spiritWorld!)
        }
        
        
        
        self.earthWorld!.updateLevelNode()
        self.waterWorld!.updateLevelNode()
        self.fireWorld!.updateLevelNode()
        self.airWorld!.updateLevelNode()
        self.spiritWorld!.updateLevelNode()

        // Update the level rewards (includes selected level)
        self.scrollingEarthLevels!.updateLevelRewards()
        self.scrollingWaterLevels!.updateLevelRewards()
        self.scrollingFireLevels!.updateLevelRewards()
        self.scrollingAirLevels!.updateLevelRewards()
        self.scrollingSpiritLevels!.updateLevelRewards()
        
        // Update rewards
        self.updateRewards()
        
        /*
        // Update heart boost
        if HeartBoostCosts.getCostOfBoost(GameData.sharedGameData.getSelectedCharacterData().lastHeartBoost) <= GameData.sharedGameData.totalDiamonds {
            self.heartBoostContainer?.selectHeartByBoost(GameData.sharedGameData.getSelectedCharacterData().lastHeartBoost)
        } else {
            self.heartBoostContainer?.selectHeartByBoost(0)
        }*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.sceneView = view
        
        self.selectedWorld!.relatedLevelSelector!.enableScrollingOnView(view)
        
        if self.justInitialized {
            self.selectedWorld!.relatedLevelSelector!.scrollToLeft()
            self.justInitialized = false
        }
        
        // Check for some achievements
        GameKitHelper.sharedInstance.checkCharacterAchievements()
        self.viewController!.syncAchievements()
        
        self.displayTutorialTooltip()
        
        super.didMove(to: view)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        // TODO may need to have all the worlds on here
        self.selectedWorld!.relatedLevelSelector!.disableScrollingOnView(self.sceneView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Level slider
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        
        // Get the current level selected // TODO
        // Translate the world location to the scrolling node location
        let translatedTouchLocation: CGPoint = self.convert(location, to: self.selectedWorld!.relatedLevelSelector!.levelSelectedNode!)
        
        // Find the closest child
        if self.selectedWorld!.relatedLevelSelector!.levelSelectedNode!.levelSelectionBackground.contains(translatedTouchLocation) && !self.selectedWorld!.relatedLevelSelector!.levelSelectedNode!.levelLocked {
            // Remove actions
            self.selectedWorld!.relatedLevelSelector!.removeAllActions()
            
            // We touched a level so let's load it
            self.viewController!.presentGameSceneLevel(self.selectedWorld!.relatedLevelSelector!.levelSelected, justRestarted: false)
            
            self.viewController!.playButtonSound()
        } else {
            // Loop through children. If one is touched, go there
            // Find the closest child
            scrollNodeLoop: for node in self.selectedWorld!.relatedLevelSelector!.children as! [ScrollingLevelNode]{
                //NSLog("node # %d", node.levelNumber)
                
                let nodeTranslatedTouchLocation: CGPoint = self.convert(location, to: node)
                
                // If we touched a node, move to it
                if node.levelSelectionBackground.contains(nodeTranslatedTouchLocation) {
                    self.selectedWorld!.relatedLevelSelector!.moveToNode(node)
                    
                    SoundHelper.sharedInstance.playSound(self, sound: SoundType.Click)
                    
                    break scrollNodeLoop
                }
            }
        }
    }
    
    func selectWorld(_ selectedWorld: WorldNode) {
        // Set the correct display for the world nodes
        self.earthWorld!.selected = false
        self.waterWorld!.selected = false
        self.fireWorld!.selected = false
        self.airWorld!.selected = false
        self.spiritWorld!.selected = false
        
        // Stop gesture recognizers
        self.earthWorld!.relatedLevelSelector!.disableScrollingOnView(self.sceneView)
        self.waterWorld!.relatedLevelSelector!.disableScrollingOnView(self.sceneView)
        self.fireWorld!.relatedLevelSelector!.disableScrollingOnView(self.sceneView)
        self.airWorld!.relatedLevelSelector!.disableScrollingOnView(self.sceneView)
        self.spiritWorld!.relatedLevelSelector!.disableScrollingOnView(self.sceneView)
        
        selectedWorld.selected = true
        self.selectedWorld = selectedWorld
        self.selectedWorld!.relatedLevelSelector!.enableScrollingOnView(self.sceneView)
    }
    
    override func updateGemCounts() {
        self.totalDiamonds?.setText("\(GameData.sharedGameData.totalDiamonds)")
        
        super.updateGemCounts()
    }
    
    func moveToSelectedNode() {
        // Move to the selected node
        self.scrollingEarthLevels!.moveToNode(self.scrollingEarthLevels!.levelSelectedNode!)
        self.scrollingWaterLevels!.moveToNode(self.scrollingWaterLevels!.levelSelectedNode!)
        self.scrollingFireLevels!.moveToNode(self.scrollingFireLevels!.levelSelectedNode!)
        self.scrollingAirLevels!.moveToNode(self.scrollingAirLevels!.levelSelectedNode!)
        self.scrollingSpiritLevels!.moveToNode(self.scrollingSpiritLevels!.levelSelectedNode!)
    }
}
