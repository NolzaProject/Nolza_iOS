//
//  UIColor+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import UIKit

extension UIColor {
    
    // 메인 색상을 지정하는 함수이다
    // It is function for set main color in your app
    public static var mainColor:UIColor {
        get{
            return UIColor(r: 68, g: 67, b: 68, alpha: 1)
        }set(value) {
            self.mainColor = value
        }
    }
    
    convenience init(r: CGFloat,g: CGFloat,b: CGFloat,alpha: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
}
