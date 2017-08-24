//
//  ThemeViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 20..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 17
    }
}
