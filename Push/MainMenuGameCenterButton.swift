//
//  MainMenuGamecenterButton.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/11/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(MainMenuGameCenterButton)
class MainMenuGameCenterButton : DBButton {
    var oppositeTexture: SKTexture
    var inError: Bool = false
    
    init(scene: DBScene) {
        self.oppositeTexture = SKTexture(imageNamed: "trophyred")
        super.init(iconName: "trophy", pressedIconName: nil, buttonSize: DBButtonSize.flag, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        // TODO if already tried but failed, prompt message that says NOGO sorry dude
        if GameKitHelper.sharedInstance.enableGameCenter {
            self.hideError()
            self.dbScene!.viewController!.showLeaderboardAndAchievements(true)
        } else if !GameKitHelper.sharedInstance.triedToAuthenticate {
            GameKitHelper.sharedInstance.authenticateLocalPlayer(true)
        } else {
            (scene as! MainMenuScene).playerNotAuthenticated()
        }
    }
    
    func showError() {
        if !inError {
            let tempTexture = self.unPressedIcon!.texture
            self.unPressedIcon!.texture = self.oppositeTexture
            self.pressedIcon!.texture = self.oppositeTexture
            self.oppositeTexture = tempTexture!
            self.inError = true
        }
    }
    
    func hideError() {
        if inError {
            let tempTexture = self.unPressedIcon!.texture
            self.unPressedIcon!.texture = self.oppositeTexture
            self.pressedIcon!.texture = self.oppositeTexture
            self.oppositeTexture = tempTexture!
            self.inError = false
        }
    }
}
