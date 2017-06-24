//
//  WaterMarkUtil.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import Foundation
import UIKit

open class WaterMarkUtil{
    
    
    open class var sharedUtil: WaterMarkUtil {
        struct Singleton {
            static let instance = WaterMarkUtil()
        }
        return Singleton.instance
    }
    
    open func waterMarking(targetView : UIView, waterMarkImage : UIImage, completion : (UIImage)->Void){
        
        
        let copiedView = targetView
        //you can create new view object
        //targetView.copyView()
        
        let imageView = UIImageView.init(image: waterMarkImage)
        
        imageView.frame = CGRect(x:(targetView.frame.size.width - 65.multiplyWidthRatio()),
                                 y:(targetView.frame.size.height - 42.multiplyHeightRatio()),
                                 width: 55.multiplyWidthRatio(),
                                 height: 32.multiplyHeightRatio())
        
        copiedView.addSubview(imageView)
        
        let waterMarkedImage = UIImage(view:copiedView)

        completion(waterMarkedImage)

    }
    
    
    
    
}

extension UIImage{
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

extension UIView
{
    func copyView() -> UIView?
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
}
//save in photoAlbum
//extension UIImage {
//    convenience init(view: UIView) {
//        //UIGraphicsBeginImageContext(view.frame.size)
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//    }
//}
