//
//  UIView+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import UIKit

/*
 
 테스트 iPhone 을 7에 맞춰두고 디자인가이드에 맞게 작업한다.
 Set the test iPhone to 7 and work with the design guide.
 
 */

let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))

var heightRatio = userDevice.userDeviceHeight()
var widthRatio = userDevice.userDeviceWidth()


extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            self.frame.origin.x = value * widthRatio
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            self.frame.origin.y = value * heightRatio
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(value) {
            self.frame.size.width = value * widthRatio
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(value) {
            self.frame.size.height = value * heightRatio
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(value){
            self.layer.borderWidth = value
        }
    }
    
    
    // 프레임에 맞게 ver 1.
    // initialization frame using ratio
    
    public func rframe(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.frame = CGRect(x: x * widthRatio, y: y * heightRatio, width: width * widthRatio, height: height * heightRatio)
    }
    
    //프레임에 맞게 생성자로 ver 2.
    
    convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.init(frame: CGRect(x: x * widthRatio, y: y * heightRatio, width: width * widthRatio, height: height * heightRatio))
    }
    
    
    //중앙정렬 ver 1.
    
    public func rcenter(y: CGFloat,width: CGFloat,height: CGFloat, targetWidth: CGFloat){
        self.frame = CGRect(x: targetWidth*widthRatio/2 - width/2*widthRatio, y: y*heightRatio, width: width*widthRatio, height: height*heightRatio)
    }
    
    //중앙정렬 생성자로 ver 2.
    
    convenience init(y: CGFloat, width: CGFloat, height: CGFloat, targetWidth: CGFloat){
        self.init(frame: CGRect(x: targetWidth*widthRatio/2 - width/2*widthRatio, y: y*heightRatio, width: width*widthRatio, height: height*heightRatio))
    }
    
    //뷰에 가득 채우기
    
    public func fillCenter(){
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    /*
     버튼 영역 확장 (enlarge your button area)
     사용법 : view.enlargeArea(target: self, action: #selector(function), view: view, size: size)
     */
    
    public func enlargeArea(target: NSObject, action: Selector ,view: UIView ,size: CGFloat){
        let widthSize = size * widthRatio
        let heightSize = size * heightRatio
        let extensionView = UIView(frame: CGRect(x: self.x - widthSize, y: self.y - heightSize, width: self.width + widthSize*2, height: self.height + heightSize*2))
        extensionView.backgroundColor = UIColor.clear
        extensionView.addAction(target: target, action: action)
        view.addSubview(extensionView)
    }
    
    
    /*
     라벨이나 이미지도 버튼이 되게 (Make label and image to button)
     사용법 : view.addAction(target:self ,action: #selector(function))
     */
    
    public func addAction(target: NSObject,action: Selector){
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /*
     롱 클릭 이벤트
     */
    
    public func addLongAction(target: NSObject, action: Selector){
        let longGestureRecognizer = UILongPressGestureRecognizer(target: target, action: action)
        longGestureRecognizer.minimumPressDuration = 0.5
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longGestureRecognizer)
    }
    
    
    /*
     뷰에 원 그리기 (Draw circle in your view)
     사용법 : self.view.drawCircle(startX: 100, startY: 100, radius: 50, color: UIColor.black)
     */
    
    public func drawCircle(startX: CGFloat,startY:CGFloat,radius: CGFloat,color: UIColor){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: startX*widthRatio,y: startY*heightRatio), radius: radius*widthRatio, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        self.layer.addSublayer(shapeLayer)
    }
    
    /*
     뷰에 선 그리기 (Draw line in your view)
     사용법 : self.view.drawLine
     */
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, color: UIColor){
        var line: UIView!
        line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height*heightRatio))
        line.backgroundColor = color
        self.addSubview(line)
    }
    
    
}


/*
 뷰 안의 모든 오브젝트들의 사이즈를 변경함
 */
extension UIViewController{
    
    public func allObjectResizing(targetView: UIView){
        for idx in 0..<targetView.subviews.count{
            targetView.subviews[idx].frame.origin.x *= widthRatio
            targetView.subviews[idx].frame.origin.y *= heightRatio
            targetView.subviews[idx].frame.size.width *= widthRatio
            targetView.subviews[idx].frame.size.height *= heightRatio
        }
        print(targetView.subviews)
    }
}

extension Int{
    public func multiplyWidthRatio() -> CGFloat{
        return CGFloat(self) * widthRatio
    }
    public func multiplyHeightRatio() -> CGFloat{
        return CGFloat(self) * heightRatio
    }
}


extension CGFloat{
    public func multiplyWidthRatio() -> CGFloat{
        return self * widthRatio
    }
    public func multiplyHeightRatio() -> CGFloat{
        return self * heightRatio
    }
}

extension CGFloat{
    public func remultiplyWidthRatio() -> CGFloat{
        return self / widthRatio
    }
    public func remultiplyHeightRatio() -> CGFloat{
        return self / heightRatio
    }
}



