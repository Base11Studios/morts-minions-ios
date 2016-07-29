//
//  SpriteKitHelper.swift
//  Push
//
//  Created by Dan Bellinski on 10/6/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

@objc(SpriteKitHelper)
class SpriteKitHelper : NSObject {  // TODO doesnt need to inheirit from NSObject
    /*
    class func getTextureArrayFromAtlasNamed(atlasName: String) -> Array<SKTexture> {
        var frames: Array<SKTexture> = Array<SKTexture>()
        let animatedAtlas: SKTextureAtlas = SKTextureAtlas(named: atlasName)
        let numImages: Int = animatedAtlas.textureNames.count
        var textureName : String = "";
        
        for var i = 1; i <= numImages / 2; i++ {
            textureName = String(format: "%@%d", arguments: [atlasName, i]);
            
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        return frames
    }*/
    
    /*
    class func getTextureArrayFromAtlasNamed(atlasName: String, numberOfVersions: Int) -> Array<SKTexture> {
        var frames: Array<SKTexture> = Array<SKTexture>()
        let animatedAtlas: SKTextureAtlas = SKTextureAtlas(named: atlasName)
        let numImages: Int = animatedAtlas.textureNames.count
        var textureName : String = "";
        
        for var i = 0; i <= (numImages / numberOfVersions); i++ {
            textureName = String(format: "%@_%@", arguments: [atlasName, String(format: "%03d", arguments: [i])]);
            
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        return frames
    }
    
    class func getTextureArrayFromAtlasNamed(atlasName: String, frameStart: Int, frameEnd: Int) -> Array<SKTexture> {
        var frames: Array<SKTexture> = Array<SKTexture>()
        let animatedAtlas: SKTextureAtlas = SKTextureAtlas(named: atlasName)
        var textureName : String = "";
        
        for var i = frameStart; i <= frameEnd; i++ {
            textureName = String(format: "%@_%@", arguments: [atlasName, String(format: "%03d", arguments: [i])]);
            
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        return frames
    }
    */
    
    class func getTextureArrayFromAtlas(_ atlas: SKTextureAtlas, texturesNamed texturesName: String, frameStart: Int, frameEnd: Int) -> Array<SKTexture> {
        var frames: Array<SKTexture> = Array<SKTexture>()
        var textureName : String = "";
        
        //for var i = frameStart; i <= frameEnd; i += 1 {
        for i in frameStart...frameEnd {
            textureName = String(format: "%@_%@", arguments: [texturesName, String(format: "%03d", arguments: [i])]);
            
            frames.append(atlas.textureNamed(textureName))
        }
        return frames
    }
    
    class func hasCollisionOccurredOnFrontOfPlayer(_ player: Player, withFrontOfEnvironmentObject object: EnvironmentObject) -> Bool {
        if player.previousPreviousPosition.x + player.size.width / 2 <= object.previousPreviousPosition.x - object.size.width / 2 {
            return true
        }
        return false
    }
    
    class func hasCollisionOccurredOnBottomOfPlayer(_ player: Player, withTopOfEnvironmentObject object: EnvironmentObject) -> Bool {
        if player.previousPreviousPosition.y - player.size.height / 2 >= object.previousPreviousPosition.y + object.size.height / 2 {
            return true
        }
        return false
    }
    
    class func scaleCGSize(_ size: CGSize, withScalar scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }
}
