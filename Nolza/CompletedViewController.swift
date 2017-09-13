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
    
    var nolzaAPI : NolzaAPI!
    
    var missions: [Mission] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nolzaAPI = NolzaAPI.init(path: "/missions/description/d", method: .get)
        nolzaAPI.searchMission {
            self.missions = $0
        }
        
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
        return missions.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectionviewcell", for: indexPath) as? HomeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.missionImage.layer.borderWidth = 2
        cell.missionImage.layer.borderColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).cgColor
        getImageFromWeb(missions[indexPath.item].imageUrl ?? "") {
            cell.missionImage.image = $0
        }
        cell.number.text = missions[indexPath.item].difficulty ?? ""
        cell.missionName.text = missions[indexPath.item].title ?? ""
        
        
        return cell
    }
}

extension CompletedViewController{
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
