//
//  ScrollingSKSpriteNode.swift
//  Push
//
//  Created by Dan Bellinski on 10/24/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(ScrollingLevelNode)
class ScrollingLevelNode : SKNode {
    var levelNumber: Int = 1
    var levelLocked: Bool = true
    var levelLockNode: SKSpriteNode?
    var levelLockedLabel: SKLabelNode?
    var levelOpenLabel: LabelWithShadow?
    
    var starsRepresented: Int = 0
    //var levelDescriptionLabel: SKLabelNode
    var timesLevelPlayedLabel: SKLabelNode?
    var levelBackground: SKSpriteNode
    var worldName: String
    var levelSelectionBackground: SKSpriteNode
    
    var levelLockedDescLabel1: SKLabelNode?
    var levelLockedDescLabel2: SKLabelNode?
    
    // Unlock labels
    var unlockLevelLabel: LabelWithShadow?
    var unlockLevelIcon: SKSpriteNode?
    
    // Rewards
    var starFilled1: SKSpriteNode?
    var starFilled2: SKSpriteNode?
    var starFilled3: SKSpriteNode?
    var starEmpty1: SKSpriteNode?
    var starEmpty2: SKSpriteNode?
    var starEmpty3: SKSpriteNode?
    var sampleStar: SKSpriteNode?
    var citrineFilled1: SKSpriteNode?
    var citrineEmpty1: SKSpriteNode?
    
