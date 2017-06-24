//
//  ViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 5. 21..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit
import DORM
import MobileCoreServices

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
     var newMedia: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraAppBtn = UIImageView()
        cameraAppBtn.borderWidth = 1
        cameraAppBtn.rframe(x: 70, y: 70, width: 100, height: 100)
        cameraAppBtn.addAction(target: self, action: #selector(cameraAppExecuted))
        
        let photoLibraryAppBtn = UIImageView()
        photoLibraryAppBtn.borderWidth = 1
        photoLibraryAppBtn.rframe(x: 170, y: 170, width: 100, height: 100)
        photoLibraryAppBtn.addAction(target: self, action: #selector(photoLibraryAppExecuted))
        
        view.addSubview(cameraAppBtn)
        view.addSubview(photoLibraryAppBtn)
        
        
        view.backgroundColor = UIColor.cyan
        
        addParallaxToView(vw: view)
        
        // 애플리케이션이 실행되고 있는 디바이스에 카메라가 있는지 체크
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cameraAppExecuted(){
    
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // UIImagePickerController 인스턴스를 생성하고 cameraViewController를 객체의 델리게이트로 설정
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera           // 미디어 소스는 카메라로 정의
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]               // 동영상은 지원하지 않으므로 사진으로만 설정
            imagePicker.allowsEditing = false
            //imagePicker.showsCameraControls = true
            //imagePicker.
            
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = true     // 이 사진이 새로 만들어진 것이며 카메라 롤에 있던 사진이 아님을 공지
        }
    }
    
    func photoLibraryAppExecuted(){
        
        // Hide the keyboard.
        //textView.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        
        
        //
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            //Image.image = image
            
            // 새로 찍은 이미지일 경우 앨범에 저장 처리
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }else if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
                // 비디오 지원을 위한 코드
            }
        }
        
        
        
    }
    
    
    func image(_ image:UIImage, didFinishSavingWithError error:NSErrorPointer?, contextInfo:UnsafeRawPointer){
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }


}

