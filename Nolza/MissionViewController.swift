//
//  MissionViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 24..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class MissionViewController: UIViewController {

    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.frame = CGRect(x: 0, y: -64, width: 375, height: 421)
            collectionView.addSubview(infoView)
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.width / 2
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 12
        
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
        
        cell.infoImage.image = UIImage(named:"home")
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
