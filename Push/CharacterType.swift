//
//  CharacterTypes.swift
//  Push
//
//  Created by Dan Bellinski on 10/12/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

enum CharacterType : String {
    case Warrior = "warrior"
    case Archer = "archer"
    case Mage = "mage"
    case Monk = "monk"
    
    static func getUnlockCost(_ id: CharacterType) -> Int {
        if id == Warrior {
            return 0
        } else if id == Archer {
            //return 25
            return 0
        } else if id == Mage {
            return 200
            //return 0
        } else if id == Monk {
            return 0
            //return 150
        } else {
            return 0
        }
    }
    
    static func getCharacterName(_ id: CharacterType) -> String {
        if id == Warrior {
            return "Jim"
        } else if id == Archer {
            return "May"
        } else if id == Mage {
            return "Gary"
        } else if id == Monk {
            return "Leonard"
        } else {
            return ""
        }
    }
    
    static func getJumpSkillName(_ id: CharacterType) -> String {
        if id == Warrior {
            return "jump"
        } else if id == Archer {
            return "jump"
        } else if id == Mage {
            return "teleport"
        } else if id == Monk {
            return "jump"
        } else {
            return "jump"
        }
    }
    
    static var allCases: [CharacterType] {
        return [.Warrior, .Archer, .Mage, .Monk]
    }
}
