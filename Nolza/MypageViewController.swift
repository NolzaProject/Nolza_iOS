//
//  MypageViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 30..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {

    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.frame = CGRect(x: 0, y: -64, width: 375, height: 361)
        collectionView.addSubview(infoView)
        
        let line = UIView()
        line.frame = CGRect(x: 0, y: 234, width: 375, height: 1)
        line.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        collectionView.addSubview(line)
        
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.width / 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension MypageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MypageCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.couponImage.image = UIImage(named:"sky")
        
        return cell
    }
}

class MypageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var couponImage: UIImageView!
}
