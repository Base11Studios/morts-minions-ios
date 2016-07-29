//
//  HeartBoosts.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/7/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

enum HeartBoostCosts: Int {
    case oneHeart = 2
    case twoHearts = 5
    case threeHearts = 11
    
    static func getCostOfBoost(_ boost: Int) -> Int {
        switch (boost) {
        case 1:
            return oneHeart.rawValue
        case 2:
            return twoHearts.rawValue
        case 3:
            return threeHearts.rawValue
        default:
            return 0
        }
    }
}
