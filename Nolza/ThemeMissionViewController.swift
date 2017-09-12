//
//  ThemeMissionViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 24..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit
import Fusuma

class ThemeMissionViewController: Base_Mission {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var item1: UIButton!
    
    @IBOutlet weak var item2: UIButton!
    
    @IBOutlet weak var item3: UIButton!
    
    @IBOutlet weak var checkButton: UIButton!
    
    var sendImage: UIImage!
    
    var pressedItemNumber: Int = 0
    
    var receivedMissions: [Mission] = []
    var receivedImages: [UIImage] = []
    var receivedTitle: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 375, height: 700)
        
        titleLabel.text = receivedTitle
        
        item1.setImage(receivedImages[0], for: .normal)
        item1.layer.masksToBounds = true
        item1.layer.cornerRadius = item1.width / 2
        item1.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        missionLabel.text = receivedMissions[0].title
        difficultyLabel.text = receivedMissions[0].difficulty
        contentLabel.text = receivedMissions[0].descript
        photoView.image = receivedImages[0]
        
        item2.setImage(receivedImages[1], for: .normal)
        item2.layer.masksToBounds = true
        item2.layer.cornerRadius = item2.width / 2
        
        item3.setImage(receivedImages[2], for: .normal)
        item3.layer.masksToBounds = true
        item3.layer.cornerRadius = item3.width / 2
        
        let line = UIView()
        line.frame = CGRect(x: 0, y: 291, width: 375, height: 1)
        line.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        scrollView.addSubview(line)
        
//        if CompleteCheck.themeMissionCheck{
//            checkButton.setImage(#imageLiteral(resourceName: "icnDone"), for: .normal)
//        }
//        print("$$$##ID: \(receivedMissions[1].id)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CompleteCheck.themeMissionCheck, pressedItemNumber == 1, receivedMissions[1].id == 5{
            checkButton.setImage(#imageLiteral(resourceName: "icnDone"), for: .normal)
        }else{
            checkButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        }
    }
    //각각 아이템의 상태에따라 UI 변경
    @IBAction func item1Pressed(_ sender: UIButton) {
        removeAllTransform()
        UIView.animate(withDuration: 0.5) {
            self.item1.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        pressedItemNumber = 0
        changeData(number: 0)
    }
    
    @IBAction func item2Pressed(_ sender: UIButton) {
        removeAllTransform()
        UIView.animate(withDuration: 0.5) {
            self.item2.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        pressedItemNumber = 1
        changeData(number: 1)
    }
    
    @IBAction func item3Pressed(_ sender: UIButton) {
        removeAllTransform()
        UIView.animate(withDuration: 0.5) {
            self.item3.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        pressedItemNumber = 2
        changeData(number: 2)
    }
    
    func removeAllTransform(){
        self.item1.transform = .identity
        self.item2.transform = .identity
        self.item3.transform = .identity
    }
    
    func changeData(number: Int){
        missionLabel.text = receivedMissions[number].title
        difficultyLabel.text = receivedMissions[number].difficulty
        contentLabel.text = receivedMissions[number].descript
        photoView.image = receivedImages[number]
        
        if CompleteCheck.themeMissionCheck, number == 1, receivedMissions[number].id == 5{
            checkButton.setImage(#imageLiteral(resourceName: "icnDone"), for: .normal)
        }else{
            checkButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
            
        }
    }
}

extension ThemeMissionViewController: FusumaDelegate{
    public func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        //
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusumaCropImage = false
        fusumaTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        fusumaBackgroundColor = UIColor.white
        
        self.present(fusuma, animated: false, completion: nil)
        
    }
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        //서버 요청
        //파일 업로드 후 성공시 이미지 넘김.
        sendImage = image
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
        
        performSegue(withIdentifier: "completeThemeSegue", sender: self)
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "completeThemeSegue"
        {
            let destination = segue.destination as! MissionCompleteViewController
            
            destination.receivedImg = sendImage
            destination.receivedTitle = receivedMissions[pressedItemNumber].title ?? ""
            destination.receivedDifficulty = receivedMissions[pressedItemNumber].difficulty ?? ""
            destination.receivedDepartLocation = .ThemeMission
        }
    }
}

extension ThemeMissionViewController {
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }
        task.resume()
    }
}


