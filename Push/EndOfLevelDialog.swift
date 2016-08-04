//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class EndOfLevelDialog: DialogBackground {
    // Buttons
    var menuButton: GameMenuButton
    var retryLevelButton: GameRetryLevelButton
    var nextLevelButton: GameNextLevelButton
    var page1ContinueButton: GameEndContinueButton
    var page2ContinueButton: GameEndContinueButton
    
    // Containers
    var challengeContainer: ChallengeContainer
    var challengeContainerPlaceholder: SKSpriteNode?
    
    // Rewards
    var starButton1: StarButton
    var starButton2: StarButton
    var starButton3: StarButton
    var superstarButton1: SuperstarButton
    
    // Labels
    var totalScoreLabel: SKLabelNode
    var endedLabel: SKLabelNode
    
    // Chllenges
    var challengeTitle: SKLabelNode
    var challengeRewardTitle: SKLabelNode
    var challengeRewardNumber: LabelWithShadow
    var challengeRewardIcon: SKSpriteNode
    var gemsEarned: Int = 0
    
    // Skills
    var upgradeSkillsButton: DBSceneSkillsButton
    var levelHintDescription: DSMultilineLabelNode
    
    var currentLevel: Int
    
    var stars = Array<SKSpriteNode>()
    
    // Pages
    var page1: SKNode = SKNode()
    var page2: SKNode = SKNode()
    var currentPage = 1
    var pageWidth: CGFloat = 0
    var pageHeight: CGFloat = 0
    
    // We dont show this unless it has a score
    var hasValidScore: Bool = false
    
    // Scores
    var scoredAtLeast3: Bool = false
    
    // Speed
    var endSpeed: Double = 0.25
    
    // Tutorials
    var uxTutorialTooltips: Array<UXTutorialDialog>? = Array<UXTutorialDialog>()
    
    // Tutorial callback (default)
    var onCompleteUxTooltip: () -> Void = {}
    
    weak var dbScene: DBScene?
    
    init(frameSize : CGSize, scene: GameScene, currentLevel: Int, completedChallenges: Array<LevelChallenge>) {
        // Inits
        let buttonBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
        self.currentLevel = currentLevel
        self.dbScene = scene
        
        self.menuButton = GameMenuButton(scene: scene)
        self.retryLevelButton = GameRetryLevelButton(scene: scene)
        self.nextLevelButton = GameNextLevelButton(scene: scene, level: currentLevel + 1)
        self.page1ContinueButton = GameEndContinueButton(scene: scene)
        self.page2ContinueButton = GameEndContinueButton(scene: scene)
        self.upgradeSkillsButton = DBSceneSkillsButton(scene: scene, sceneType: DBSceneType.gameScene, size: DBButtonSize.small)
        
        // Scores
        totalScoreLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        
        // Titles
        endedLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        challengeTitle = SKLabelNode(fontNamed: "Avenir-Medium")
        
        // Challenges
        self.challengeRewardNumber = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: true, borderSize: 0.80 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.challengeRewardTitle = SKLabelNode(fontNamed: "Avenir-Heavy")
        self.challengeRewardIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem"))
        self.challengeRewardIcon.setScale(0.75)
        
        // Rewards
        self.starButton1 = StarButton(scene: scene)
        self.starButton2 = StarButton(scene: scene)
        self.starButton3 = StarButton(scene: scene)
        self.superstarButton1 = SuperstarButton(scene: scene)
        
        // Skills
        self.levelHintDescription = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        
        // Challenges
        self.challengeContainer = ChallengeContainer(scene: scene, challenges: completedChallenges)
        
        super.init(frameSize: frameSize)
        
        self.onCompleteUxTooltip = {[weak self] in self!.displayTutorialTooltip()}
        
        // Challenges
        if self.showChallenges() {
            self.challengeTitle.text = "Challenge Completion"
        } else {
            self.challengeContainerPlaceholder = SKSpriteNode(texture: SKTexture(imageNamed: "splash-warrior"))
            self.challengeTitle.text = "Select Your Move"
        }
        
        // Now stars
        // Add the stars. Loop through each attribute to build the final set
        stars.append(self.starButton1)
        stars.append(self.starButton2)
        stars.append(self.starButton3)
        stars.append(self.superstarButton1)

        let sampleSize = starButton1.size
        
        // Score Labels
        self.totalScoreLabel.text = "0%"
        self.totalScoreLabel.fontSize = round(42 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.totalScoreLabel.fontColor = MerpColors.darkFont
        self.totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.totalScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        // Title labels
        self.endedLabel.text = "Level \(currentLevel) Score"
        self.endedLabel.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.endedLabel.fontColor = MerpColors.darkFont
        self.endedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.endedLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        // Title above
        self.challengeTitle.fontSize = round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.challengeTitle.fontColor = MerpColors.darkFont
        self.challengeTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.challengeTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        // Challenge labels
        self.challengeRewardTitle.text = "Gems earned: "
        self.challengeRewardTitle.fontSize = round(18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.challengeRewardTitle.fontColor = MerpColors.darkFont
        self.challengeRewardTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.challengeRewardTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.challengeRewardNumber.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.challengeRewardNumber.setFontSize(round(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
        self.challengeRewardNumber.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.challengeRewardNumber.setText("\(self.gemsEarned)")
        
        // Page 3
        self.levelHintDescription.fontSize = round(16 * ScaleBuddy.sharedInstance.getGameScaleAmount(true))
        self.levelHintDescription.fontColor = MerpColors.darkFont
        
        // Page 1
        self.page1.addChild(self.endedLabel)
        //self.page1.addChild(self.distanceLabel)
        //self.page1.addChild(self.enemyLabel)
        //self.page1.addChild(self.totalLabel)
        //self.page1.addChild(self.distanceScoreLabel)
        //self.page1.addChild(self.enemyScoreLabel)
        self.page1.addChild(self.totalScoreLabel)
        for node in stars {
            self.page1.addChild(node)
        }
        self.page1.addChild(self.page1ContinueButton)
        
        self.page1.addChild(self.upgradeSkillsButton)
        self.page1.addChild(self.levelHintDescription)
        
        self.container.addChild(self.page1)
        
        // Page 2
        self.page2.addChild(self.challengeTitle)
        self.page2.addChild(self.challengeContainer)
        self.page2.addChild(self.challengeRewardTitle)
        self.page2.addChild(self.challengeRewardNumber)
        self.page2.addChild(self.challengeRewardIcon)
        if self.challengeContainerPlaceholder != nil {
            self.page2.addChild(self.challengeContainerPlaceholder!)
        }
        //self.page2.addChild(self.page2ContinueButton)
        self.page2.addChild(self.menuButton)
        self.page2.addChild(self.retryLevelButton)
        self.page2.addChild(self.nextLevelButton)
        self.container.addChild(self.page2)
        
        // Get the page width first
        self.pageWidth = max(self.challengeContainer.trueWidth, self.nextLevelButton.size.width + self.menuButton.size.width + self.retryLevelButton.size.width + buttonBuffer * 2)
        
        // Now create stuff dependent on the page width
        self.levelHintDescription.paragraphWidth = self.pageWidth
        self.levelHintDescription.text = "Tip: upgrade your skills below."
        
        // Get the page height
        let page1TotalHeight: CGFloat = self.endedLabel.calculateAccumulatedFrame().size.height + self.totalScoreLabel.calculateAccumulatedFrame().size.height + self.levelHintDescription.calculateAccumulatedFrame().size.height + self.page1ContinueButton.size.height + self.starButton1.size.height + self.buttonBuffer * 6
        let page2TotalHeight: CGFloat = self.challengeTitle.calculateAccumulatedFrame().size.height + self.challengeContainer.calculateAccumulatedFrame().size.height + self.challengeRewardNumber.calculateAccumulatedFrame().size.height + self.page2ContinueButton.size.height + self.buttonBuffer * 3
        
        self.pageHeight = max(page1TotalHeight, page2TotalHeight)
        
        // Page 1 positioning
        self.endedLabel.position = CGPoint(/*pageWidth / -2 + self.endedLabel.calculateAccumulatedFrame().size.width / 2*/x: 0, y: pageHeight / 2 - endedLabel.calculateAccumulatedFrame().size.height / 2)
        self.updateScorePositioning()
        
        // star array
        var count: Int = 0
        for node in stars {
            let nodeXPosition = (sampleSize.width * 1.2) * (CGFloat(count) - 1) + ((CGFloat(count) - 1)) - (sampleSize.width/2) - 2
            let nodeYPosition = self.totalScoreLabel.position.y - (self.totalScoreLabel.calculateAccumulatedFrame().size.height / 2) - buttonBuffer - (self.starButton1.size.height / 2)
            node.position = CGPoint(x: nodeXPosition, y: nodeYPosition)
            
            count += 1
        }
        self.page1ContinueButton.position = CGPoint(x: page1ContinueButton.size.width + buttonBuffer, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        self.upgradeSkillsButton.position = CGPoint(x: 0.0, y: self.page1ContinueButton.position.y)
        
        // Page 2 positions
        self.challengeTitle.position = CGPoint(/*pageWidth / -2 + self.challengeTitle.calculateAccumulatedFrame().size.width / 2*/x: 0, y: pageHeight / 2 - challengeTitle.calculateAccumulatedFrame().size.height / 2)
        self.challengeContainer.position = CGPoint(x: 0, y: self.challengeTitle.position.y - self.challengeTitle.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - challengeContainer.calculateAccumulatedFrame().size.height / 2)
        self.updateChallengeRewardPositions()
        
        self.menuButton.position = CGPoint(x: -menuButton.size.width - buttonBuffer, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        self.retryLevelButton.position = CGPoint(x: 0.0, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        self.nextLevelButton.position = CGPoint(x: nextLevelButton.size.width + buttonBuffer, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        
        if self.challengeContainerPlaceholder != nil {
            // Reset the size
            self.challengeContainerPlaceholder!.setScale((self.challengeContainer.calculateAccumulatedFrame().size.height + self.challengeRewardNumber.calculateAccumulatedFrame().size.height) / (self.challengeContainerPlaceholder!.size.height + self.buttonBuffer))
            
            // Positioning
            self.challengeContainerPlaceholder!.position = CGPoint(x: 0, y: self.challengeTitle.position.y - self.challengeTitle.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - self.challengeContainerPlaceholder!.calculateAccumulatedFrame().size.height / 2)
        }
        
        // Set alpha to 0 so it fades in
        self.alpha = 0.0
        
        // Hide it all page 1
        self.page1.isHidden = true
        self.container.isHidden = true
        self.containerBackground.isHidden = true
        self.endedLabel.isHidden = true
        //self.distanceLabel.hidden = true
        //self.enemyLabel.hidden = true
        //self.totalLabel.hidden = true
        //self.distanceScoreLabel.hidden = true
        //self.enemyScoreLabel.hidden = true
        self.totalScoreLabel.isHidden = true
        for node in stars {
            node.isHidden = true
        }
        self.page1ContinueButton.isHidden = true
        
        // Page 2 hides
        self.page2.isHidden = true
        self.challengeContainer.isHidden = true
        self.challengeTitle.isHidden = true
        self.challengeRewardTitle.isHidden = true
        self.challengeRewardNumber.isHidden = true
        self.challengeRewardIcon.isHidden = true
        if self.challengeContainerPlaceholder != nil {
            self.challengeContainerPlaceholder!.isHidden = true
        }
        //self.page2ContinueButton.hidden = true
        self.retryLevelButton.isHidden = true
        self.nextLevelButton.isHidden = true
        self.upgradeSkillsButton.isHidden = true
        self.levelHintDescription.isHidden = true
        self.menuButton.isHidden = true
        
        // Reset size of container
        self.resetContainerSize()
        
        // UX Tutorial
        self.createUxTutorials(currentLevel)
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showChallenges() -> Bool {
        return GameData.sharedGameData.getSelectedCharacterData().challengesUnlocked(self.currentLevel)
    }
    
    func createUxTutorials(_ currentLevel: Int) {
        var tutorialAck: Double?
        var tutorialKey: String
        var tutorialVersion: Double
        
        // Reset Skills
        tutorialKey = "UXTutorialEarnScore"
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        if (tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion)) || GameData.sharedGameData.getSelectedCharacterData().godMode {
            let tutorial = UXTutorialDialog(frameSize: self.size, description: "Score = distance traveled + minion hearts collected.", scene: self.dbScene!, size: "Medium", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip)
            tutorial.position = CGPoint(x: 0, y: self.totalScoreLabel.position.y - self.totalScoreLabel.calculateAccumulatedFrame().size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer)
            self.uxTutorialTooltips!.append(tutorial)
            self.page1.addChild(tutorial)
        }
        
        // Reset Skills
        tutorialKey = "UXTutorialEarnStars"
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        if (tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion)) || GameData.sharedGameData.getSelectedCharacterData().godMode {
            let tutorial = UXTutorialDialog(frameSize: self.size, description: "Earn stars and superstars by getting a better score.", scene: self.dbScene!, size: "Medium", indicators: [UxTutorialIndicatorPosition.topCenter], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip)
            tutorial.position = CGPoint(x: 0, y: self.starButton2.position.y - self.starButton2.size.height / 2 - tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2 - self.buttonBuffer)
            self.uxTutorialTooltips!.append(tutorial)
            self.page1.addChild(tutorial)
        }
        
        // Reset Skills
        tutorialKey = "UXTutorialSkillsReset"
        tutorialVersion = 1.0
        tutorialAck = GameData.sharedGameData.tutorialsAcknowledged[tutorialKey]
        
        // We don't want to show this until the character has 2 skills total
        if (currentLevel >= 5 && !GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.contains(CharacterUpgrade.TeleCharge.rawValue) && !GameData.sharedGameData.getSelectedCharacterData().unlockedUpgrades.contains(CharacterUpgrade.RubberSneakers.rawValue) && (tutorialAck == nil || floor(tutorialAck!) != floor(tutorialVersion))) || GameData.sharedGameData.getSelectedCharacterData().godMode {
            let tutorial = UXTutorialDialog(frameSize: self.size, description: "Having trouble? go upgrade your jump skill below.", scene: self.dbScene!, size: "Medium", indicators: [UxTutorialIndicatorPosition.bottomCenter], key: tutorialKey, version: tutorialVersion, onComplete: onCompleteUxTooltip)
            tutorial.position = CGPoint(x: self.upgradeSkillsButton.position.x, y: self.upgradeSkillsButton.position.y + self.upgradeSkillsButton.size.height / 2 + tutorial.containerBackground.calculateAccumulatedFrame().size.height / 2)
            self.uxTutorialTooltips!.append(tutorial)
            self.page1.addChild(tutorial)
        }
    }
    
    func displayTutorialTooltip() -> Void {
        // If the UX tut array has objects, pop one, display it.
        if (self.uxTutorialTooltips!.count > 0) {
            let tooltip = self.uxTutorialTooltips!.first
            self.uxTutorialTooltips!.remove(at: 0)
            tooltip!.zPosition = 14.0
  
            tooltip!.isHidden = false
        }
    }
    
    func updateRewards(_ score: LevelScore) {
        // Do new stars
        if score.starsRewarded > 0 {
            self.starButton1.pressButton()
        }
        if score.starsRewarded > 1 {
            self.starButton2.pressButton()
        }
        if score.starsRewarded > 2 {
            self.starButton3.pressButton()
            self.scoredAtLeast3 = true
        }
        if score.citrineRewarded > 0 {
            self.superstarButton1.pressButton()
        }
    }
    
    func applyScore(_ score: LevelScore, completedChallenges: Array<LevelChallenge>, unlockedLevels: Array<Int>) {
        // Update score text
        totalScoreLabel.text = "\(Int(floor(score.totalCompletePercent*100)))%"
        
        // Update tip
        if unlockedLevels.count == 0 {
            if score.starsRewarded <= 2 {
                switch score.levelNumber {
                case 5, 6:
                    levelHintDescription.text = "Tip: goblin troubles? Make sure you upgrade your jump skill."
                case 10, 11:
                    levelHintDescription.text = "Tip: ogre troubles? Upgrade your jump skill again."
                case 17, 18:
                    levelHintDescription.text = "Tip: pirate crab troubles? Purchase skills that can damage him."
                default:
                    levelHintDescription.text = ""
                }
                
                if levelHintDescription.text == "" || Int(arc4random_uniform(10)) > 6 {
                    let tipNum = Int(arc4random_uniform(3))
                    switch tipNum {
                    case 0:
                        levelHintDescription.text = "Tip: reset your skills and try new strategies."
                    case 1:
                        levelHintDescription.text = "Tip: you don't need 3 stars on every level."
                    case 2:
                        levelHintDescription.text = "Tip: replay earlier levels to get more stars for new skills."
                    default:
                        levelHintDescription.text = "Tip: reset your skills and try new strategies."
                    }
                }
            } else if score.starsRewarded == 3 && score.citrineRewarded == 0 {
                let tipNum = Int(arc4random_uniform(3))
                switch tipNum {
                case 0:
                    levelHintDescription.text = "Rock on!"
                case 1:
                    levelHintDescription.text = "Wow, you are so good!"
                case 2:
                    levelHintDescription.text = "Way to go!"
                default:
                    levelHintDescription.text = "Rock on!"
                }
            } else if score.starsRewarded == 3 && score.citrineRewarded == 1 {
                let tipNum = Int(arc4random_uniform(3))
                switch tipNum {
                case 0:
                    levelHintDescription.text = "This is just fantastic!"
                case 1:
                    levelHintDescription.text = "Super duper!"
                case 2:
                    levelHintDescription.text = "I'm impressed!"
                default:
                    levelHintDescription.text = "This is just fantastic!"
                }
            }
            
        } else if unlockedLevels.count == 1 {
            levelHintDescription.fontSize += round(8 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            levelHintDescription.text = "Level \(unlockedLevels[0]) unlocked!"
        } else if unlockedLevels.count == 2 {
            levelHintDescription.fontSize += round(8 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            levelHintDescription.text = "Levels \(unlockedLevels[0]) & \(unlockedLevels[1]) unlocked!"
        }
        
        self.updateScorePositioning()
        
        // Update rewards
        self.updateRewards(score)
        
        // Check if the next level is locked. If not, disable the button
        if GameData.sharedGameData.getSelectedCharacterData().isLevelLocked(self.currentLevel + 1) {
            nextLevelButton.isDisabled = true
            nextLevelButton.checkDisabled()
        }
        
        // Update challenges
        for completedChallenge in completedChallenges {
            // Look through list of challenges and switch it to completed
            for levelChallenge in self.challengeContainer.challengeDisplays {
                if levelChallenge.challenge.challengeType == completedChallenge.challengeType {
                    // Highlight it / Complete it 
                    levelChallenge.highlightChallenge()
                    
                    // Add this to the gemsEarned
                    self.gemsEarned += completedChallenge.reward
                }
            }
        }
        
        // Update reward display
        self.challengeRewardNumber.setText("\(self.gemsEarned)")
        self.updateChallengeRewardPositions()

        // Mark that we have a score now
        self.hasValidScore = true
    }
    
    func displayEndOfLevelDialog() {
        if self.hasValidScore {
            self.isHidden = false
            
            // Start the new action
            self.run(SKAction.sequence([
                SKAction.fadeIn(withDuration: 1.5),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.container.isHidden = false
                    self.containerBackground.isHidden = false
                    self.endedLabel.isHidden = false
                    
                    self.page1.isHidden = false
                    self.page2.isHidden = true
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.totalScoreLabel.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    for node in self.stars {
                        node.isHidden = false
                    }
                    
                    if self.scoredAtLeast3 {
                        SoundHelper.sharedInstance.playSound(self, sound: SoundType.Celebrate)
                    }
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.levelHintDescription.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.upgradeSkillsButton.isHidden = false
                    self.displayTutorialTooltip()
                    self.page1ContinueButton.isHidden = false
                }),
                SKAction.run({
                    // Save Data
                    self.dbScene!.viewController!.saveData()
                })
                ]),withKey: "playerWinning")
        }
    }
    
    func showNextPage() {
        if self.currentPage == 1 {
            self.displayPage2()
            self.currentPage += 1
        }
    }
    
    func displayPage2() {
        if self.challengeContainerPlaceholder == nil {
            // Start the new action
            self.run(SKAction.sequence([
                SKAction.run({
                    self.page1.isHidden = true
                    self.page2.isHidden = false
                    self.challengeTitle.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.challengeContainer.isHidden = false
                        
                    if self.challengeContainer.justUnlockedChallenge() {
                        SoundHelper.sharedInstance.playSound(self, sound: SoundType.Celebrate)
                    }
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.challengeRewardIcon.isHidden = false
                    self.challengeRewardNumber.isHidden = false
                    self.challengeRewardTitle.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.menuButton.isHidden = false
                    self.retryLevelButton.isHidden = false
                    self.nextLevelButton.isHidden = false
                })
                ]),withKey: "playerWinning")
        }
        else {
            // Start the new action
            self.run(SKAction.sequence([
                SKAction.run({
                    self.page1.isHidden = true
                    self.page2.isHidden = false
                    self.challengeTitle.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.challengeContainerPlaceholder!.isHidden = false

                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.menuButton.isHidden = false
                    self.retryLevelButton.isHidden = false
                    self.nextLevelButton.isHidden = false
                })
                ]),withKey: "playerWinning")
        }
    }
    
    func updateScorePositioning() {
        //self.distanceLabel.position = CGPointMake(pageWidth / -2 + self.distanceLabel.calculateAccumulatedFrame().size.width / 2, self.endedLabel.position.y - self.endedLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 2 - distanceLabel.calculateAccumulatedFrame().size.height / 2)
        //self.enemyLabel.position = CGPointMake(pageWidth / -2 + self.enemyLabel.calculateAccumulatedFrame().size.width / 2, self.distanceLabel.position.y - self.distanceLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - enemyLabel.calculateAccumulatedFrame().size.height / 2)
        //self.totalLabel.position = CGPointMake(pageWidth / -2 + self.totalLabel.calculateAccumulatedFrame().size.width / 2, self.enemyLabel.position.y - self.enemyLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - totalLabel.calculateAccumulatedFrame().size.height / 2)
        
        //self.distanceScoreLabel.position = CGPointMake(pageWidth/2 - self.distanceScoreLabel.calculateAccumulatedFrame().size.width / 2, self.endedLabel.position.y - self.endedLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 2 - distanceLabel.calculateAccumulatedFrame().size.height / 2)
        //self.enemyScoreLabel.position = CGPointMake(pageWidth/2 - self.enemyScoreLabel.calculateAccumulatedFrame().size.width / 2, self.distanceLabel.position.y - self.distanceLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - enemyLabel.calculateAccumulatedFrame().size.height / 2)
        self.totalScoreLabel.position = CGPoint(x: 0, y: self.endedLabel.position.y - self.endedLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 2 - totalScoreLabel.calculateAccumulatedFrame().size.height / 2)
        
        self.levelHintDescription.position = CGPoint(/*0 - pageWidth/2 + self.levelHintDescription.calculateAccumulatedFrame().size.width / 2*/x: 0, y: self.starButton1.position.y - self.starButton1.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 2 - levelHintDescription.calculateAccumulatedFrame().size.height / 2)
    }
    
    func updateChallengeRewardPositions() {
        self.challengeRewardIcon.position = CGPoint(x: pageWidth / 2 - self.challengeRewardIcon.size.width / 2, y: 0)
        self.challengeRewardNumber.position = CGPoint(x: self.challengeRewardIcon.position.x - (self.challengeRewardIcon.size.width / 2) - self.challengeRewardNumber.calculateAccumulatedFrame().size.width / 2, y: self.challengeContainer.position.y - self.challengeContainer.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 0.25 - challengeRewardNumber.calculateAccumulatedFrame().size.height / 2)
        self.challengeRewardIcon.position = CGPoint(x: self.challengeRewardIcon.position.x, y: self.challengeRewardNumber.position.y)
        self.challengeRewardTitle.position = CGPoint(x: self.challengeRewardNumber.position.x - self.challengeRewardNumber.calculateAccumulatedFrame().size.width / 2 - buttonBuffer - self.challengeRewardTitle.calculateAccumulatedFrame().size.width / 2, y: self.challengeRewardNumber.position.y - buttonBuffer * 0.3)
    }
}
