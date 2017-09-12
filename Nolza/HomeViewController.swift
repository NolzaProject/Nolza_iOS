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
    
    var photos: [UIImage] = []
    
    var sendMission: Mission?
    var sendImage: UIImage?
    
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
            destination.receivedImage = sendImage
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

        getImageFromWeb(missions[indexPath.item].imageUrl ?? "") {
            cell.missionImage.image = $0
        }
        cell.number.text = missions[indexPath.item].difficulty ?? ""
        let text = missions[indexPath.item].title ?? ""
        cell.missionName.text = text
        //cell.missionName.text = text.countChars() > 10 ? text : text + "               "
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendMission = missions[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
        sendImage = cell?.missionImage.image
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

extension HomeViewController {
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

extension String{

    func countChars() -> Int{
        return self.characters.count
    }
}
