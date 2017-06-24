//
//  UITabBarController+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController{
    
    // 탭바에서의 네비게이션바의 왼쪽 아이템
    // Navigation bar left item in tabbar
    
    open func setLeftItem(image: UIImage, tintColor: UIColor, target: UIViewController, action :Selector){
        let leftMenuItem = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        leftMenuItem.tintColor = tintColor
        target.navigationItem.setLeftBarButton(leftMenuItem, animated: false)
    }
    
    // 탭바에서의 네비게이션바의 오른쪽 아이템
    // Navigation bar right item in tabbar
    
    open func setRightItem(image: UIImage, tintColor: UIColor, target: UIViewController, action :Selector){
        let rightMemuItem = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        rightMemuItem.tintColor = tintColor
        target.navigationItem.setRightBarButton(rightMemuItem, animated: false)
    }
    
    // 탭바에서의 네비게이션 바 타이틀
    // Navigation bar title in tabbar
    
    open func setTitle(title:String, target: UIViewController){
        target.title = title
    }
    
    // 네비게이션 바 타이틀 폰트 변경
    // Customizing navigation bar title fonts
    
    open func setCustomTitle(font: String, size: CGFloat){
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: font, size: size)!]
    }
    
    // 탭바 색상 변경
    // Change tabbar color
    
    open func changeTabColor(color: UIColor){
        UITabBar.appearance().barTintColor = color
    }
    
    // 탭바 아이템 틴트 색상 변경
    // Change tabbar item tint color
    
    open func changeTabItemColor(color: UIColor){
        UITabBar.appearance().tintColor = color
    }
    
    // 탭바 아이템 추가
    // Add tabbar items
    
    open func addTabbarItem(views: UIViewController...){
        var controllerArray = [UIViewController]()
        for viewControllers in views{
            controllerArray.append(viewControllers)
        }
        self.viewControllers = controllerArray
    }
    
    // 탭바 아이템 설정
    // Set tabbar item
    
    open func setTabbarItem(view: UIViewController,title: String?, image: UIImage?, tag: Int){
        let item = UITabBarItem(title: title, image: image, selectedImage: nil)
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0) // 중앙정렬
        item.tag = tag
        view.tabBarItem = item
    }
    
}
