//
//  VerticalSKScrollingNode.swift
//  Merp
//
//  Created by Dan Bellinski on 10/28/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class VerticalScrollingSkillNode : SKNode, UIGestureRecognizerDelegate {
    var size: CGSize

    // The selected skill
    var selectedSkillNode: ScrollingSkillNode?

    var isMoving: Bool = false
    var gestureRecognizer: UIPanGestureRecognizer?
    var yOffset: CGFloat = 0
    let kScrollDuration: Double = 0.3
    let buttonBuffer: CGFloat = 27.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    var nodeBuffer: CGFloat = 6.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var bufferSize: CGFloat = 0.0
    var numberChildren: Int = 0
    
    var rowHeight: CGFloat = 0
    
    var firstJumpUpgradeSkill: ScrollingSkillNode?
    var firstSkill: ScrollingSkillNode?
    
    // The char scene
    weak var charScene: CharacterSkillScene?
    
    init(size: CGSize, scene: CharacterSkillScene) {
        self.size = size
        
        self.bufferSize = floor(ScaleBuddy.sharedInstance.getScaleAmount() * 2.0)
        
        self.charScene = scene
        
        // Super initializer
        super.init()
        
        self.yOffset = self.calculateAccumulatedFrame().origin.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addChild(_ node: SKNode) {
        // SSNode
        let skillRowNode = node as! ScrollingSkillNodeRow
        
        // First child node of row
        if skillRowNode.firstSkillNode != nil {
            
            // Set row height
            self.rowHeight = skillRowNode.firstSkillNode!.nodeContent!.size.height
            
            // These will be added horizontally because they make up 1 row
            let yOffset = (self.size.height/2 + skillRowNode.firstSkillNode!.nodeContent!.size.height/2 + self.nodeBuffer /*(skillRowNode.nodeBuffer * (2.0 / self.bufferSize))*/)
            let xOffset = -self.size.width/2 + skillRowNode.firstSkillNode!.nodeContent!.size.width/2 + self.nodeBuffer
            //let extraOffset = -CGFloat(self.numberChildren) * self.nodeBuffer // TODO use this by adding to the Y position below, but then need to adjust all of the calculations like minYPosition to account for it
            skillRowNode.position = CGPoint(x: xOffset, y: -(self.rowHeight + self.nodeBuffer) * CGFloat(self.numberChildren) + yOffset)
            
            self.numberChildren += 1
            skillRowNode.rowNumber = self.numberChildren
            
            if self.children.count == 0 {
                self.setInitialSelectedNode(skillRowNode.firstSkillNode!)
                self.firstJumpUpgradeSkill = skillRowNode.secondSkillNode!
                self.firstSkill = skillRowNode.firstSkillNode!
            }
        }
        
        super.addChild(node)
        self.yOffset = self.calculateAccumulatedFrame().origin.y // TODO can this be used to eliminate the need to space children?
    }
    
    func maxYPosition() -> CGFloat {
        var minPosition: CGFloat = minYPosition()
        
        if (self.rowHeight + self.nodeBuffer) * CGFloat(self.children.count) + self.nodeBuffer > self.size.height {
            minPosition += (self.rowHeight + self.nodeBuffer) * CGFloat(self.children.count) + self.nodeBuffer - self.size.height
        }

        return minPosition
    }
    
    func minYPosition() -> CGFloat {
        return 0 - self.rowHeight - self.nodeBuffer * 2
    }
    
    func scrollToTop() {
        self.position = CGPoint(x: 0, y: self.minYPosition())
    }
    
    func scrollToBottom() {
        self.position = CGPoint(x: 0, y: self.maxYPosition())
    }
    
    func enableScrollingOnView(_ view: UIView) {
        if self.gestureRecognizer == nil {
            self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(VerticalScrollingSkillNode.handlePanFrom(_:)))
            self.gestureRecognizer!.delegate = self
            view.addGestureRecognizer(self.gestureRecognizer!)
        }
    }
    
    func disableScrollingOnView(_ view: UIView) {
        if self.gestureRecognizer != nil {
            view.removeGestureRecognizer(self.gestureRecognizer!)
            self.gestureRecognizer = nil
        }
    }
    
    @objc func handlePanFrom(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began {
            self.removeAllActions()
        }
        else {
            if recognizer.state == UIGestureRecognizerState.changed {
                self.isMoving = true
                
                var translation: CGPoint = recognizer.translation(in: recognizer.view)
                translation = CGPoint(x: translation.x, y: -translation.y)
                self.panForTranslation(translation)
                recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            }
            else {
                if recognizer.state == UIGestureRecognizerState.ended {
                    let velocity: CGPoint = recognizer.velocity(in: recognizer.view)
                    let pos: CGPoint = self.position
                    
                    let p: CGPoint = CGPoint(x: velocity.x * CGFloat(kScrollDuration), y: velocity.y * CGFloat(kScrollDuration))
                    var newPos: CGPoint = CGPoint(x: pos.x, y: pos.y - p.y / 2.0)
                    
                    newPos = self.constrainStencilNodesContainerPosition(newPos)
                    let moveTo: SKAction = SKAction.move(to: newPos, duration: kScrollDuration)
                    moveTo.timingMode = SKActionTimingMode.easeOut
                    
                    self.run(SKAction.sequence([moveTo]), withKey: "centerOnNode")
                }
            }
        }
    }
    
    func panForTranslation(_ translation: CGPoint) {
        self.position = CGPoint(x: self.position.x, y: self.position.y + translation.y)
    }
    
    func constrainStencilNodesContainerPosition(_ position: CGPoint) -> CGPoint {
        var retval: CGPoint = position
        retval.x = self.position.x
        retval.y = max(self.minYPosition(), retval.y)
        retval.y = min(self.maxYPosition(), retval.y)
        return retval
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let grandParent: SKNode = self.parent!.parent!
        
        let touchLocation: CGPoint = touch.location(in: grandParent)
        if !self.parent!.frame.contains(touchLocation) {
            return false
        }
        return true
    }
    
    func setInitialSelectedNode(_ selectedNode: ScrollingSkillNode) {
        self.selectedSkillNode?.selected(false)
        self.selectedSkillNode = selectedNode
        self.selectedSkillNode!.selected(true)
    }
    
    func setSelectedNode(_ selectedNode: ScrollingSkillNode) {
        self.setInitialSelectedNode(selectedNode)
        
        // Make sure the character selection screen is updated with the new skill stats
        charScene?.reselectSkillNode()
    }
    
    func setSkillNodeOpacity() {
        for rowNode in self.children as! [ScrollingSkillNodeRow]{
            for node in rowNode.children {
                if let skillNode = node as? ScrollingSkillNode {
                   skillNode.checkSkillPurchased()
                }
            }
        }
    }
}
