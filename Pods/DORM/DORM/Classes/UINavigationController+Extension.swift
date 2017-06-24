//
//  UINavigationController+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    
    // 다음 화면을 위한 함수
    // It is function for segue
    
    open func pushVC(_ viewController: UIViewController, animated: Bool){
        self.pushViewController(viewController, animated: animated)
        viewController.view.backgroundColor = UIColor.white
    }
    
    // 이전 화면으로 돌아가는 함수
    // It is function for dismiss
    
    open func popVC(animated: Bool){
        self.popViewController(animated: animated)
    }
    
    // 네비게이션 바 왼쪽 아이템
    // Navigation bar left item
    
    open func setLeftItem(image: UIImage, tintColor: UIColor, target: UIViewController, action :Selector){
        let leftMenuItem = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        leftMenuItem.tintColor = tintColor
        target.navigationItem.setLeftBarButton(leftMenuItem, animated: false)
    }
    
    // 네비게이션 바 오른쪽 아이템
    // Navigation bar right item
    
    open func setRightItem(image: UIImage, tintColor: UIColor, target: UIViewController, action :Selector){
        let rightMemuItem = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        rightMemuItem.tintColor = tintColor
        target.navigationItem.setRightBarButton(rightMemuItem, animated: false)
    }
    
    // 네비게이션 바 타이틀 설정
    // Set navigation bar title
    
    open func setTitle(title:String, target: UIViewController){
        target.title = title
    }
    
    // 네비게이션 바 타이틀 폰트 변경
    // Customizing navigation bar title fonts
    
    open func setCustomTitle(font: String, size: CGFloat){
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: font, size: size)!]
    }
    
    // 네비게이션 바 숨기기
    // hide navigation bar
    
    open func hideNavigationBar(){
        self.isNavigationBarHidden = true
    }
    
    // 네비게이션 바 보이기
    // reveal navigation bar
    
    open func revealNavigationBar(){
        self.isNavigationBarHidden = false
    }
}
