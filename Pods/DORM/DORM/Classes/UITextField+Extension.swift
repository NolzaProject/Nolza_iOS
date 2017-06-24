//
//  UITextField+Extension.swift
//  DORM
//
//  Created by Dormmate on 2017. 5. 4..
//  Copyright © 2017 Dormmate. All rights reserved.
//

import UIKit

private var targetView: UIView!
private var emojiFlag: Int = 0

extension UITextField: UITextFieldDelegate{
    
    
    public func setTextField(fontName: String = ".SFUIText", size: CGFloat, placeholderText: String = "NO_PLACEHOLDER", _ targetView: UIView){
        
        if placeholderText != "NO_PLACEHOLDER"{
            self.placeholder = placeholderText
        }
        self.font = UIFont(name: fontName, size: size*widthRatio)
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.delegate = self
        targetView.addSubview(self)
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
     키보드 올라갈 때 화면 올림
     사용법 : textField.setKeyboardNotification(target: self.view)
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     textField.endEditing(true)
     textField.setEmojiFlag()
     }
     */
    
    
    public func setKeyboardNotification(target: UIView!){
        
        targetView = target
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    public func setEmojiFlag(){
        emojiFlag = 0
    }
    
    
    public func keyboardWillShow(notification:NSNotification,target: UIView) {
        adjustingHeight(show: false, notification: notification)
    }
    
    public func keyboardWillHide(notification:NSNotification) {
        targetView.y = 0
    }
    
    public func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = -(keyboardFrame.height)
        let changeInEmoji : CGFloat = -(42 * heightRatio)
        let initialLanguage = self.textInputMode?.primaryLanguage

        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            
            if self.textInputMode?.primaryLanguage == nil{
                
                targetView.frame.origin.y += changeInEmoji
                emojiFlag = 1
                
            } else if self.textInputMode?.primaryLanguage == initialLanguage && emojiFlag == 0 {
                
                targetView.frame.origin.y += changeInHeight
                
            } else if self.textInputMode?.primaryLanguage == initialLanguage && emojiFlag == 1 {
                
                targetView.frame.origin.y += (42 * heightRatio)
                emojiFlag = 0
                
            } else{
                
                targetView.frame.origin.y += changeInHeight
                emojiFlag = 0
                
            }
        })
        
        //범위 밖 충돌 현상 또는 3rd party keyboard 버그 발생시
        if targetView.frame.origin.y < -258.0 || keyboardFrame.height == 0.0{
            
            targetView.frame.origin.y = -216.0
        }
        
    }
    
       
}



