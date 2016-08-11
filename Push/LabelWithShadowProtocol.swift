//
//  LabelWithShadowProtocol.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 8/11/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

protocol LabelWithShadowProtocol {
    var position: CGPoint { get set }
    /**
     The z-order of the node (used for ordering). Negative z is "into" the screen, Positive z is "out" of the screen. A greater zPosition will sort in front of a lesser zPosition.
     */
    var zPosition: CGFloat { get set }
    var isHidden: Bool { get set }
    
    func setText(_ text: String)
    func setFontSize(_ size: CGFloat)
    func setHorizontalAlignmentMode(_ horizontalAlignmentMode: SKLabelHorizontalAlignmentMode)
    func setVerticalAlignmentMode(_ verticalAlignmentMode: SKLabelVerticalAlignmentMode)
    func setFontColor(_ fontColor: UIColor)
    func setShadowFontColor(_ fontColor: UIColor)
    
    /**
     Calculates the bounding box including all child nodes in parents coordinate system.
     */
    func calculateAccumulatedFrame() -> CGRect
}
