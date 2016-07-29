//
//  ScaleBuddy.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 2/11/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class ScaleBuddy {
    static let sharedInstance = ScaleBuddy()
    var screenSize: CGSize = CGSize(width: 0, height: 0)
    var playerHorizontalLeft: CGFloat = 0
    var playerHorizontalRight: CGFloat = 0
    var deviceSize: DeviceSizes = DeviceSizes.wide6
    
    func getScaleAmount() -> CGFloat {
        if deviceSize == DeviceSizes.originaliPad {
            return 562.5 / 667
        } else if deviceSize == DeviceSizes.original4 || deviceSize == DeviceSizes.wide6 {
            return CGFloat(100 * ((screenSize.width / 667.0)/100))
        }
        
        return 1.0
    }
    
    func getGameScaleAmount(_ iPhoneSizing: Bool) -> CGFloat {
        if deviceSize == DeviceSizes.originaliPad {
            return 1.82
        } else if deviceSize == DeviceSizes.original4 || deviceSize == DeviceSizes.wide6 {
            if iPhoneSizing {
                return CGFloat(100 * ((screenSize.width / 667.0)/100))
            } else {
                return 1.0
            }
        }
        
        return 1.0
    }
    
    func getScreenAdjustedSprite(_ imageNamed: String, textureAtlas: SKTextureAtlas) -> SKSpriteNode {
        // TODO if this is an ipad divide the scaleamount by some amount? or just mod?
        let width: CGFloat = self.getScaleAmount()
        
        let texture = textureAtlas.textureNamed(imageNamed)
        return SKSpriteNode(texture: texture, size: CGSize(width: texture.size().width * width, height: texture.size().height))
    }
    
    func getScreenAdjustedSpriteWithModifier(_ imageNamed: String, textureAtlas: SKTextureAtlas, modifier: CGFloat) -> SKSpriteNode {
        let width: CGFloat = self.getScaleAmount()
        
        let texture = textureAtlas.textureNamed(imageNamed)
        return SKSpriteNode(texture: texture, size: CGSize(width: texture.size().width * ((1 - width) / modifier + width), height: texture.size().height))
    }
    
    func getNodeBuffer() -> CGFloat {
        return 10.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    }
}
