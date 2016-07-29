//
//  OptimizerBuddy.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 2/13/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class OptimizerBuddy {
    static let sharedInstance = OptimizerBuddy()
    
    func usePreciseCollisionDetection() -> Bool {
        return false
    }
}