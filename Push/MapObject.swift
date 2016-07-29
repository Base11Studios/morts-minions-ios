//
//  MapObject.swift
//  Merp
//
//  Created by Dan Bellinski on 1/24/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class MapObject : NSObject {
    var name: String = ""
    var position: CGFloat = 0.0
    var value1: Double = 0.0
    var value2: Double = 0.0
    
    init(mapName: String, andPosition mapPosition: CGFloat, andValue1 value1: Double, andValue2 value2: Double) {
        super.init()
        
        self.name = mapName
        self.position = mapPosition
        self.value1 = value1
        self.value2 = value2
    }
}