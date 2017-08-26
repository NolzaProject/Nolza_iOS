//
//  MissionCompleteViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 25..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

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
            
            let leftItem = UIBarButtonItem(title: "< home", style: .plain, target: self, action: #selector(backToHome))
            navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    
    @IBAction func sharing(_ sender: UIButton) {
        
    }
    
    func backToHome(){
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}
