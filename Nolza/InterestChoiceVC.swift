//
//  InterestChoiceVC.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 31..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class InterestChoiceVC: UIViewController {
    var chosenButton: [UIButton] = []
    var chosenResult: [String] = []
    var receivedSet : InitSet?
    var nolzaAPI : NolzaAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
     //서버요청 성공하면 performSegue
        nolzaAPI = NolzaAPI(path: "/users", method: .post, parameters: [
            "duration": receivedSet?.date ?? "",
            "email": receivedSet?.email ?? "",
            "nation": receivedSet?.language ?? "",
            "password": receivedSet?.password ?? "",
            "userName": receivedSet?.name ?? ""
            ])
        nolzaAPI.requestJoin{
            print($0)
        }
        //performSegue(withIdentifier: "initFinishSegue", sender: self)
    }
    
    @IBAction func skipButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "initFinishSegue", sender: self)
    }
}

// @IBAction
extension InterestChoiceVC {
    
    @IBAction func buttonChoice(sender: UIButton) {
        
        let isChosen = chosenButton.index(of: sender) == nil
        sender.backgroundColor = isChosen ? #colorLiteral(red: 0, green: 0.462745098, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sender.setTitleColor(isChosen ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.2411628962, green: 0.7337041497, blue: 0.5889639258, alpha: 1), for: .normal)
        sender.layer.borderWidth = isChosen ? 0 : 1
        
        if isChosen {
            chosenButton.append(sender)
        } else {
            chosenButton.remove(at: chosenButton.index(of: sender)!)
        }
        
        //넘길 값
        chosenResult = chosenButton.flatMap{ $0.currentTitle}
        
        print(chosenResult)
    }
}

extension UIButton {
    
    @IBInspectable var roundedColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