    // Chgs
    var challenge1Button: ChallengeButton?
    var challenge2Button: ChallengeButton?
    
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    init(imageName: String, textureAtlas: SKTextureAtlas, levelNumber: Int, worldName: String, scene: DBScene, challengeSet: [String : Bool]){
        self.levelNumber = levelNumber
        
        // Self tecture
        let texture = textureAtlas.textureNamed(imageName)
        self.levelSelectionBackground = SKSpriteNode(texture: texture)
        
        // Level background .. TODO load from file
        self.worldName = worldName
        self.levelBackground = SKSpriteNode(texture: GameTextures.sharedInstance.uxMenuAtlas.textureNamed("level_select_\(worldName)"))
        
        self.levelBackground.position = CGPoint(x: 0, y: 16 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        // Level description
        //self.levelDescriptionLabel = SKLabelNode(fontNamed: "Avenir-Medium")
        
        self.levelLocked = GameData.sharedGameData.getSelectedCharacterData().isLevelLocked(self.levelNumber)
        
        // Only do this if the level is locked
        if self.levelLocked {
            // Cost
            self.unlockLevelIcon = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
            
            // Unlocked level info
            self.unlockLevelLabel = LabelWithShadow(fontNamed: "Avenir-Medium", darkFont: false, borderSize: 1 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            self.levelLockedDescLabel1 = SKLabelNode(fontNamed: "Avenir-Medium")
            self.levelLockedDescLabel2 = SKLabelNode(fontNamed: "Avenir-Medium")
            
            // Locked label
            self.levelLockedLabel = SKLabelNode(fontNamed: "Avenir-Medium")
            
            // Add the level lock icon
            self.levelLockNode = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("button_level_selector_lock"))
        } else {
            self.timesLevelPlayedLabel = SKLabelNode(fontNamed: "Avenir-Light")
            
            // Unlocked label
            self.levelOpenLabel = LabelWithShadow(fontNamed: "Avenir-Heavy", darkFont: false, borderSize: 2 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            
            // Rewards
            self.starFilled1 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
            self.starFilled2 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
            self.starFilled3 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
            self.starEmpty1 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("starempty"))
            self.starEmpty2 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("starempty"))
            self.starEmpty3 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("starempty"))
            self.citrineFilled1 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("superstar"))
            self.citrineEmpty1 = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("superstarempty"))
            
            self.sampleStar = SKSpriteNode(texture: GameTextures.sharedInstance.buttonAtlas.textureNamed("star"))
            self.sampleStar!.setScale(0.7)
            
            self.challenge1Button = ChallengeButton(scene: scene)
            self.challenge2Button = ChallengeButton(scene: scene)
        }
        
        super.init()
        
        self.addChild(levelSelectionBackground)
        self.addChild(levelBackground)
        
        // Only do this if the level is locked
        if self.levelLocked {
            // Cost
            self.unlockLevelIcon!.position = CGPoint(x: self.levelSelectionBackground.size.width / 2 - self.unlockLevelIcon!.size.width / 2 - self.nodeBuffer/2, y: -self.levelSelectionBackground.size.height / 2 + self.unlockLevelIcon!.size.width / 2 + self.nodeBuffer/2)
            self.unlockLevelIcon!.setScale(0.75)
            self.unlockLevelIcon!.isHidden = true
            
            // Unlocked level info
            self.unlockLevelLabel!.setFontSize(round(32 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            self.unlockLevelLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.right)
            self.unlockLevelLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            self.unlockLevelLabel!.setText("\(GameData.sharedGameData.getSelectedCharacterData().getLevelUnlockRequirements(levelNumber))")
            self.unlockLevelLabel!.isHidden = true
            self.unlockLevelLabel!.position = CGPoint(x: self.unlockLevelIcon!.position.x - self.unlockLevelIcon!.size.width / 2 - self.nodeBuffer/4, y: self.unlockLevelIcon!.position.y)
            
            self.levelLockedDescLabel1!.fontSize = round(18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.levelLockedDescLabel1!.fontColor = MerpColors.merpRed
            self.levelLockedDescLabel1!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            self.levelLockedDescLabel1!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
            self.levelLockedDescLabel1!.text = "* need \(GameData.sharedGameData.getSelectedCharacterData().getLevelUnlockRequirements(levelNumber) - GameData.sharedGameData.getSelectedCharacterData().totalStars) more stars"
            self.levelLockedDescLabel1!.isHidden = true
            
            self.levelLockedDescLabel2!.fontSize = round(18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.levelLockedDescLabel2!.fontColor = MerpColors.merpRed
            self.levelLockedDescLabel2!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            self.levelLockedDescLabel2!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
            self.levelLockedDescLabel2!.text = "* earn a star on level \(levelNumber - 1)"
            self.levelLockedDescLabel2!.isHidden = true
            
            // Level #
            // Locked label
            self.levelLockedLabel!.fontSize = round(34 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.levelLockedLabel!.fontColor = MerpColors.lightFont
            self.levelLockedLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.levelLockedLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
            self.levelLockedLabel!.alpha = 0.8
            self.levelLockedLabel!.text = "\(levelNumber)"
            
            // Add the level lock icon
            levelLockNode!.alpha = 0.6
            
            // Set level label positioning
            self.levelLockedLabel!.position = CGPoint(x: -self.levelSelectionBackground.size.width / 2 + self.nodeBuffer, y: self.levelSelectionBackground.size.height / 2 - self.nodeBuffer * 1.2)
            
            self.levelLockedDescLabel1!.position = CGPoint(x: 0, y: levelSelectionBackground.position.y - levelSelectionBackground.size.height / 2 - self.nodeBuffer * 5 - self.levelLockedDescLabel1!.calculateAccumulatedFrame().size.height / 2)
            self.levelLockedDescLabel2!.position = CGPoint(x: self.levelLockedDescLabel1!.position.x, y: self.levelLockedDescLabel1!.position.y + self.levelLockedDescLabel1!.calculateAccumulatedFrame().size.height / 2 + self.levelLockedDescLabel2!.calculateAccumulatedFrame().size.height / 2 + self.nodeBuffer / 2)
            
            self.addChild(levelLockedDescLabel1!)
            self.addChild(levelLockedDescLabel2!)
            self.addChild(levelLockNode!)
            self.addChild(levelLockedLabel!)
            self.addChild(unlockLevelLabel!)
            self.addChild(unlockLevelIcon!)
            
        } else {
            var timesPlayed: Int
            if GameData.sharedGameData.getSelectedCharacterData().levelProgress[levelNumber] != nil && GameData.sharedGameData.getSelectedCharacterData().levelProgress[levelNumber]!.timesLevelPlayed < 1000000 {
                timesPlayed = GameData.sharedGameData.getSelectedCharacterData().levelProgress[levelNumber]!.timesLevelPlayed
            } else {
                timesPlayed = 0
            }
            
            self.timesLevelPlayedLabel!.isHidden = true
            self.timesLevelPlayedLabel!.fontSize = round(18 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.timesLevelPlayedLabel!.fontColor = MerpColors.darkFont
            self.timesLevelPlayedLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            self.timesLevelPlayedLabel!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
            self.timesLevelPlayedLabel!.text = "Level played \(timesPlayed) times"
            
            // Unlocked label
            self.levelOpenLabel!.setFontSize(round(70 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            self.levelOpenLabel!.position = CGPoint(x: 0, y: 20 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.levelOpenLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.levelOpenLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            self.levelOpenLabel!.setText("\(levelNumber)")
            
            self.challenge1Button!.position = CGPoint(x: 0 - self.challenge1Button!.size.width / 2 - nodeBuffer / 2, y: levelSelectionBackground.position.y - levelSelectionBackground.size.height / 2 - self.challenge1Button!.size.height / 2 - self.nodeBuffer * 2)
            self.challenge2Button!.position = CGPoint(x: 0 + self.challenge2Button!.size.width / 2 + nodeBuffer / 2, y: levelSelectionBackground.position.y - levelSelectionBackground.size.height / 2 - self.challenge2Button!.size.height / 2 - self.nodeBuffer * 2)
            
            self.timesLevelPlayedLabel!.position = CGPoint(x: 0, y: self.challenge1Button!.position.y - self.challenge1Button!.size.height / 2 - self.timesLevelPlayedLabel!.calculateAccumulatedFrame().size.height / 2 - nodeBuffer)
            
            self.name = "db_scrolling_node_\(levelNumber)"
            self.levelNumber = levelNumber
            
            // Add rewards
            self.setStarPositionAndAdd(1, node: self.starEmpty1!)
            self.setStarPositionAndAdd(2, node: self.starEmpty2!)
            self.setStarPositionAndAdd(3, node: self.starEmpty3!)
            self.setStarPositionAndAdd(1, node: self.starFilled1!)
            self.setStarPositionAndAdd(2, node: self.starFilled2!)
            self.setStarPositionAndAdd(3, node: self.starFilled3!)
            self.setStarPositionAndAdd(4, node: self.citrineEmpty1!)
            self.setStarPositionAndAdd(4, node: self.citrineFilled1!)
            
            self.updateStars()
 
            self.addChild(timesLevelPlayedLabel!)
            self.addChild(challenge1Button!)
            self.addChild(challenge2Button!)
            self.addChild(levelOpenLabel!)
        }
    }
    
    func setStarPositionAndAdd(_ number: Int, node: SKSpriteNode) {
        // Set the positions on the star array
        let count: Int = number - 1
        
        let sampleSize = self.sampleStar!.size
        
        node.setScale(0.80)
        let nodeAdjustment = (sampleSize.height / 2.0) + (self.nodeBuffer * 1.3)
        let nodeXPosition = (sampleSize.width * 1.18) * (CGFloat(count) - 1) + ((CGFloat(count) - 1)) - (sampleSize.width)/2 - 2
        let nodeYPosition = 0 - (self.levelSelectionBackground.size.height/2) + nodeAdjustment
        node.position = CGPoint(x: nodeXPosition, y: nodeYPosition)
        self.addChild(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStars() {
        // Temp
        var starsHighScore: Int
        if GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.levelNumber]?.starsEarnedHighScore != nil {
            starsHighScore = GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.levelNumber]!.starsEarnedHighScore
        } else {
            starsHighScore = 0
        }
        
        var citrineHighScore: Int
        if GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.levelNumber]?.citrineEarnedHighScore != nil {
            citrineHighScore = GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.levelNumber]!.citrineEarnedHighScore
        } else {
            citrineHighScore = 0
        }
        
        if starsHighScore > 0 {
            self.starFilled1!.isHidden = false
            self.starEmpty1!.isHidden = true
        } else {
            self.starFilled1!.isHidden = true
            self.starEmpty1!.isHidden = false
        }
        if starsHighScore > 1 {
            self.starFilled2!.isHidden = false
            self.starEmpty2!.isHidden = true
        } else {
            self.starFilled2!.isHidden = true
            self.starEmpty2!.isHidden = false
        }
        if starsHighScore > 2 {
            self.starFilled3!.isHidden = false
            self.starEmpty3!.isHidden = true
        } else {
            self.starFilled3!.isHidden = true
            self.starEmpty3!.isHidden = false
        }
        if citrineHighScore > 0 {
            self.citrineFilled1!.isHidden = false
            self.citrineEmpty1!.isHidden = true
        } else {
            self.citrineFilled1!.isHidden = true
            self.citrineEmpty1!.isHidden = false
        }
        
        self.starsRepresented = starsHighScore + citrineHighScore
        
        var numChallengesCompleted: Int = 0
        for challenge in GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.levelNumber]!.availableChallenges {
            if GameData.sharedGameData.getSelectedCharacterData().levelProgress[self.levelNumber]!.challengeCompletion.contains(challenge) {
                numChallengesCompleted += 1
            }
        }
        
        switch numChallengesCompleted {
        case 0:
            self.challenge1Button!.isHidden = true
            self.challenge2Button!.isHidden = true
        case 1:
            self.challenge1Button!.isHidden = false
            self.challenge2Button!.isHidden = true
            self.challenge1Button!.position = CGPoint(x: 0, y: levelSelectionBackground.position.y - levelSelectionBackground.size.height / 2 - self.challenge1Button!.size.height / 2 - self.nodeBuffer * 2)
        default:
            self.challenge1Button!.isHidden = false
            self.challenge2Button!.isHidden = false
            self.challenge1Button!.position = CGPoint(x: 0 - self.challenge1Button!.size.width / 2 - nodeBuffer / 2, y: levelSelectionBackground.position.y - levelSelectionBackground.size.height / 2 - self.challenge1Button!.size.height / 2 - self.nodeBuffer * 2)
            self.challenge2Button!.position = CGPoint(x: 0 + self.challenge2Button!.size.width / 2 + nodeBuffer / 2, y: levelSelectionBackground.position.y - levelSelectionBackground.size.height / 2 - self.challenge2Button!.size.height / 2 - self.nodeBuffer * 2)
        }
    }
    
    func displayLevelDetails(_ display: Bool) {
        if !self.levelLocked {
            self.timesLevelPlayedLabel!.isHidden = !display
        } else {
            if display {
                if !GameData.sharedGameData.getSelectedCharacterData().hasEnoughStarsToUnlock(self.levelNumber) {
                    self.levelLockedDescLabel1!.isHidden = false
                } else {
                    self.levelLockedDescLabel1!.isHidden = true
                }
                
                if !GameData.sharedGameData.getSelectedCharacterData().beatLevelBeforeToUnlock(self.levelNumber) {
                    self.levelLockedDescLabel2!.isHidden = false
                } else {
                    self.levelLockedDescLabel2!.isHidden = true
                }
            } else {
                self.levelLockedDescLabel1!.isHidden = true
                self.levelLockedDescLabel2!.isHidden = true
            }
        }
    }
}