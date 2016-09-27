//
//  DAMultilineLabelNode.swift
//
//  Created by Will Hankinson on 9/10/15.
//
//  Ported from https://github.com/downrightsimple/DSMultilineLabelNode
//  an Obj-C version of the same thing
//
//
//  Main quirk is that you must add it to the scene for it to grab the scene bounds
//  before you set any of the text properties.
//
//  ORIGINAL HEADER WITH COPYRIGHT NOTICE OF MODIFIED CODE:
//  DSMultilineLabelNode.m
//  DSMultilineLabelNode
//
//  Created by Chris Allwein on 2/12/14.
//  Copyright (c) 2014 Downright Simple. All rights reserved.
//
//  This software is licensed under an MIT-style license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import SpriteKit

class DSMultilineLabelNode : SKSpriteNode
{
    private var _text = ""
    private var _fontColor = SKColor.white
    private var _fontName = "Avenir"
    private var _fontSize = CGFloat(round(32 * ScaleBuddy.sharedInstance.getGameScaleAmount(false)))
    private var _horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    private var _verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
    private var _paragraphSpacing = CGFloat(0.0);
    private var _paragraphWidth = CGFloat(0)
    weak private var dbScene: DBScene?
    
    init() {
        super.init(texture: SKTexture(), color: UIColor(), size: CGSize())
    }
    
    init(scene: DBScene)
    {
        super.init(texture: nil, color: UIColor.green, size: CGSize(width: 0, height: 0))
        self.dbScene = scene
        retexture()
    }
    
    convenience init(fontName:String, scene: DBScene)
    {
        self.init(scene: scene)
        
        self.fontName = fontName
    }
    
    static func labelNodeWithFontNamed(_ fontName:String, scene: DBScene) -> DSMultilineLabelNode
    {
        return DSMultilineLabelNode(fontName: fontName, scene: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func retexture()
    {
        if let new_text_image = imageFromText(_text)
        {
            let new_texture = SKTexture(image: new_text_image)
            
            texture = new_texture
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    func imageFromText(_ text:String) -> UIImage?
    {
        let paragraph_style = NSMutableParagraphStyle()
        paragraph_style.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph_style.alignment = horizontalNSTextAlignment
        paragraph_style.lineSpacing = _paragraphSpacing;
        paragraph_style.maximumLineHeight = _fontSize + (3.5 * ScaleBuddy.sharedInstance.getGameScaleAmount(false));
        
        var font = UIFont(name: _fontName, size: _fontSize)
        if (font == nil)
        {
            font = UIFont(name: "Helvetica", size: _fontSize);
        }
        
        let text_attributes = NSMutableDictionary()
        text_attributes.setObject(font!, forKey: NSFontAttributeName as NSCopying)
        text_attributes.setObject(paragraph_style, forKey: NSParagraphStyleAttributeName as NSCopying)
        text_attributes.setObject(_fontColor, forKey: NSForegroundColorAttributeName as NSCopying)
        
        //var style = NSMutableParagraphStyle()
        //style.paragraphSpacingBefore = 0.0
        //text_attributes.setObject(style, forKey: NSParagraphStyleAttributeName)
        
        if(self.dbScene == nil)
        {
            return nil
        }
        
        if(_paragraphWidth == 0)
        {
            _paragraphWidth = self.dbScene!.size.width
        }
        
        let texture_size = CGSize(width: _paragraphWidth, height: self.dbScene!.size.height)
        var texture_rect = (text as NSString).boundingRect(with: texture_size,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: (text_attributes as! [String : AnyObject]),
            context: nil
        )
        
        //iOS7 uses fractional size values.  So we needed to ceil it to make sure we have enough room for display.
        texture_rect.size = CGSize(width: ceil(texture_rect.size.width), height: ceil(texture_rect.size.height))
        
        if(texture_rect.size.width == 0 || texture_rect.size.height == 0)
        {
            return nil
        }
        
        size = texture_rect.size
        
        UIGraphicsBeginImageContextWithOptions(texture_rect.size, false, 0)
        (text as NSString).draw(in: texture_rect, withAttributes: (text_attributes as! [String : AnyObject]))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private var horizontalNSTextAlignment:NSTextAlignment
        {
            switch(_horizontalAlignmentMode)
            {
            case .center:
                return NSTextAlignment.center
            case .left:
                return NSTextAlignment.left
            case .right:
                return NSTextAlignment.right
            }
    }
    
    var fontColor:SKColor
        {
        get
        {
            return _fontColor
        }
        set(value)
        {
            _fontColor = value
            retexture()
        }
    }
    
    var fontName:String
        {
        get
        {
            return _fontName
        }
        set(value)
        {
            _fontName = value
            retexture()
        }
    }
    
    var fontSize:CGFloat
        {
        get
        {
            return _fontSize
        }
        set(value)
        {
            _fontSize = value
            retexture()
        }
    }
    
    var paragraphWidth:CGFloat
        {
        get
        {
            return _paragraphWidth
        }
        set(value)
        {
            _paragraphWidth = value
            retexture()
        }
    }
    
    var horizontalAlignmentMode:SKLabelHorizontalAlignmentMode
        {
        get
        {
            return _horizontalAlignmentMode
        }
        set(value)
        {
            _horizontalAlignmentMode = value
            retexture()
        }
    }
    
    var verticalAlignmentMode:SKLabelVerticalAlignmentMode
        {
        get
        {
            return _verticalAlignmentMode
        }
        set(value)
        {
            _verticalAlignmentMode = value
            retexture()
        }
    }
    
    var text:String
        {
        get
        {
            return _text
        }
        set(value)
        {
            if _text != value {
                _text = value
                retexture()
            }
        }
    }
    
    
    
}
