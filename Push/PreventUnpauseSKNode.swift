//
//  PreventUnpauseSKNode.swift
//  Merp
//
//  Created by Dan Bellinski on 12/20/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class PreventUnpauseSKNode : SKNode {
    var stayPaused: Bool = false
    
    override var isPaused: Bool {
        set(newValue) {
            if !self.stayPaused {
                super.isPaused = newValue
            } else {
                super.isPaused = true
            }
        }
        get {
            return super.isPaused
        }
    }
}
