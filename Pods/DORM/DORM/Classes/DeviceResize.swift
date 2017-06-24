//
//  BaseView.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import UIKit

/*
 
 아이폰의 화면 비율에 맞게 위치와 높이, 너비를 조정해주는 클래스이다.
 
 It is a class that adjusts the position, height and width according to the aspect ratio of the iPhone.
 
 */


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
}

struct DeviceType
{
    static let IPHONE_4 = (width:Float(320.0), height:Float(480.0))
    static let IPHONE_5 = (width:Float(320.0), height:Float(568.0))
    static let IPHONE_SE = (width:Float(320.0), height:Float(568.0))
    static let IPHONE_6 = (width: Float(375.0), height:Float(667.0))
    static let IPHONE_6_P = (width: Float(414.0), height:Float(736.0))
    static let IPHONE_7 = (width: Float(375.0), height:Float(667.0))
    static let IPHONE_7_P = (width: Float(414.0), height:Float(736.0))
}



class DeviceResize {
    
    var testDevice : (width: Float, height: Float) = (width: 0,height: 0)
    var userDevice : (width: Float, height: Float) = (width: 0,height: 0)
    
    
    init(testDeviceModel: (width: Float, height: Float),userDeviceModel: (width: Float, height: Float)){
        
        testDevice = modelName(model :testDeviceModel)!
        userDevice = modelName(model :userDeviceModel)!
        
    }
    
    func modelName(model :(width: Float,height:Float)) -> (width: Float, height: Float)?{
        let modelNameList : [(width: Float, height: Float)] = [
            DeviceType.IPHONE_4,
            DeviceType.IPHONE_5,
            DeviceType.IPHONE_SE,
            DeviceType.IPHONE_6,
            DeviceType.IPHONE_6_P,
            DeviceType.IPHONE_7,
            DeviceType.IPHONE_7_P,
            ]
        for modelName in modelNameList {
            if modelName.height == model.height{
                return modelName
            }
        }
        return nil
    }
    
    func userDeviceHeight() -> CGFloat{
        
        let heightRatio = CGFloat(self.userDevice.height / self.testDevice.height)
        
        return heightRatio
    }
    
    func userDeviceWidth() -> CGFloat{
        let widthRatio = CGFloat(self.userDevice.width / self.testDevice.width)
        
        return widthRatio
    }
}


