//
//  UIButton+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import UIKit

extension UIButton{
    
    public func setButton(imageName: String, targetController: NSObject, action: Selector, _ targetView: UIView){
        self.setImage(UIImage(named: imageName), for: .normal)
        self.addTarget(targetController, action: action, for: .touchUpInside)
        targetView.addSubview(self)
    }
    
    
    /*
     버튼을 한줄로
     사용법 : button.setButton(title: "OH", target: self, action: #selector(printAction), size: 20, color: UIColor.mainColor)
     */
    public func setButton(title: String, targetController: NSObject, action: Selector, fontName: String = ".SFUIText", fontSize: CGFloat, color: UIColor,_ targetView: UIView){
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize*widthRatio)
        self.addTarget(targetController, action: action, for: .touchUpInside)
        targetView.addSubview(self)
    }
    
}



