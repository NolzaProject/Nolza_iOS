//
//  UILabel+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import UIKit

extension UILabel{
    
    /*
     라벨 지정 (set label)
     사용법(usage) :  label.setLabel(text: "hi", align: .center, size: 40, target: self.view)
     */
    
    public func setLabel(text: String, align: NSTextAlignment, fontName: String = ".SFUIText", fontSize: CGFloat, color: UIColor = UIColor.black,targetView: UIView){
        self.text = text
        self.textAlignment = align
        self.font = UIFont(name: fontName, size: fontSize*widthRatio)
        targetView.addSubview(self)
    }
    
    // 행간 (line spacing)
    
    public func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
    
    // 자간 (chharacter spacing)
    
    public func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
    }
    
}
