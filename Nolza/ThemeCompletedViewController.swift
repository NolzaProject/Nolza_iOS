//
//  ThemeCompletedViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 26..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class ThemeCompletedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ThemeCompletedViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ThemeCompletedCell else{
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = "Spanish Food"
        
        return cell
    }
}

class ThemeCompletedCell: UICollectionViewCell {
    
    @IBOutlet weak var labelBackground: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelBackground.layer.masksToBounds = true
        labelBackground.layer.cornerRadius = 17
        
        collectionView.dataSource = self
        
        let line1 = UIView()
        line1.frame = CGRect(x: 89, y: 50, width: 33, height: 2)
        line1.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        
        let line2 = UIView()
        line2.frame = CGRect(x: 211, y: 50, width: 33, height: 2)
        line2.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        
        collectionView.addSubview(line1)
        collectionView.addSubview(line2)
        
    }
    
}

extension ThemeCompletedCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themecollectionviewcell", for: indexPath) as? ThemeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.missionImage.image = UIImage(named:"sky")
        cell.missionImage.layer.borderColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).cgColor
        cell.number.text = "\(indexPath.item)"
        cell.missionName.text = "Spicy fried Chicken"
        
        return cell
    }
}
