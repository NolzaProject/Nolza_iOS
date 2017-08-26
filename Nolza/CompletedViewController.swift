//
//  CompletedViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 26..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class CompletedViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.alpha = 1
        collectionView.alpha = 0
    }
    
    @IBAction func selectCompletedMission(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.alpha = 1
                self.collectionView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.alpha = 0
                self.collectionView.alpha = 1
            })
        default:
            break
        }
    }
}

extension CompletedViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectionviewcell", for: indexPath) as? HomeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.missionImage.image = UIImage(named:"sky")
        cell.missionImage.layer.borderWidth = 2
        cell.missionImage.layer.borderColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).cgColor
        cell.number.text = "1"
        cell.missionName.text = "Spicy fried Chicken"
        
        
        return cell
    }
}
