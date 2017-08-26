//
//  MissionCompleteViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 25..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class MissionCompleteViewController: Base_Mission {

    var receivedImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = receivedImg
    }
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}
