//
//  Base_Mission.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 26..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class Base_Mission: UIViewController {

    @IBOutlet weak var missionLabel: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        difficultyLabel.layer.masksToBounds = true
        difficultyLabel.layer.cornerRadius = difficultyLabel.width / 2
        
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.width / 2
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 12
    }
}
