//
//  ThemeViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 20..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class CompleteCheck{
    static var themeMissionCheck = false
    static var missionCheck = false
}

class ThemeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var labelBackground: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var initialContentOffset = CGPoint()
    
    var numberOfSection: [Int] = []
    
    var hiddenFlag = false
    
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
            titleLabel.text = themeTitles[0]
        }
    }
    
    var themeModel: [[Mission]] = []
    
    var sendMissions: [Mission] = []
    var sendImages: [UIImage] = []
    var sendTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nolzaAPI = NolzaAPI.init(path: "/missions/category/default", method: .get, header: ["":""])
        
//        nolzaAPI.getThemeMissions{
//            self.themeTitles = $0
//            //self.missions = $1
//        }
        
        nolzaAPI.getThemeMissions(themeTitle: { (titles) in
            self.themeTitles = titles
        }) { (missions) in
            self.missions = missions
        }

        labelBackground.layer.masksToBounds = true
        labelBackground.layer.cornerRadius = 17
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        
        drawLine()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.x > self.initialContentOffset.x {
            // 오른쪽
            pageControl.currentPage += 1
        } else if collectionView.contentOffset.x < self.initialContentOffset.x{
            pageControl.currentPage -= 1
        }
        
        titleLabel.text = themeTitles[pageControl.currentPage]
    }
    
    func sectionArray(){
    
//        let result = themeModel.count % 3 == 0 ? themeModel.count / 3 : themeModel.count / 3 + 1
//        
//        for i in 0..<result {
//            
//            if i == themeModel.count / 3, themeModel.count % 3 != 0{
//                self.numberOfSection.append(themeModel.count % 3)
//            }else{
//                self.numberOfSection.append(3)
//            }
//        }
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
    
    func drawLine(){
        var locX = 109
        var locX2 = 231
        for i in 0..<numberOfSection.count{
            let line1 = UIView()
            line1.frame = CGRect(x: locX, y: 50, width: 33, height: 2)
            line1.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6901960784, blue: 0.5176470588, alpha: 1)
            
            let line2 = UIView()
            line2.frame = CGRect(x: locX2, y: 50, width: 33, height: 2)
            line2.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.6901960784, blue: 0.5176470588, alpha: 1)
            
            collectionView.addSubview(line1)
            collectionView.addSubview(line2)
            
            locX += 375 - i
            locX2 += 375 - i
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "themeMissionSegue"
        {
            let destination = segue.destination as! ThemeMissionViewController
            
            destination.receivedMissions = sendMissions
            destination.receivedImages = sendImages
            destination.receivedTitle = sendTitle
        }
    }
}

extension ThemeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendMissions = themeModel[indexPath.section]
        
        let cell = collectionView.visibleCells.map{
            $0 as! ThemeCollectionViewCell
        }
        switch indexPath.section {
        case 0:
            sendImages.insert(cell[0].missionImage.image!, at: 0)
            sendImages.insert(cell[1].missionImage.image!, at: 1)
            sendImages.insert(cell[2].missionImage.image ?? UIImage(named:"sky")!, at: 2)
            sendTitle = themeTitles[0]
        case 1:
            sendImages.insert(cell[1].missionImage.image!, at: 0)
            sendImages.insert(cell[2].missionImage.image!, at: 1)
            sendImages.insert(cell[0].missionImage.image!, at: 2)
            sendTitle = themeTitles[1]
        case 2:
            sendImages.insert(cell[0].missionImage.image!, at: 0)
            sendImages.insert(cell[1].missionImage.image!, at: 1)
            sendImages.insert(cell[2].missionImage.image!, at: 2)
            sendTitle = themeTitles[2]
        default:
            return
        }
        
        performSegue(withIdentifier: "themeMissionSegue", sender: self)
    }
}

extension ThemeViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSection[section]
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themecollectionviewcell", for: indexPath) as? ThemeCollectionViewCell else{
            return UICollectionViewCell()
        }
//        print("idx : \(indexPath.item)")
//        print("section : \(indexPath.section)")
        
        getImageFromWeb(themeModel[indexPath.section][indexPath.item].imageUrl ?? "") {
            cell.missionImage.image = $0
        }
        cell.number.text = themeModel[indexPath.section][indexPath.item].difficulty ?? ""
        cell.missionName.text = themeModel[indexPath.section][indexPath.item].title ?? ""
        
        return cell
    }
}

class ThemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var missionImage: UIImageView!
    
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var missionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        missionImage.layer.masksToBounds = true
        number.layer.masksToBounds = true
        
        missionImage.layer.cornerRadius = missionImage.width / 2
        missionImage.layer.borderWidth = 2
        missionImage.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.6901960784, blue: 0.5176470588, alpha: 1).cgColor
        
        number.layer.cornerRadius = number.width / 2
    }
    
}

extension ThemeViewController {
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
