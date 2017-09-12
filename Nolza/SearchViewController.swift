//
//  SearchViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 30..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

enum Search{
    case basic
    case searching
    case searched
}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var resultCount: UILabel!
    
    @IBOutlet var noResultLabel: UILabel!
    
    var nolzaAPI : NolzaAPI!
    
    var missions: [Mission] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var sendMission: Mission?
    var sendImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nolzaAPI = NolzaAPI.init(path: "/missions/description/default", method: .get)
        collectionView.frame = CGRect(x: 0, y: -64, width: 375, height: 682)
        resultCount.frame = CGRect(x: 20, y: 85, width: 98, height: 28)
        noResultLabel.frame = CGRect(x: 151, y: 255, width: 73, height: 22)
        
        collectionView.addSubview(resultCount)
        view.addSubview(noResultLabel)
 
        searchTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
        
        //initial Setting
        setBasicForm()
    }
    
    func textValueChanged(){
        //값들어올때마다 서버요청함
        searchTextField.textAlignment = .left
        if let text = searchTextField.text{

            let path = "/missions/description/"+text
            nolzaAPI.setPath(path: path)
            nolzaAPI.searchMission(completion: {
                if !$0.isEmpty{
                    self.missions = []
                    self.missions = $0
                    self.resultCount.text = "\($0.count) Results"
                    self.setSearchedForm()
                }else{
                    self.setSearchingForm()
                }
            })
        }
    }
    
    func setBasicForm(){
        searchTextField.textAlignment = .center
        searchTextField.frame.size = CGSize(width: 343, height: 30)
        cancelButton.isHidden = true
        collectionView.isHidden = true
        noResultLabel.isHidden = true
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func setSearchingForm(){
        collectionView.isHidden = true
        cancelButton.isHidden = false
        noResultLabel.isHidden = false
        searchTextField.frame.size = CGSize(width: 286, height: 30)
        view.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    }
    
    func setSearchedForm(){
        noResultLabel.isHidden = true
        collectionView.isHidden = false
        collectionView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
//        collectionView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(){
        setBasicForm()
        searchTextField.text = ""
        searchTextField.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchToMissionSegue"
        {
            let destination = segue.destination as! MissionViewController
            
            destination.receivedMission = sendMission
            destination.receivedImage = sendImage
        }
    }
}
extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension SearchViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendMission = missions[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell
        sendImage = cell?.missionImage.image
        performSegue(withIdentifier: "searchToMissionSegue", sender: self)
    }
}

extension SearchViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectionviewcell", for: indexPath) as? HomeCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        getImageFromWeb(missions[indexPath.item].imageUrl ?? "") {
            cell.missionImage.image = $0
        }//UIImage(named:"sky")
        cell.number.text = missions[indexPath.item].difficulty ?? "" //"1"
        cell.missionName.text = missions[indexPath.item].title ?? "" //"Spicy fried Chicken"
        
        
        return cell
    }
}

extension SearchViewController{
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
