//
//  JoinViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 24..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    var receivedSet : InitSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "joinSegue"
        {
            let destination = segue.destination as! InterestChoiceVC
            receivedSet?.name = nameLabel.text!
            receivedSet?.email = emailLabel.text!
            receivedSet?.password = passwordLabel.text!
            
            destination.receivedSet = receivedSet
        }
    }
}
