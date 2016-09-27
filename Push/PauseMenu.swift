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
    
    init() {
        // Create the buttons
        self.quitButton = GameQuitButton()
        self.restartButton = GameRestartButton()
        self.resumeButton = GameResumeButton()
        
        super.init(frameSize: CGSize())
    }
    
    init(frameSize : CGSize, scene: GameScene) {
        // Create the buttons
        self.quitButton = GameQuitButton(scene: scene)
        self.restartButton = GameRestartButton(scene: scene)
        self.resumeButton = GameResumeButton(scene: scene)
        
        super.init(frameSize: frameSize)
        
        /*
        self.quitButton.position = CGPointMake(self.quitButton.size.width + buttonBuffer, -self.container.size.height / 2)
        self.restartButton.position = CGPointMake(0.0, -self.container.size.height / 2)
        self.resumeButton.position = CGPointMake(-self.quitButton.size.width - buttonBuffer, -self.container.size.height / 2)
        */
        self.resumeButton.position = CGPoint(x: 0.0, y: self.resumeButton.size.height + self.buttonBuffer)
        self.restartButton.position = CGPoint(x: 0.0, y: 0)
        self.quitButton.position = CGPoint(x: 0.0, y: -self.resumeButton.size.height - self.buttonBuffer)
        
        self.container.addChild(self.quitButton)
        self.container.addChild(self.restartButton)
        self.container.addChild(self.resumeButton)
        
        // Reset the container size
        self.resetContainerSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
