//
//  PauseMenu.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class PauseMenu: DialogBackground {
    var quitButton: GameQuitButton
    var restartButton: GameRestartButton
    var resumeButton: GameResumeButton
    var heartBoostContainer: HeartBoostContainer?
    
    init(frameSize : CGSize, scene: GameScene, heartBoost: Int, heartCost: Int) {
        // Create the buttons
        self.quitButton = GameQuitButton(scene: scene)
        self.restartButton = GameRestartButton(scene: scene)
        self.resumeButton = GameResumeButton(scene: scene)
        
        super.init(frameSize: frameSize)
        
        // Update heart boost
        var nextBoost: Int = 0
        if heartCost <= GameData.sharedGameData.totalDiamonds {
            nextBoost = heartBoost
        } else {
            nextBoost = 0
        }
        self.heartBoostContainer = HeartBoostContainer(scene: scene, selectedLevel: nextBoost)
        
        let heightAdjuster: CGFloat = -6.0
        
        let topSeparator = SKSpriteNode(texture: GameTextures.sharedInstance.gameHudAndMenuAtlas.textureNamed("underline_bar_small"))
        let bottomSeparator = SKSpriteNode(texture: GameTextures.sharedInstance.gameHudAndMenuAtlas.textureNamed("underline_bar_small"))
        
        self.heartBoostContainer!.position = CGPointMake(0, self.heartBoostContainer!.calculateAccumulatedFrame().size.height / 2)
        
        self.restartButton.position = CGPointMake(0.0, self.heartBoostContainer!.position.y - self.heartBoostContainer!.calculateAccumulatedFrame().size.height / 2 - self.restartButton.size.height / 2 - self.buttonBuffer * 2)
        
        topSeparator.position = CGPointMake(0.0, self.heartBoostContainer!.position.y + self.heartBoostContainer!.calculateAccumulatedFrame().size.height / 2 + topSeparator.size.height / 2)
        
        self.resumeButton.position = CGPointMake(0.0, topSeparator.position.y + topSeparator.size.height / 2 + self.resumeButton.size.height / 2 + self.buttonBuffer)
        
        bottomSeparator.position = CGPointMake(0.0, self.restartButton.position.y - self.restartButton.size.height / 2 - self.buttonBuffer - bottomSeparator.size.height / 2)
        
        self.quitButton.position = CGPointMake(0.0, bottomSeparator.position.y - bottomSeparator.size.height / 2 - self.buttonBuffer - self.quitButton.size.height / 2)
        
        // We need to do a little height adjustment due to offset
        self.restartButton.position = CGPointMake(self.restartButton.position.x, self.restartButton.position.y - heightAdjuster)
        self.resumeButton.position = CGPointMake(self.resumeButton.position.x, self.resumeButton.position.y - heightAdjuster)
        self.heartBoostContainer!.position = CGPointMake(self.heartBoostContainer!.position.x, self.heartBoostContainer!.position.y - heightAdjuster)
        self.quitButton.position = CGPointMake(self.quitButton.position.x, self.quitButton.position.y - heightAdjuster)
        bottomSeparator.position = CGPointMake(bottomSeparator.position.x, bottomSeparator.position.y - heightAdjuster)
        topSeparator.position = CGPointMake(topSeparator.position.x, topSeparator.position.y - heightAdjuster)
        
        
        self.container.addChild(self.quitButton)
        self.container.addChild(self.restartButton)
        self.container.addChild(self.resumeButton)
        self.container.addChild(self.heartBoostContainer!)
        self.container.addChild(topSeparator)
        self.container.addChild(bottomSeparator)
        
        // Reset the container size
        self.resetContainerSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}