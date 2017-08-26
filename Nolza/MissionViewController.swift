//
//  MissionViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 24..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit
import Fusuma

class MissionViewController: Base_Mission {

    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sendImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.frame = CGRect(x: 0, y: -64, width: 375, height: 421)
        collectionView.addSubview(infoView)
        
        let line = UIView()
        line.frame = CGRect(x: 0, y: 358, width: 375, height: 1)
        line.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        collectionView.addSubview(line)
    }
}
extension MissionViewController: FusumaDelegate{
    public func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        //
    }

    
    @IBAction func camearaButtonPressed(_ sender: AnyObject) {
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
        
       performSegue(withIdentifier: "completeSegue", sender: self)
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
        
        if segue.identifier == "completeSegue"
        {
            let destination = segue.destination as! MissionCompleteViewController
            
            destination.receivedImg = sendImage
        }
    }
}

extension MissionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MissionCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.infoImage.image = UIImage(named:"missionIcon\(indexPath.item)")
        cell.infoLabel.text = "Spicy fried Chicken"

        return cell
    }
}

class MissionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var infoImage: UIImageView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
