//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class EndOfLevelScoreDialog: DialogBackground {
    // Buttons
    var menuButton: GameMenuButton
    var retryLevelButton: GameRetryLevelButton
    var nextLevelButton: GameNextLevelButton
    var page1ContinueButton: GameEndContinueButton
    var page2ContinueButton: GameEndContinueButton
    var page3ContinueButton: GameEndContinueButton
    
    // Containers
    var heartBoostContainer: HeartBoostContainer
    var challengeContainer: ChallengeContainer
    
    // Rewards
    var starButton1: StarButton
    var starButton2: StarButton
    var starButton3: StarButton
    var superstarButton1: SuperstarButton
    
    // Labels
    var totalLabel: SKLabelNode
    var enemyLabel: SKLabelNode
    var distanceLabel: SKLabelNode
    var totalScoreLabel: SKLabelNode
    var enemyScoreLabel: SKLabelNode
    var distanceScoreLabel: SKLabelNode
    var endedLabel: SKLabelNode
    var whatNextLabel: SKLabelNode
    
    // Chllenges
    var challengeTitle: SKLabelNode
    var challengeRewardTitle: SKLabelNode
    var challengeRewardNumber: LabelWithShadow
    var challengeRewardIcon: SKSpriteNode
    var gemsEarned: Int = 0
    
    // Gems
    var gemsTitle: SKLabelNode
    var gemsNumber: LabelWithShadow
    var gemsIcon: SKSpriteNode
    
    // Skills
    var upgradeSkillsTitle: SKLabelNode
    var upgradeSkillsDescription: DSMultilineLabelNode
    var upgradeSkillsButton: DBSceneSkillsButton
    var levelHintDescription: DSMultilineLabelNode
    
    var currentLevel: Int
    
    var stars = Array<SKSpriteNode>()
    
    // Pages
    var page1: SKNode = SKNode()
    var page2: SKNode = SKNode()
    var page3: SKNode = SKNode()
    var page4: SKNode = SKNode()
    var currentPage = 1
    var pageWidth: CGFloat = 0
    var pageHeight: CGFloat = 0
    
    // We dont show this unless it has a score
    var hasValidScore: Bool = false
    
    // Scores
    var scoredAtLeast3: Bool = false
    
    // Speed
    var endSpeed: Double = 0.25
    
    init(frameSize : CGSize, scene: GameScene, heartCost: Int, heartBoost: Int, currentLevel: Int, completedChallenges: Array<LevelChallenge>) {
        // Inits
        let buttonBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
        self.currentLevel = currentLevel
        
        self.menuButton = GameMenuButton(scene: scene)
        self.retryLevelButton = GameRetryLevelButton(scene: scene)
        self.nextLevelButton = GameNextLevelButton(scene: scene, level: currentLevel + 1)
        self.page1ContinueButton = GameEndContinueButton(scene: scene)
        self.page2ContinueButton = GameEndContinueButton(scene: scene)
        self.page3ContinueButton = GameEndContinueButton(scene: scene)
        self.upgradeSkillsButton = DBSceneSkillsButton(scene: scene, sceneType: DBSceneType.gameScene, size: DBButtonSize.small)
        
        // Scores
        totalLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        enemyLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        distanceLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        totalScoreLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        enemyScoreLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        distanceScoreLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        
        // Titles
        endedLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        whatNextLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        challengeTitle = SKLabelNode(fontNamed: "Avenir-Medium")
        upgradeSkillsTitle = SKLabelNode(fontNamed: "Avenir-Medium")
        
        // Challenges
        self.challengeRewardNumber = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: true, borderSize: 0.80 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.challengeRewardTitle = SKLabelNode(fontNamed: "Avenir-Heavy")
        self.challengeRewardIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem"))
        self.challengeRewardIcon.setScale(0.75)
        
        // Gem Display
        self.gemsNumber = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: true, borderSize: 0.80 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.gemsTitle = SKLabelNode(fontNamed: "Avenir-Heavy")
        self.gemsIcon = SKSpriteNode(texture: GameTextures.sharedInstance.uxAtlas.textureNamed("gem"))
        self.gemsIcon.setScale(0.75)
        
        // Update heart boost
        var nextBoost: Int = 0
        if heartCost <= GameData.sharedGameData.totalDiamonds {
            nextBoost = heartBoost
        } else {
            nextBoost = 0
        }
        self.heartBoostContainer = HeartBoostContainer(scene: scene, selectedLevel: nextBoost)
        
        // Rewards
        self.starButton1 = StarButton(scene: scene)
        self.starButton2 = StarButton(scene: scene)
        self.starButton3 = StarButton(scene: scene)
        self.superstarButton1 = SuperstarButton(scene: scene)
        
        // Challenges
        self.challengeContainer = ChallengeContainer(scene: scene, challenges: completedChallenges)
        
        // Skills
        self.upgradeSkillsDescription = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        self.levelHintDescription = DSMultilineLabelNode(fontName: "Avenir-Medium", scene: scene)
        
        super.init(frameSize: frameSize)
        
        // Now stars
        // Add the stars. Loop through each attribute to build the final set
        stars.append(self.starButton1)
        stars.append(self.starButton2)
        stars.append(self.starButton3)
        stars.append(self.superstarButton1)

        let sampleSize = starButton1.size
        
        // Score Labels
        self.totalLabel.text = "total level completed:"
        self.totalLabel.fontSize = 20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.totalLabel.fontColor = MerpColors.darkFont
        self.totalLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.totalLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.enemyLabel.text = "minions defeated: 0 of 0"
        self.enemyLabel.fontSize = 18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.enemyLabel.fontColor = MerpColors.darkFont
        self.enemyLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.enemyLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.distanceLabel.text = "distance traveled: 0 of 0"
        self.distanceLabel.fontSize = 18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.distanceLabel.fontColor = MerpColors.darkFont
        self.distanceLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.distanceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.totalScoreLabel.text = "...0%"
        self.totalScoreLabel.fontSize = 20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.totalScoreLabel.fontColor = MerpColors.darkFont
        self.totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.totalScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.enemyScoreLabel.text = "...0%"
        self.enemyScoreLabel.fontSize = 18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.enemyScoreLabel.fontColor = MerpColors.darkFont
        self.enemyScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.enemyScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.distanceScoreLabel.text = "...0%"
        self.distanceScoreLabel.fontSize = 18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.distanceScoreLabel.fontColor = MerpColors.darkFont
        self.distanceScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.distanceScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        // Title labels
        self.endedLabel.text = "level ended"
        self.endedLabel.fontSize = 28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.endedLabel.fontColor = MerpColors.darkFont
        self.endedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.endedLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.challengeTitle.text = "challenge completion"
        self.challengeTitle.fontSize = 28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.challengeTitle.fontColor = MerpColors.darkFont
        self.challengeTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.challengeTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.upgradeSkillsTitle.text = "upgrade your skills"
        self.upgradeSkillsTitle.fontSize = 28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.upgradeSkillsTitle.fontColor = MerpColors.darkFont
        self.upgradeSkillsTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.upgradeSkillsTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.whatNextLabel.text = "make your move"
        self.whatNextLabel.fontSize = 28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.whatNextLabel.fontColor = MerpColors.darkFont
        self.whatNextLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.whatNextLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        // Challenge labels
        self.challengeRewardTitle.text = "gems earned: "
        self.challengeRewardTitle.fontSize = 18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.challengeRewardTitle.fontColor = MerpColors.darkFont
        self.challengeRewardTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.challengeRewardTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.challengeRewardNumber.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.challengeRewardNumber.setFontSize(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.challengeRewardNumber.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.challengeRewardNumber.setText("\(self.gemsEarned)")
        
        // Gems labels
        self.gemsTitle.text = "total: "
        self.gemsTitle.fontSize = 24 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.gemsTitle.fontColor = MerpColors.darkFont
        self.gemsTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.gemsTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        self.gemsNumber.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
        self.gemsNumber.setFontSize(28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        self.gemsNumber.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
        self.gemsNumber.setText("\(GameData.sharedGameData.totalDiamonds)")
        
        // Page 3
        if ScaleBuddy.sharedInstance.getScaleAmount() < 1 {
            self.upgradeSkillsDescription.fontSize = 15 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            self.levelHintDescription.fontSize = 16 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        } else {
            self.upgradeSkillsDescription.fontSize = 14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
            self.levelHintDescription.fontSize = 14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        }
        self.upgradeSkillsDescription.fontColor = MerpColors.darkFont
        self.levelHintDescription.fontColor = MerpColors.darkFont
        
        // Page 1
        self.page1.addChild(self.endedLabel)
        self.page1.addChild(self.distanceLabel)
        self.page1.addChild(self.enemyLabel)
        self.page1.addChild(self.totalLabel)
        self.page1.addChild(self.distanceScoreLabel)
        self.page1.addChild(self.enemyScoreLabel)
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
        self.page2.addChild(self.page2ContinueButton)
        self.container.addChild(self.page2)
        
        // Page 4
        self.page4.addChild(self.whatNextLabel)
        self.page4.addChild(self.gemsTitle)
        self.page4.addChild(self.gemsNumber)
        self.page4.addChild(self.gemsIcon)
        self.page4.addChild(self.heartBoostContainer)
        self.page4.addChild(self.menuButton)
        self.page4.addChild(self.retryLevelButton)
        self.page4.addChild(self.nextLevelButton)
        self.container.addChild(self.page4)
        
        
        // Get the page width first
        self.pageWidth = max(max(max(self.challengeContainer.calculateAccumulatedFrame().size.width, self.nextLevelButton.size.width + self.menuButton.size.width + self.retryLevelButton.size.width + buttonBuffer * 2), self.distanceLabel.calculateAccumulatedFrame().size.width), self.heartBoostContainer.calculateAccumulatedFrame().size.width)
        
        // Now create stuff dependent on the page width
        self.upgradeSkillsDescription.paragraphWidth = self.pageWidth - self.buttonBuffer - self.upgradeSkillsButton.size.width
        self.upgradeSkillsDescription.text = "don't forget to upgrade your skills! try different skill combos if a level is too hard."
        
        self.levelHintDescription.paragraphWidth = self.pageWidth
        self.levelHintDescription.text = "tip: upgrade your skills below"
        
        // Get the page height
        let page1TotalHeight: CGFloat = self.endedLabel.calculateAccumulatedFrame().size.height + self.distanceLabel.calculateAccumulatedFrame().size.height + self.enemyLabel.calculateAccumulatedFrame().size.height + self.totalLabel.calculateAccumulatedFrame().size.height + self.page1ContinueButton.size.height + self.starButton1.size.height + self.buttonBuffer * 6
        let page2TotalHeight: CGFloat = self.challengeTitle.calculateAccumulatedFrame().size.height + self.challengeContainer.calculateAccumulatedFrame().size.height + self.challengeRewardNumber.calculateAccumulatedFrame().size.height + self.page2ContinueButton.size.height + self.buttonBuffer * 3
        let page4TotalHeight: CGFloat = self.whatNextLabel.calculateAccumulatedFrame().size.height + self.heartBoostContainer.calculateAccumulatedFrame().size.height + self.nextLevelButton.size.height + self.buttonBuffer * 2
        
        self.pageHeight = max(max(page1TotalHeight, page2TotalHeight), page4TotalHeight)
        
        // Page 1 positioning
        self.endedLabel.position = CGPoint(/*pageWidth / -2 + self.endedLabel.calculateAccumulatedFrame().size.width / 2*/x: 0, y: pageHeight / 2 - endedLabel.calculateAccumulatedFrame().size.height / 2)
        self.updateScorePositioning()
        
        // star array
        var count: Int = 0
        for node in stars {
            let nodeXPosition = (sampleSize.width * 1.2) * (CGFloat(count) - 1) + ((CGFloat(count) - 1)) - (sampleSize.width)/2 - 2
            let nodeYPosition = self.totalLabel.position.y - (self.totalLabel.calculateAccumulatedFrame().size.height / 2) - buttonBuffer - (self.starButton1.size.height / 2)
            node.position = CGPoint(x: nodeXPosition, y: nodeYPosition)
            
            count += 1
        }
        self.page1ContinueButton.position = CGPoint(x: pageWidth / 2 - self.page1ContinueButton.size.width / 2, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        self.upgradeSkillsButton.position = CGPoint(x: page1ContinueButton.position.x - page1ContinueButton.size.width / 2 - self.upgradeSkillsButton.size.width / 2 - self.buttonBuffer / 2, y: self.page1ContinueButton.position.y)
        
        // Page 2 positions
        self.challengeTitle.position = CGPoint(/*pageWidth / -2 + self.challengeTitle.calculateAccumulatedFrame().size.width / 2*/x: 0, y: pageHeight / 2 - challengeTitle.calculateAccumulatedFrame().size.height / 2)
        self.challengeContainer.position = CGPoint(x: 0, y: self.challengeTitle.position.y - self.challengeTitle.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - challengeContainer.calculateAccumulatedFrame().size.height / 2)
        self.updateChallengeRewardPositions()
        
        self.page2ContinueButton.position = CGPoint(x: pageWidth / 2 - self.page2ContinueButton.size.width / 2, y: pageHeight / -2 + self.page2ContinueButton.size.height / 2)
        
        // Page 4 positions
        self.whatNextLabel.position = CGPoint(/*pageWidth / -2 + self.whatNextLabel.calculateAccumulatedFrame().size.width / 2*/x: 0, y: pageHeight / 2 - whatNextLabel.calculateAccumulatedFrame().size.height / 2)

        self.heartBoostContainer.position = CGPoint(x: 0, y: 0/* - self.heartBoostContainer.calculateAccumulatedFrame().size.height / 2*/)
        self.updateGemsTotalPositions()
        
        self.menuButton.position = CGPoint(x: -menuButton.size.width - buttonBuffer, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        self.retryLevelButton.position = CGPoint(x: 0.0, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        self.nextLevelButton.position = CGPoint(x: nextLevelButton.size.width + buttonBuffer, y: pageHeight / -2 + self.page1ContinueButton.size.height / 2)
        
        // Set alpha to 0 so it fades in
        self.alpha = 0.0
        
        // Hide it all page 1
        self.page1.isHidden = true
        self.container.isHidden = true
        self.containerBackground.isHidden = true
        self.endedLabel.isHidden = true
        self.distanceLabel.isHidden = true
        self.enemyLabel.isHidden = true
        self.totalLabel.isHidden = true
        self.distanceScoreLabel.isHidden = true
        self.enemyScoreLabel.isHidden = true
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
        self.page2ContinueButton.isHidden = true
        
        // Page 3 hides
        self.page3.isHidden = true
        self.page3ContinueButton.isHidden = true
        self.upgradeSkillsTitle.isHidden = true
        self.upgradeSkillsDescription.isHidden = true
        self.upgradeSkillsButton.isHidden = true
        self.levelHintDescription.isHidden = true
        
        // Page 4 hides
        self.page4.isHidden = true
        self.whatNextLabel.isHidden = true
        self.gemsNumber.isHidden = true
        self.gemsIcon.isHidden = true
        self.gemsTitle.isHidden = true
        self.menuButton.isHidden = true
        self.retryLevelButton.isHidden = true
        self.nextLevelButton.isHidden = true
        self.heartBoostContainer.isHidden = true
        
        // Reset size of container
        self.resetContainerSize()
        
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func applyScore(_ score: LevelScore, completedChallenges: Array<LevelChallenge>) {
        // Update score text
        totalLabel.text = "average score: "
        enemyLabel.text = "minions defeated: "//\(score.heartsCollected) of \(score.maxHeartsToCollect) ="
        distanceLabel.text = "distance: "//\(Int(floor(score.distanceTraveled))) of \(Int(floor(score.maxDistanceToTravel))) ="
        totalScoreLabel.text = "...\(Int(floor(score.totalCompletePercent*100)))%"
        enemyScoreLabel.text = "...\(Int(floor(score.heartsCollectedPercent*100)))%"
        distanceScoreLabel.text = "...\(Int(floor(score.distanceTraveledPercent*100)))%"
        
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
        
        // Update gems score
        self.gemsNumber.setText("\(GameData.sharedGameData.totalDiamonds)")
        self.updateGemsTotalPositions()
        
        // Mark that we have a score now
        self.hasValidScore = true
    }
    
    func displayEndOfLevelDialog() {
        if self.hasValidScore {
            self.isHidden = false
            
            // Start the new action
            self.run(SKAction.sequence([
                SKAction.fadeIn(withDuration: 3.0),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.container.isHidden = false
                    self.containerBackground.isHidden = false
                    self.endedLabel.isHidden = false
                    
                    self.page1.isHidden = false
                    self.page2.isHidden = true
                    self.page3.isHidden = true
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.distanceLabel.isHidden = false
                    self.distanceScoreLabel.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.enemyLabel.isHidden = false
                    self.enemyScoreLabel.isHidden = false
                }),
                SKAction.wait(forDuration: endSpeed),
                SKAction.run({
                    self.totalLabel.isHidden = false
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
                    self.upgradeSkillsButton.isHidden = false
                    self.levelHintDescription.isHidden = false
                    
                    self.page1ContinueButton.isHidden = false
                })
                ]),withKey: "playerWinning")
        }
    }
    
    func showNextPage() {
        if self.currentPage == 1 {
            self.displayPage2()
            self.currentPage += 1
        } else if self.currentPage == 2 {
            self.displayPage4()
            self.currentPage += 1
        } /*else if self.currentPage == 3 {
            self.displayPage4()
            self.currentPage += 1
        }*/
    }
    
    func displayPage2() {
        // Start the new action
        self.run(SKAction.sequence([
            SKAction.run({
                self.page1.isHidden = true
                self.page2.isHidden = false
                self.page3.isHidden = true
                self.page4.isHidden = true
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
                self.page2ContinueButton.isHidden = false
            })
            ]),withKey: "playerWinning")
    }
    
    func displayPage4() {
        self.page1.isHidden = true
        self.page2.isHidden = true
        self.page3.isHidden = true
        self.page4.isHidden = false
        
        self.whatNextLabel.isHidden = false
        
        self.gemsNumber.isHidden = false
        self.gemsIcon.isHidden = false
        self.gemsTitle.isHidden = false
        
        self.heartBoostContainer.isHidden = false
        self.menuButton.isHidden = false
        self.retryLevelButton.isHidden = false
        self.nextLevelButton.isHidden = false
    }
    
    func updateScorePositioning() {
        self.distanceLabel.position = CGPoint(x: pageWidth / -2 + self.distanceLabel.calculateAccumulatedFrame().size.width / 2, y: self.endedLabel.position.y - self.endedLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 2 - distanceLabel.calculateAccumulatedFrame().size.height / 2)
        self.enemyLabel.position = CGPoint(x: pageWidth / -2 + self.enemyLabel.calculateAccumulatedFrame().size.width / 2, y: self.distanceLabel.position.y - self.distanceLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - enemyLabel.calculateAccumulatedFrame().size.height / 2)
        self.totalLabel.position = CGPoint(x: pageWidth / -2 + self.totalLabel.calculateAccumulatedFrame().size.width / 2, y: self.enemyLabel.position.y - self.enemyLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - totalLabel.calculateAccumulatedFrame().size.height / 2)
        
        self.distanceScoreLabel.position = CGPoint(x: pageWidth/2 - self.distanceScoreLabel.calculateAccumulatedFrame().size.width / 2, y: self.endedLabel.position.y - self.endedLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 2 - distanceLabel.calculateAccumulatedFrame().size.height / 2)
        self.enemyScoreLabel.position = CGPoint(x: pageWidth/2 - self.enemyScoreLabel.calculateAccumulatedFrame().size.width / 2, y: self.distanceLabel.position.y - self.distanceLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - enemyLabel.calculateAccumulatedFrame().size.height / 2)
        self.totalScoreLabel.position = CGPoint(x: pageWidth/2 - self.totalScoreLabel.calculateAccumulatedFrame().size.width / 2, y: self.enemyLabel.position.y - self.enemyLabel.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - totalLabel.calculateAccumulatedFrame().size.height / 2)
        
        self.levelHintDescription.position = CGPoint(/*0 - pageWidth/2 + self.levelHintDescription.calculateAccumulatedFrame().size.width / 2*/x: 0, y: self.starButton1.position.y - self.starButton1.calculateAccumulatedFrame().size.height / 2 - buttonBuffer - levelHintDescription.calculateAccumulatedFrame().size.height / 2)
    }
    
    func updateChallengeRewardPositions() {
        self.challengeRewardIcon.position = CGPoint(x: pageWidth / 2 - self.challengeRewardIcon.size.width / 2, y: 0)
        self.challengeRewardNumber.position = CGPoint(x: self.challengeRewardIcon.position.x - (self.challengeRewardIcon.size.width / 2) - self.challengeRewardNumber.calculateAccumulatedFrame().size.width / 2, y: self.challengeContainer.position.y - self.challengeContainer.calculateAccumulatedFrame().size.height / 2 - buttonBuffer * 0.25 - challengeRewardNumber.calculateAccumulatedFrame().size.height / 2)
        self.challengeRewardIcon.position = CGPoint(x: self.challengeRewardIcon.position.x, y: self.challengeRewardNumber.position.y)
        self.challengeRewardTitle.position = CGPoint(x: self.challengeRewardNumber.position.x - self.challengeRewardNumber.calculateAccumulatedFrame().size.width / 2 - buttonBuffer - self.challengeRewardTitle.calculateAccumulatedFrame().size.width / 2, y: self.challengeRewardNumber.position.y - buttonBuffer * 0.3)
    }
    
    func updateGemsTotalPositions() {
        let width = self.gemsIcon.size.width + self.gemsNumber.calculateAccumulatedFrame().size.width + self.gemsTitle.calculateAccumulatedFrame().size.width + buttonBuffer

        self.gemsIcon.position = CGPoint(x: width / 2 - self.gemsIcon.size.width / 2, y: self.heartBoostContainer.position.y + self.heartBoostContainer.calculateAccumulatedFrame().size.height / 2 + buttonBuffer + self.gemsIcon.size.height / 2)
        self.gemsNumber.position = CGPoint(x: self.gemsIcon.position.x - (self.gemsIcon.size.width / 2) - self.gemsNumber.calculateAccumulatedFrame().size.width / 2, y: self.gemsIcon.position.y)
        self.gemsTitle.position = CGPoint(x: self.gemsNumber.position.x - self.gemsNumber.calculateAccumulatedFrame().size.width / 2 - buttonBuffer - self.gemsTitle.calculateAccumulatedFrame().size.width / 2, y: self.gemsIcon.position.y)
    }
}
