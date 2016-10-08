//
//  GameNextLevelButton.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(GameNextLevelButton)
class GameNextLevelButton : DBButton {    
    var text: LabelWithShadow?
    
    var gemIconScale: CGFloat = 0.825
    var buffer: CGFloat = 6.0
    var level: Int = 0
    var maxLevel: Int = 65 /*MAX*/
    
    init() {
        super.init(dbScene: nil)
    }
    
    init(scene: GameScene, level: Int) {
        self.level = level
        
        if level <= maxLevel {
            self.text = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.text!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.text!.setText("\(level)")
            
            super.init(buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
            
            // Setup text
            self.text!.setFontSize(round(34 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            self.text!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)

            self.addChild(self.text!)
        } else {
            super.init(iconName: "button_credits", pressedIconName: nil, buttonSize: DBButtonSize.small, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
            /*self.text = LabelWithShadow(fontNamed: "AvenirNextCondensed-Bold", darkFont: false, borderSize: 1.25 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.text!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.text!.setText("credits")
            
            super.init(buttonSize: DBButtonSize.small, dbScene: scene)
            
            // Setup text
            self.text!.setFontSize(round(34 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
            self.text!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            
            self.addChild(self.text!)*/
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBeganAction() {
        //if self.level < maxLevel {
            let scaleMult: CGFloat = 0.95
        
            self.setScale(1 * scaleMult)
        //}
    }
    
    override func touchesEndedAction() {
        //if self.level < maxLevel {
            self.setScale(1)
        //}
        
        if self.level <= maxLevel {
            (self.dbScene as! GameScene).endSceneNextLevel()
        } else {
            (self.dbScene as! GameScene).displayCredits()
        }
    }
    
    override func touchesReleasedAction() {
        //if self.level < maxLevel {
            self.setScale(1)
        //}
    }
}

