//
//  HeartBoostContainer.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/1/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class HeartBoostContainer : SKNode {
    // Hearts
    var heartBoost1: HeartBoostNode?
    var heartBoost2: HeartBoostNode?
    var heartBoost3: HeartBoostNode?
    
    private var _selectedHeartBoost: HeartBoostNode?
    var selectedHeartBoost: HeartBoostNode? {
        get {
            return self._selectedHeartBoost
        }
        set {
            //self.dbScene!.selectedHeartBoost = newValue
            //self._selectedHeartBoost = newValue
        }
    }

    var heartBoostText: SKLabelNode?
    
    // Scene
    weak var dbScene: DBScene?
    
    // Buffer
    var nodeBuffer: CGFloat = ScaleBuddy.sharedInstance.getNodeBuffer()
    
    init(scene: DBScene) {
        super.init()
        
        // Init
        self.dbScene = scene
        
        // Heart Boosts
        self.heartBoost1 = HeartBoostNode(heartBoost: 1, boostCost: HeartBoostCosts.oneHeart.rawValue, container: self)
        self.heartBoost2 = HeartBoostNode(heartBoost: 2, boostCost: HeartBoostCosts.twoHearts.rawValue, container: self)
        self.heartBoost3 = HeartBoostNode(heartBoost: 3, boostCost: HeartBoostCosts.threeHearts.rawValue, container: self)
        
        self.heartBoost1!.position = CGPoint(x: 0 - self.heartBoost1!.size.width - self.nodeBuffer / 2, y: 0)
        self.heartBoost2!.position = CGPoint(x: 0, y: 0)
        self.heartBoost3!.position = CGPoint(x: self.heartBoost2!.position.x + self.nodeBuffer / 2 + self.heartBoost3!.size.width, y: 0)
        
        self.heartBoostText = SKLabelNode(fontNamed: "Avenir-Medium")
        self.updateHeartBoostText(true)
        self.heartBoostText!.fontColor = MerpColors.darkFont
        self.heartBoostText!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.heartBoostText!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.heartBoostText!.position = CGPoint(x: self.heartBoost2!.position.x, y: self.heartBoost2!.position.y - self.heartBoost2!.size.height / 2 - self.heartBoostText!.calculateAccumulatedFrame().size.height/2 - 3)
        
        self.addChild(self.heartBoost1!)
        self.addChild(self.heartBoost2!)
        self.addChild(self.heartBoost3!)
        self.addChild(self.heartBoostText!)
    }
    
    convenience init(scene: DBScene, selectedLevel: Int) {
        self.init(scene: scene)
        
        self.selectHeartByBoost(selectedLevel)
        
        self.updateHeartBoostText(false)
    }
    
    func selectHeartByBoost(_ boost: Int) {
        // Select the heart that matches
        switch (boost) {
        case 1:
            self.selectedHeartBoost = self.heartBoost1
            self.heartBoost1!.boostSelectedNode.isHidden = false
            self.heartBoost2!.boostSelectedNode.isHidden = true
            self.heartBoost3!.boostSelectedNode.isHidden = true
            break
        case 2:
            self.selectedHeartBoost = self.heartBoost2
            self.heartBoost1!.boostSelectedNode.isHidden = true
            self.heartBoost2!.boostSelectedNode.isHidden = false
            self.heartBoost3!.boostSelectedNode.isHidden = true
            break
        case 3:
            self.selectedHeartBoost = self.heartBoost3
            self.heartBoost1!.boostSelectedNode.isHidden = true
            self.heartBoost2!.boostSelectedNode.isHidden = true
            self.heartBoost3!.boostSelectedNode.isHidden = false
            break
        default:
            self.selectedHeartBoost = nil
            self.heartBoost1!.boostSelectedNode.isHidden = true
            self.heartBoost2!.boostSelectedNode.isHidden = true
            self.heartBoost3!.boostSelectedNode.isHidden = true
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHeartBoostText(_ reset: Bool?) {
        if ((reset) == nil || reset == false) && self.selectedHeartBoost != nil {
            if self.selectedHeartBoost!.boostCost > 1 {
                self.heartBoostText!.text = "boost \(self.selectedHeartBoost!.heartBoost) hearts for \(self.selectedHeartBoost!.boostCost) diamonds"
            } else {
                self.heartBoostText!.text = "boost \(self.selectedHeartBoost!.heartBoost) hearts for \(self.selectedHeartBoost!.boostCost) diamond"
            }
            self.heartBoostText!.fontSize = ScaleBuddy.sharedInstance.getDescriptionFontSize()
        } else {
            self.heartBoostText!.text = "select a heart boost"
            self.heartBoostText!.fontSize = round(17 * ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        }
    }
}
