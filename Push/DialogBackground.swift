//
//  DialogBackground.swift
//  Push
//
//  Created by Dan Bellinski on 10/20/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class DialogBackground: SKSpriteNode {
    // Container
    var container: SKSpriteNode
    var containerBackground: SKSpriteNode
    var buttonBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    init(frameSize : CGSize) {
        // Create the containers
        self.container = SKSpriteNode(texture: nil, color: MerpColors.background, size: CGSize(width: 1, height: 1))
        self.containerBackground = SKSpriteNode(texture: nil, color: MerpColors.backgroundBorder, size: CGSize(width: 1, height: 1))
        
        // Setup the background from super init
        super.init(texture: nil, color: MerpColors.pauseBackground, size: frameSize)
        
        // Put in center of screen
        self.position = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        
        // Add the container
        self.addChild(containerBackground)
        self.containerBackground.addChild(container)
        self.isUserInteractionEnabled = true
    }
    
    convenience init() {
        self.init(frameSize: CGSize())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetContainerSize() {
        // Set the container size
        self.container.size = CGSize(width: self.container.calculateAccumulatedFrame().width + self.buttonBuffer * 2, height: self.container.calculateAccumulatedFrame().height + buttonBuffer * 2)
        self.container.position = CGPoint(x: 0, y: 1)
        self.containerBackground.size = CGSize(width: self.container.size.width + 2, height: self.container.size.height + 4)
    }
}
