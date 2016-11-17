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
    internal var earthLevelAtlases = [SKTextureAtlas]()
    
    internal var waterAtlas = SKTextureAtlas()
    internal var waterLevelAtlases = [SKTextureAtlas]()
    
    internal var fireAtlas = SKTextureAtlas()
    internal var fireLevelAtlases = [SKTextureAtlas]()
    
    internal var airAtlas = SKTextureAtlas()
    internal var airLevelAtlases = [SKTextureAtlas]()
    
    internal var spiritAtlas = SKTextureAtlas()
    internal var spiritLevelAtlases = [SKTextureAtlas]()
    
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
    
    internal var menuSceneAtlas = [SKTextureAtlas()]
    
    // MARK: - Init
    init() {
        self.buttonAtlas = SKTextureAtlas(named: "buttons2")
        
        // Create texture atlases
        self.earthAtlas = SKTextureAtlas(named: "earth2")
        self.waterAtlas = SKTextureAtlas(named: "water2")
        self.fireAtlas = SKTextureAtlas(named: "fire2")
        self.airAtlas = SKTextureAtlas(named: "air2")
        self.spiritAtlas = SKTextureAtlas(named: "spirit2")
        
        // Common
        self.projectilesAtlas = SKTextureAtlas(named: "projectiles2")
        
        self.playerWarriorAtlas = SKTextureAtlas(named: "playerwarrior2")
        self.playerMonkAtlas = SKTextureAtlas(named: "playermonk2")
        self.playerMageAtlas = SKTextureAtlas(named: "playermage2")
        self.playerArcherAtlas = SKTextureAtlas(named: "playerarcher2")
        
        
        self.buttonGameAtlas = SKTextureAtlas(named: "buttonsgame2")
        self.buttonMenuAtlas = SKTextureAtlas(named: "buttonsmenu2")
        
        self.uxAtlas = SKTextureAtlas(named: "ux2")
        self.uxMenuAtlas = SKTextureAtlas(named: "uxmenu2")
        self.uxGameAtlas = SKTextureAtlas(named: "uxgame2")
        
        self.splashAndStoryAtlas = SKTextureAtlas(named: "splashandstory2")
        
        
        // Create arrays used for gameplay
        self.earthLevelAtlases.append(self.earthAtlas)
        self.waterLevelAtlases.append(self.waterAtlas)
        self.fireLevelAtlases.append(self.fireAtlas)
        self.airLevelAtlases.append(self.airAtlas)
        self.spiritLevelAtlases.append(self.spiritAtlas)
        
        self.addCommonAtlasToAllLevelAtlases(self.projectilesAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.buttonAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.buttonGameAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.uxGameAtlas)
        self.addCommonAtlasToAllLevelAtlases(self.uxAtlas)
        
        // Menu scene
        self.menuSceneAtlas.append(self.uxAtlas)
        self.menuSceneAtlas.append(self.uxMenuAtlas)
        self.menuSceneAtlas.append(self.buttonAtlas)
        self.menuSceneAtlas.append(self.buttonMenuAtlas)
 
    }
    
    func addCommonAtlasToAllLevelAtlases(_ atlas: SKTextureAtlas) {
        self.earthLevelAtlases.append(atlas)
        self.waterLevelAtlases.append(atlas)
        self.fireLevelAtlases.append(atlas)
        self.airLevelAtlases.append(atlas)
        self.spiritLevelAtlases.append(atlas)
    }
 
    func getAtlasArrayForWorld(world: String) -> [SKTextureAtlas] {
        if world == "earth" {
            return self.earthLevelAtlases
        } else if world == "water" {
            return self.waterLevelAtlases
        } else if world == "fire" {
            return self.fireLevelAtlases
        } else if world == "air" {
            return self.airLevelAtlases
        } else if world == "spirit" {
            return self.spiritLevelAtlases
        }
        
        return [SKTextureAtlas]()
    }
    
    func getAtlasForWorld(world: String) -> SKTextureAtlas {
        if world == "earth" {
            return self.earthAtlas
        } else if world == "water" {
            return self.waterAtlas
        } else if world == "fire" {
            return self.fireAtlas
        } else if world == "air" {
            return self.airAtlas
        } else if world == "spirit" {
            return self.spiritAtlas
        }
        
        return SKTextureAtlas()
    }
}
