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
    var receivedTitle: String = ""
    var receivedDifficulty: String = ""
    var receivedDepartLocation: DepartLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = receivedImg
        missionLabel.text = receivedTitle
        difficultyLabel.text = receivedDifficulty
        
        if receivedDepartLocation == .Mission{
            
            let leftItem = UIBarButtonItem(image: UIImage(named:"close"), style: .plain, target: self, action: #selector(backToHome))
            navigationItem.leftBarButtonItem = leftItem
            CompleteCheck.missionCheck = true
        }else{
            CompleteCheck.themeMissionCheck = true
        }
    }
    
    
    @IBAction func sharing(_ sender: UIButton) {
        InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: receivedImg, instagramCaption: "caption", view: self.view)
    }
    
    func backToHome(){
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}
