//
//  HomeViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 7. 15..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var nolzaAPI : NolzaAPI!
    
    @IBOutlet weak var themeView: UIView!

    @IBOutlet weak var collectionview: UICollectionView!
    
    var missions: [Mission] = []{
        didSet{
            collectionview.reloadData()
        }
    }
    
    var sendMission: Mission?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nolzaAPI = NolzaAPI.init(path: "/missions", method: .get)
        nolzaAPI.getMissions{
            self.missions = $0
        }
        
        themeView.frame = CGRect(x: 0, y: -64, width: 375, height: 232)
        collectionview.addSubview(themeView)
    }
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "missionSegue"
        {
            let destination = segue.destination as! MissionViewController
            
            destination.receivedMission = sendMission
        }
    }
}

extension HomeViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectionviewcell", for: indexPath) as? HomeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.missionImage.image = UIImage(named:"sky")
        cell.number.text = missions[indexPath.item].difficulty ?? ""
        cell.missionName.text = missions[indexPath.item].title ?? ""
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendMission = missions[indexPath.item]
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
