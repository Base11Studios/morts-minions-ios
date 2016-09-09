//
//  DBButton.swift
//  Push
//
//  Created by Dan Bellinski on 10/21/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class DBButton : SKSpriteNode {
    var pressedButtonImage: SKTexture?
    var unpressedButtonImage: SKTexture?
    var isPressed: Bool = false
    //var unPressedLabel: MultilineLabelWithShadow?
    var unPressedLabel: LabelWithShadowProtocol?
    var pressedLabel: LabelWithShadowProtocol?
    //var pressedLabel: MultilineLabelWithShadow?
    var unPressedIcon: SKSpriteNode?
    var pressedIcon: SKSpriteNode?
    var disabledNode: SKSpriteNode?
    var isDisabled: Bool = false
    var forceDisabled: Bool = false {
        didSet {
            self.checkDisabled()
        }
    }
    var allowAnywhereOnScreen = false
    weak var dbScene: DBScene?
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, dbScene: DBScene?) {
        super.init(texture: texture, color: color, size: size)
        self.dbScene = dbScene
    }
    
    // Used for IAP buttons or custom ones
    init(buttonSize: DBButtonSize, dbScene: DBScene?, atlas: SKTextureAtlas) {
        self.dbScene = dbScene
        
        var buttonName: String
        //var buttonPressedName: String
        
        // icon
        self.disabledNode = SKSpriteNode(texture: atlas.textureNamed("button_large_disabled"))
        self.disabledNode!.alpha = 0.22
        
        switch(buttonSize) {
        case .extrasmall:
            buttonName = "button_extrasmall"
            //buttonPressedName = "pressed_button_extrasmall"
            self.disabledNode!.setScale(0.45)
        case .small:
            buttonName = "button_small"
            //buttonPressedName = "pressed_button_small"
            self.disabledNode!.setScale(0.6)
        case .medium:
            buttonName = "button_medium"
            //buttonPressedName = "pressed_button_medium"
            self.disabledNode!.setScale(0.80)
        case .large:
            buttonName = "button_large"
            //buttonPressedName = "pressed_button_large"
        case .flag:
            buttonName = "flag"
        case .square_Medium:
            buttonName = "square_button_medium"
        case .square_Large:
            buttonName = "button_level_selector"
            self.disabledNode = SKSpriteNode(texture: atlas.textureNamed("button_level_selector_disabled"))
            self.disabledNode!.alpha = 0.22
        }
        
        // Create a texture from the passed image
        let passedTexture = atlas.textureNamed(buttonName)
        super.init(texture: passedTexture, color: UIColor(), size: passedTexture.size())
        
        self.pressedButtonImage = atlas.textureNamed(buttonName)
        self.unpressedButtonImage = atlas.textureNamed(buttonName)
        
        // Disabled info
        self.checkDisabled()
        self.addChild(disabledNode!)
        
        // Want to be able to touch this
        self.isUserInteractionEnabled = true
    }
    
    // Used for text buttons all across app
    init(iconName: String, pressedIconName: String?, buttonSize: DBButtonSize, dbScene: DBScene?, atlas: SKTextureAtlas) {
        self.dbScene = dbScene
        
        var buttonName: String
        var buttonPressedName: String
        
        // icon
        if pressedIconName != nil {
            self.pressedIcon = SKSpriteNode(texture: atlas.textureNamed(pressedIconName!))
        } else {
            self.pressedIcon = SKSpriteNode(texture: atlas.textureNamed(iconName))
        }
        
        self.unPressedIcon = SKSpriteNode(texture: atlas.textureNamed(iconName))
        self.disabledNode = SKSpriteNode(texture: atlas.textureNamed("button_large_disabled"))
        self.disabledNode!.alpha = 0.22
        
        switch(buttonSize) {
        case .extrasmall:
            buttonName = "button_extrasmall"
            buttonPressedName = "pressed_button_extrasmall"
            self.unPressedIcon!.setScale(0.45)
            self.disabledNode!.setScale(0.45)
            self.pressedIcon!.setScale(0.435)
        case .small:
            buttonName = "button_small"
            buttonPressedName = "pressed_button_small"
            self.unPressedIcon!.setScale(0.6)
            self.disabledNode!.setScale(0.6)
            self.pressedIcon!.setScale(0.58)
        case .medium:
            buttonName = "button_medium"
            buttonPressedName = "pressed_button_medium"
            self.unPressedIcon!.setScale(0.80)
            self.disabledNode!.setScale(0.80)
            self.pressedIcon!.setScale(0.78)
        case .large:
            buttonName = "button_large"
            buttonPressedName = "pressed_button_large"
        case .flag:
            buttonName = "flag"
            buttonPressedName = "flag_pressed"
            self.disabledNode = SKSpriteNode(texture: atlas.textureNamed("flag_disabled"))
            self.disabledNode!.alpha = 0.22
            self.unPressedIcon!.setScale(1.0)
            self.disabledNode!.setScale(1.0)
            self.pressedIcon!.setScale(0.9)
        case .square_Medium:
            buttonName = "square_button_medium"
            buttonPressedName = "square_button_medium"
            self.disabledNode = SKSpriteNode(texture: atlas.textureNamed("square_button_medium_lock"))
            self.disabledNode!.alpha = 0.22
            self.unPressedIcon!.setScale(1)
            self.disabledNode!.setScale(1)
            self.pressedIcon!.setScale(1)
        case .square_Large:
            buttonName = "button_level_selector"
            buttonPressedName = "button_level_selector"
            self.disabledNode = SKSpriteNode(texture: atlas.textureNamed(""))
            self.disabledNode!.alpha = 0.22
            self.unPressedIcon!.setScale(1)
            self.disabledNode!.setScale(1)
            self.pressedIcon!.setScale(1)
        }
        
        // Create a texture from the passed image
        let passedTexture = atlas.textureNamed(buttonName)
        super.init(texture: passedTexture, color: UIColor(), size: passedTexture.size())
        
        self.pressedButtonImage = atlas.textureNamed(buttonPressedName)
        self.unpressedButtonImage = atlas.textureNamed(buttonName)
        
        self.addChild(self.pressedIcon!)
        self.pressedIcon?.isHidden = true
        
        self.addChild(self.unPressedIcon!)
        
        // Disabled info
        self.checkDisabled()
        self.addChild(disabledNode!)
        
        // Want to be able to touch this
        self.isUserInteractionEnabled = true
        
        // If this is a flag, move icons up a big
        if buttonSize == .flag {
            self.pressedIcon!.position = CGPoint(x: 0, y: 5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
            self.unPressedIcon!.position = CGPoint(x: 0, y: 5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        }
    }
    
    init(iconName: String?, labelText: String?, fontSize: CGFloat?, dbScene: DBScene?, backgroundAtlas: SKTextureAtlas, iconAtlas: SKTextureAtlas) {
        self.dbScene = dbScene
        
        // Create a texture from the passed image
        let passedTexture = backgroundAtlas.textureNamed("skillbutton")
        super.init(texture: passedTexture, color: UIColor(), size: passedTexture.size())
        
        self.pressedButtonImage = backgroundAtlas.textureNamed("skillbuttonpressed")
        self.unpressedButtonImage = backgroundAtlas.textureNamed("skillbutton")
        
        // Want to be able to touch this
        self.isUserInteractionEnabled = true
        
        if labelText != nil && fontSize != nil {
            // Regular label
            self.unPressedLabel = MultilineLabelWithShadow(fontNamed: "Avenir-Medium", scene: self.dbScene!, darkFont: false, borderSize: 1)
            self.unPressedLabel!.setFontSize(fontSize! / 2)
            self.unPressedLabel!.setText(labelText!)
            self.unPressedLabel!.position = CGPoint(x: 0, y: self.size.height / 2 + self.unPressedLabel!.calculateAccumulatedFrame().size.height - ScaleBuddy.sharedInstance.getNodeBuffer() * 0.5)
            self.unPressedLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.unPressedLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            self.unPressedLabel!.isHidden = false
            self.unPressedLabel!.zPosition = 1.0
            
            // Pressed label
            self.pressedLabel = MultilineLabelWithShadow(fontNamed: "Avenir-Medium", scene: self.dbScene!, darkFont: false, borderSize: 2)
            self.pressedLabel!.setFontSize(fontSize! * 0.9)
            self.pressedLabel!.setText(labelText!)
            self.pressedLabel!.position = CGPoint(x: 0, y: self.size.height / 2 + self.pressedLabel!.calculateAccumulatedFrame().size.height - ScaleBuddy.sharedInstance.getNodeBuffer() * 0.5)
            self.pressedLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.pressedLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            self.pressedLabel!.isHidden = true
            self.pressedLabel!.zPosition = 1.0
            
            self.addChild(self.unPressedLabel as! SKNode)
            self.addChild(self.pressedLabel as! SKNode)
        }
        
        if iconName != nil {
            self.pressedIcon = SKSpriteNode(texture: iconAtlas.textureNamed(iconName!))
            self.pressedIcon!.size = CGSize(width: self.pressedIcon!.size.width * 0.9, height: self.pressedIcon!.size.height * 0.9)
            self.unPressedIcon = SKSpriteNode(texture: iconAtlas.textureNamed(iconName!))
            
            self.addChild(self.pressedIcon!)
            self.pressedIcon?.isHidden = true
            
            self.addChild(self.unPressedIcon!)
        }
        
        // Disabled info
        self.disabledNode = SKSpriteNode(texture: nil, color: UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 0.4), size: self.size)
        self.disabledNode?.zPosition = 5
        self.checkDisabled()
        self.addChild(disabledNode!)
    }
    
    // Used for world nodes
    init(buttonName: String, labelText: String?, fontSize: CGFloat?, dbScene: DBScene?, atlas: SKTextureAtlas) {
        self.dbScene = dbScene
        
        // Create a texture from the passed image
        let passedTexture = atlas.textureNamed(buttonName)
        super.init(texture: passedTexture, color: UIColor(), size: passedTexture.size())
        
        self.pressedButtonImage = atlas.textureNamed(buttonName)
        self.unpressedButtonImage = atlas.textureNamed(buttonName)
        
        // Want to be able to touch this
        self.isUserInteractionEnabled = true
        
        if labelText != nil && fontSize != nil {
            // Regular label
            self.unPressedLabel = LabelWithShadow(darkFont:false)
            self.unPressedLabel!.setFontSize(fontSize!)
            self.unPressedLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.unPressedLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            self.unPressedLabel!.isHidden = false
            self.unPressedLabel!.zPosition = 1.0
            self.unPressedLabel!.setText(labelText!)
            self.unPressedLabel!.position = CGPoint(x: 0, y: 0)
            
            // Pressed label
            self.pressedLabel = LabelWithShadow(darkFont:false)
            self.pressedLabel!.setText(labelText!)
            self.pressedLabel!.setFontSize(fontSize!)
            self.pressedLabel!.position = CGPoint(x: 0, y: 0)
            self.pressedLabel!.setHorizontalAlignmentMode(SKLabelHorizontalAlignmentMode.center)
            self.pressedLabel!.setVerticalAlignmentMode(SKLabelVerticalAlignmentMode.center)
            self.pressedLabel!.isHidden = true
            self.pressedLabel!.zPosition = 1.0
            
            self.addChild(self.unPressedLabel as! SKNode)
            self.addChild(self.pressedLabel as! SKNode)
        }
        
        // Disabled info
        self.disabledNode = SKSpriteNode(texture: nil, color: UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 0.4), size: self.size)
        self.disabledNode?.zPosition = 5
        self.checkDisabled()
        self.addChild(disabledNode!)
    }
    
    // Used for cooldown
    init(name: String, pressedName: String, dbScene: DBScene?, atlas: SKTextureAtlas) {
        self.dbScene = dbScene
        
        // Create a texture from the passed image
        let passedTexture = atlas.textureNamed(name)
        super.init(texture: passedTexture, color: UIColor(), size: passedTexture.size())
        
        self.pressedButtonImage = atlas.textureNamed(pressedName)
        self.unpressedButtonImage = atlas.textureNamed(name)
        
        // Want to be able to touch this
        self.isUserInteractionEnabled = true
    }
    
    // Nothingness
    init(dbScene: DBScene?) {
        self.dbScene = dbScene
        super.init(texture: SKTexture(), color: UIColor(), size: CGSize())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeAttributes() {
        if self.pressedButtonImage == nil {
            self.pressedButtonImage = self.texture
        }
        if self.unpressedButtonImage == nil {
            self.unpressedButtonImage = self.texture
        }
    }
    
    func checkDisabled() {
        if self.forceDisabled {
            self.disabledNode?.isHidden = false
        } else {
            self.disabledNode?.isHidden = !isDisabled
        }
    }
    
    func pressButton() {
        self.texture = self.pressedButtonImage
        // Label
        if self.pressedLabel != nil {
            self.pressedLabel!.isHidden = false
        }
        if self.unPressedLabel != nil {
            self.unPressedLabel!.isHidden = true
        }
        // Icon
        if self.pressedIcon != nil {
            self.pressedIcon!.isHidden = false
        }
        if self.unPressedIcon != nil {
            self.unPressedIcon!.isHidden = true
        }
        self.isPressed = true
    }
    
    func releaseButton() {
        self.texture = self.unpressedButtonImage
        // Label
        if self.pressedLabel != nil {
            self.pressedLabel!.isHidden = true
        }
        if self.unPressedLabel != nil {
            self.unPressedLabel!.isHidden = false
        }
        // Icon
        if self.pressedIcon != nil {
            self.pressedIcon!.isHidden = true
        }
        if self.unPressedIcon != nil {
            self.unPressedIcon!.isHidden = false
        }
        self.isPressed = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*var buttonPressed = false
        
        // For loop on touches and set boolean on which buttons contain a point
        for touch: UITouch in touches {
            
            // Get the location of the touch
            let location: CGPoint = touch.locationInNode(self.parent!)
            
            if self.containsPoint(location) {
                buttonPressed = true
            }
        }*/
        
        // Button Touch Starts
        if (self.isPressed == false && !self.isDisabled && !self.forceDisabled) {
            self.pressButton()
            touchesBeganAction()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // For loop on touches and set boolean on which buttons contain a point
        for touch: UITouch in touches {
            
            // Get the location of the touch
            let location: CGPoint = touch.location(in: self.parent!)
            let previousLocation: CGPoint = touch.previousLocation(in: self.parent!)
            
            if self.isPressed && (!self.contains(location) && self.contains(previousLocation) && !self.allowAnywhereOnScreen) {
                self.releaseButton()
                self.touchesReleasedAction()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*var buttonPressed = false
        
        // For loop on touches and set boolean on which buttons contain a point
        for touch: UITouch in touches {
            
            // Get the location of the touch
            let location: CGPoint = touch.locationInNode(self.parent!)
            
            if self.containsPoint(location) {
                buttonPressed = true
            }
        }*/
        
        // Press button
        if self.isPressed && !self.isDisabled && !self.forceDisabled {
            self.releaseButton()
            playSound()
            touchesEndedAction()
            self.checkDisabled()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPressed {
            self.releaseButton()
            self.touchesReleasedAction()
            self.checkDisabled()
        }
    }
    
    func touchesBeganAction() {
        
    }
    
    func touchesEndedAction() {
        
    }
    
    func touchesReleasedAction() {
        
    }
    
    func playSound() {
        self.dbScene!.viewController!.playButtonSound()
    }
}
