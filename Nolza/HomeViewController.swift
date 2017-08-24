//
//  HomeViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 7. 15..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var themeView: UIView!

    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeView.frame = CGRect(x: 0, y: -64, width: 375, height: 232)
        collectionview.addSubview(themeView)
    }
    
}

extension HomeViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectionviewcell", for: indexPath) as? HomeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.missionImage.image = UIImage(named:"sky")
        cell.number.text = "1"
        cell.missionName.text = "Spicy fried Chicken"
        
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "missionSegue", sender: self)
    }
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var missionImage: UIImageView!
    
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var missionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        missionImage.layer.masksToBounds = true
        number.layer.masksToBounds = true
        
        missionImage.layer.cornerRadius = missionImage.width / 2
        number.layer.cornerRadius = number.width / 2
    }
    
}
