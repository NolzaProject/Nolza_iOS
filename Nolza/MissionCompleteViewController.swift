//
//  MissionCompleteViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 25..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit
import DORM

enum DepartLocation{
    case Mission
    case ThemeMission
}

class MissionCompleteViewController: Base_Mission {

    var receivedImg: UIImage!
    var receivedDepartLocation: DepartLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = receivedImg
        
        if receivedDepartLocation == .Mission{
            let leftItem = UIBarButtonItem(barButtonSystemItem:.reply, target: self, action: #selector(backToHome))
            leftItem.tintColor = #colorLiteral(red: 0.2078431373, green: 0.6901960784, blue: 0.5176470588, alpha: 1)
            navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    
    @IBAction func sharing(_ sender: UIButton) {
        InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: receivedImg, instagramCaption: "caption", view: self.view)
    }
    
    func backToHome(){
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}
