//
//  HorizontalSKScrollingNode.swift
//  Push
//
//  Created by Dan Bellinski on 10/24/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

class ScrollingLevelNodeRow : SKNode, UIGestureRecognizerDelegate {
    var size: CGSize
    var levelSelected: Int = 1
    weak var levelSelectedNode: ScrollingLevelNode?
    var isMoving: Bool = false
    var gestureRecognizer: UIPanGestureRecognizer?
    var xOffset: CGFloat = 0
    let kScrollDuration: Double = 0.3
    let buttonBuffer: CGFloat = 27.0 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    // # levels
    var numberOfLevels: Int = 0
    var worldName: String = "earth"
    
    // Scene
    weak var dbScene: DBScene?
    
    init(size: CGSize, worldName: String, scene: DBScene) {
        self.size = size
        self.worldName = worldName
        self.dbScene = scene
        
        // Super initializer
        super.init()
        
        self.xOffset = self.calculateAccumulatedFrame().origin.x
        
        // Set the level selected to the last played level on the game data
        self.levelSelected = GameData.sharedGameData.getSelectedCharacterData().getLastPlayedLevelByWorld(worldName)
        if (self.levelSelected < 1) {
            self.levelSelected = GameData.sharedGameData.getSelectedCharacterData().getAdjustedLevelNumberByWorld(worldName, level: 1)
        }
        
        // TODO need to move to the node for last played level??
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addChild(_ node: SKNode) {
        if self.children.count + 1 == self.levelSelected {
            self.levelSelectedNode = (node as! ScrollingLevelNode)
        }
        super.addChild(node)
        self.xOffset = self.calculateAccumulatedFrame().origin.x
    }
    
    func minXPosition() -> CGFloat {
        let minPosition: CGFloat = -(self.calculateAccumulatedFrame().size.width + self.xOffset) + self.levelSelectedNode!.levelSelectionBackground.size.width / 2.0 + self.buttonBuffer
        return minPosition
    }
    
    func maxXPosition() -> CGFloat {
        return 0
    }
    
    func scrollToLeft() {
        self.position = CGPoint(x: self.maxXPosition(), y: 0)
    }
    
    func scrollToRight() {
        self.position = CGPoint(x: self.minXPosition(), y: 0)
    }
    
    func enableScrollingOnView(_ view: UIView?) {
        if self.gestureRecognizer == nil && view != nil {
            self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ScrollingLevelNodeRow.handlePanFrom(_:)))
            self.gestureRecognizer!.delegate = self
            
            // Add to scene
            self.dbScene!.gestureRecognizers.append(self.gestureRecognizer!)
            
            view?.addGestureRecognizer(self.gestureRecognizer!)
        }
    }
    
    func disableScrollingOnView(_ view: UIView?) {
        if self.gestureRecognizer != nil {
            view?.removeGestureRecognizer(self.gestureRecognizer!)
            
            // Remove from scene
            let dbScene = self.scene! as! DBScene
            let idx = dbScene.gestureRecognizers.index(of: self.gestureRecognizer!)
            dbScene.gestureRecognizers.remove(at: idx!)
            
            self.gestureRecognizer?.delegate = nil
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
                self.levelSelectedNode!.displayLevelDetails(false)
                
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
                    var newPos: CGPoint = CGPoint(x: pos.x + p.x / 2.0, y: pos.y)
                    newPos = self.constrainStencilNodesContainerPosition(newPos)
                    let moveTo: SKAction = SKAction.move(to: newPos, duration: kScrollDuration)
                    moveTo.timingMode = SKActionTimingMode.easeOut
                    
                    let moveToNearestChild = SKAction.run({
                        [weak self] in
                        
                        if self != nil {
                            var closestChild: ScrollingLevelNode? = nil
                            
                            for node: ScrollingLevelNode in self?.children as! [ScrollingLevelNode] {
                                if closestChild == nil || abs(fabs(self!.position.x) - fabs(closestChild!.position.x)) > fabs(fabs(self!.position.x) - fabs(node.position.x)) {
                                    closestChild = node
                                }
                                
                            }
                            let endPanAction: SKAction = SKAction.run({
                                [weak self] in
                                
                                if self != nil {
                                    self?.isMoving = false
                                    self?.levelSelectedNode = closestChild!
                                    self?.levelSelected = closestChild!.levelNumber
                                    self?.displayLevelDetails(closestChild!.levelNumber)
                                    
                                    SoundHelper.sharedInstance.playSound(self!, sound: SoundType.Click)
                                }
                                })
                            let doMove: SKAction = SKAction.move(to: CGPoint(x: -closestChild!.position.x, y: 0), duration: self!.kScrollDuration)
                            doMove.timingMode = SKActionTimingMode.easeOut
                            self?.run(SKAction.sequence([doMove, endPanAction]))
                        }
                        })
                    self.run(SKAction.sequence([moveTo, moveToNearestChild]), withKey: "centerOnNode")
                }
            }
        }
    }
    
    func panForTranslation(_ translation: CGPoint) {
        self.position = CGPoint(x: self.position.x + translation.x, y: self.position.y)
    }
    
    func constrainStencilNodesContainerPosition(_ position: CGPoint) -> CGPoint {
        var retval: CGPoint = position
        retval.y = self.position.y
        retval.x = max(retval.x, self.minXPosition())
        retval.x = min(retval.x, self.maxXPosition())
        return retval
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let grandParent: SKNode = self.parent!.parent!
        
        /*
         if grandParent == nil {
         grandParent = self.parent!
         }*/
        
        let touchLocation: CGPoint = touch.location(in: grandParent)
        if !self.parent!.frame.contains(touchLocation) {
            return false
        }
        return true
    }
    
    func moveToNode(_ node: ScrollingLevelNode, immediately: Bool) {
        var duration: Double = kScrollDuration
        if immediately {
            duration = 0
        }
        
        self.isMoving = true
        self.levelSelectedNode!.displayLevelDetails(false)
        
        let endMoveAction: SKAction = SKAction.run({
            [weak self] in
            
            if self != nil {
                self?.isMoving = false
                self?.levelSelectedNode = node
                self?.levelSelected = node.levelNumber
                self?.displayLevelDetails(node.levelNumber)
                self?.isHidden = false
                (self?.dbScene! as! LevelSelectionScene).revealLevels()
            }
            })
        let doMove: SKAction = SKAction.move(to: CGPoint(x: -node.position.x, y: 0), duration: duration)
        if !immediately {
            doMove.timingMode = SKActionTimingMode.easeOut
        } else {
            doMove.timingMode = SKActionTimingMode.linear
        }
        self.run(SKAction.sequence([doMove, endMoveAction]))
    }
    
    func displayLevelDetails(_ level: Int) {
        // Loop through all the nodes and set display to false except the one that is passed
        
        for node: ScrollingLevelNode in self.children as! [ScrollingLevelNode] {
            if node.levelNumber == level {
                node.displayLevelDetails(true)
            } else {
                node.displayLevelDetails(false)
            }
            
        }
    }
}
