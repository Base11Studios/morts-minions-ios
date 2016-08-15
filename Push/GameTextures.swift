//
//  GameTextures.swift
//  Merp
//
//  Created by Dan Bellinski on 1/3/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class GameTextures {
    static let sharedInstance = GameTextures()
    
    // MARK: - Public class properties
    internal var earthAtlas = SKTextureAtlas()
    //internal var earthLevelAtlases = [SKTextureAtlas]()
    
    internal var waterAtlas = SKTextureAtlas()
    //internal var waterLevelAtlases = [SKTextureAtlas]()
    
    internal var fireAtlas = SKTextureAtlas()
    //internal var fireLevelAtlases = [SKTextureAtlas]()
    
    internal var airAtlas = SKTextureAtlas()
    //internal var airLevelAtlases = [SKTextureAtlas]()
    
    internal var spiritAtlas = SKTextureAtlas()
    //internal var spiritLevelAtlases = [SKTextureAtlas]()
    
    internal var projectilesAtlas = SKTextureAtlas()
    
    internal var playerWarriorAtlas = SKTextureAtlas()
    internal var playerMageAtlas = SKTextureAtlas()
    internal var playerMonkAtlas = SKTextureAtlas()
    internal var playerArcherAtlas = SKTextureAtlas()
    
    internal var buttonAtlas = SKTextureAtlas()
    internal var buttonGameAtlas = SKTextureAtlas()
    internal var buttonMenuAtlas = SKTextureAtlas()
    
    internal var uxAtlas = SKTextureAtlas()
    internal var uxMenuAtlas = SKTextureAtlas()
    internal var uxGameAtlas = SKTextureAtlas()
    
    internal var splashAndStoryAtlas = SKTextureAtlas()
    
    internal var waterStoryTutorialAtlas = SKTextureAtlas()
    
   // internal var menuSceneAtlas = [SKTextureAtlas()]
    
    // MARK: - Init
    init() {
        
        // Create texture atlases
        self.earthAtlas = SKTextureAtlas(named: "earth")
        self.waterAtlas = SKTextureAtlas(named: "water")
        self.fireAtlas = SKTextureAtlas(named: "fire")
        self.airAtlas = SKTextureAtlas(named: "air")
        self.spiritAtlas = SKTextureAtlas(named: "spirit")
        
        // Common
        self.projectilesAtlas = SKTextureAtlas(named: "projectiles")
        
        self.playerWarriorAtlas = SKTextureAtlas(named: "playerwarrior")
        self.playerMonkAtlas = SKTextureAtlas(named: "playermonk")
        self.playerMageAtlas = SKTextureAtlas(named: "playermage")
        self.playerArcherAtlas = SKTextureAtlas(named: "playerarcher")
        
        self.buttonAtlas = SKTextureAtlas(named: "buttons")
        self.buttonGameAtlas = SKTextureAtlas(named: "buttonsgame")
        self.buttonMenuAtlas = SKTextureAtlas(named: "buttonsmenu")
        
        self.uxAtlas = SKTextureAtlas(named: "ux")
        self.uxMenuAtlas = SKTextureAtlas(named: "uxmenu")
        self.uxGameAtlas = SKTextureAtlas(named: "uxgame")
        
        self.splashAndStoryAtlas = SKTextureAtlas(named: "splashandstory")
        
        self.waterStoryTutorialAtlas = SKTextureAtlas(named: "water-story-tutorial")
        
        /*
        //self.notSortedYetAtlas = SKTextureAtlas(named: "notsortedyet") // TODO REMOVE
        
        // Create arrays used for gameplay
        self.earthLevelAtlases.append(self.earthAtlas)
        self.waterLevelAtlases.append(self.waterAtlas)
        self.fireLevelAtlases.append(self.fireAtlas)
        self.airLevelAtlases.append(self.airAtlas)
        self.spiritLevelAtlases.append(self.spiritAtlas)
        
        self.addCommonAtlasToAllLevelAtlases(self.projectilesAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.playerAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.buttonAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.gameHudAndMenuAtlas)
        
        // Menu scene
        self.menuSceneAtlas.append(self.menuAtlas)
        self.menuSceneAtlas.append(self.gameHudAndMenuAtlas)
        self.menuSceneAtlas.append(self.buttonAtlas)
        */
    }
    /*
    func addCommonAtlasToAllLevelAtlases(_ atlas: SKTextureAtlas) {
        self.earthLevelAtlases.append(atlas)
        self.waterLevelAtlases.append(atlas)
        self.fireLevelAtlases.append(atlas)
        self.airLevelAtlases.append(atlas)
        self.spiritLevelAtlases.append(atlas)
    }
     */
}
