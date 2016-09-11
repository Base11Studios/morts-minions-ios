//
//  DBMainMenuPlayButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(DBSceneSkillsButton)
class DBSceneSkillsButton : DBButton {
    init() {
        super.init(dbScene: nil)
    }
    
    init(scene: DBScene, size: DBButtonSize) {
        super.init(iconName: "button_skills", pressedIconName: nil, buttonSize: size, dbScene: scene, atlas: GameTextures.sharedInstance.buttonAtlas)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEndedAction() {
        self.dbScene!.viewController!.presentCharacterSkillScene(returnScene: self.dbScene!)
    }
}
