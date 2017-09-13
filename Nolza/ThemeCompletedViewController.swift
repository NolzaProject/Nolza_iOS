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
        return 1
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
    
    var nolzaAPI : NolzaAPI!
    
    var missions: [Mission] = []{
        didSet{
            var a = -3
            for _ in 0..<3{
                a += 3
                makeArray(start: a, end: a+3)
            }
            sectionArray()
            print(numberOfSection)
            collectionView.reloadData()
        }
    }
    var themeTitles: [String] = []{
        didSet{
            titleLabel.text = themeTitles[2]
        }
    }
    
    var numberOfSection: [Int] = []
    
    var themeModel: [[Mission]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nolzaAPI = NolzaAPI.init(path: "/missions/category/default", method: .get, header: ["":""])
        
        nolzaAPI.getThemeMissions(themeTitle: { (titles) in
            self.themeTitles = titles
        }) { (missions) in
            self.missions = missions
        }
        
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
    
    func sectionArray(){
        numberOfSection = [3,3,3]
    }
    
    func makeArray(start: Int, end: Int){
        var arr : [Mission] = []
        let start = start
        let end = end
        
        for i in start..<end{
            arr.append(missions[i])
        }
        themeModel.append(arr)
    }
}

extension ThemeCompletedCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themecollectionviewcell", for: indexPath) as? ThemeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.missionImage.layer.borderColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1).cgColor
//        cell.missionImage.image = UIImage(named:"sky")
//        cell.number.text = "\(indexPath.item)"
//        cell.missionName.text = "Spicy fried Chicken"

        getImageFromWeb(themeModel[2][indexPath.item].imageUrl ?? "") {
            cell.missionImage.image = $0
        }
        cell.number.text = themeModel[2][indexPath.item].difficulty ?? ""
        cell.missionName.text = themeModel[2][indexPath.item].title ?? ""
        
        return cell
    }
}

extension ThemeCompletedCell {
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
