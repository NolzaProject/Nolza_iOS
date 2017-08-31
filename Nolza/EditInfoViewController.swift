//
//  EditInfoViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 30..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit
import Fusuma

class EditInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    let titles = ["Language","Travle dates","Sign out"]
    
    let contents = ["English","01 - 31, February",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.width / 2
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popVC(animated: true)
    }
}

extension EditInfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension EditInfoViewController: FusumaDelegate{
    public func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        //
    }
    
    
    @IBAction func changeProfile(_ sender: AnyObject) {
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
        
        photoView.image = image
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
}

extension EditInfoViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("NO.\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let result = indexPath.row == 2 ? 100.0 : 60.0
        return CGFloat(result)
    }
}

extension EditInfoViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditInfoTableViewCell else{
            return UITableViewCell()
        }
        cell.title.text = titles[indexPath.row]
        cell.content.text = contents[indexPath.row]
        
        return cell
    }
    
}

class EditInfoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
}
