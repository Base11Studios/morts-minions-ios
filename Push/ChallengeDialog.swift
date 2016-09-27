//
//  ChallengeDialog.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/17/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class ChallengeDialog: DialogBackground {
    var challengeContainer: ChallengeContainer
    var okButton: GameChallengeOkButton
    var title: SKLabelNode
    var dialogDescription: SKLabelNode
    
    weak var dbScene: DBScene?
    var buffer: CGFloat = 10.0
    
    init(frameSize : CGSize, scene: DBScene, challenges: Array<LevelChallenge>) {
        self.title = SKLabelNode(fontNamed: "Avenir-Medium")
        self.title.fontSize = 28 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.title.fontColor = MerpColors.darkFont
        self.title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.title.text = "Level Challenges"
        
        self.dialogDescription = SKLabelNode(fontNamed: "Avenir-Medium")
        self.dialogDescription.fontSize = 14 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
        self.dialogDescription.fontColor = MerpColors.darkFont
        self.dialogDescription.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.dialogDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.dialogDescription.text = "Complete challenges to earn gems!"
        
        self.okButton = GameChallengeOkButton(scene: scene)
        self.challengeContainer = ChallengeContainer(scene: scene, challenges: challenges)
        
        super.init(frameSize: frameSize)
        
        // Get total height of the 2 items + buffer
        let totalHeight = self.challengeContainer.calculateAccumulatedFrame().size.height + buffer * 2 + self.okButton.size.height + self.title.calculateAccumulatedFrame().size.height + self.dialogDescription.calculateAccumulatedFrame().size.height + buffer
        
        self.title.position = CGPoint(x: 0 - self.challengeContainer.trueWidth / 2, y: totalHeight / 2 - self.title.calculateAccumulatedFrame().size.height / 2)
        self.dialogDescription.position = CGPoint(x: 0 - self.challengeContainer.trueWidth / 2, y: self.title.position.y - (self.title.calculateAccumulatedFrame().size.height / 2) - self.buffer - self.dialogDescription.calculateAccumulatedFrame().size.height / 2)
        self.challengeContainer.position = CGPoint(x: 0, y: self.dialogDescription.position.y - (self.dialogDescription.calculateAccumulatedFrame().size.height / 2) - self.buffer - self.challengeContainer.calculateAccumulatedFrame().size.height / 2)
        self.okButton.position = CGPoint(x: self.challengeContainer.trueWidth / 2 - self.okButton.size.width / 2, y: self.challengeContainer.position.y - self.challengeContainer.calculateAccumulatedFrame().size.height / 2 - self.buffer - self.okButton.size.height / 2)
        
        self.container.addChild(title)
        self.container.addChild(dialogDescription)
        self.container.addChild(okButton)
        self.container.addChild(challengeContainer)
        
        // Reset the container size
        self.resetContainerSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
