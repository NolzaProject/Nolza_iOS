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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let text = searchTextField.text{

            if text == "case"{
                setSearchedForm()
            }else{
                setSearchingForm()
            }
        }
    }
    
    func setBasicForm(){
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
        collectionView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(){
        setBasicForm()
        searchTextField.text = ""
        searchTextField.endEditing(true)
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
        print("No.\(indexPath.item)")
    }
}

extension SearchViewController: UICollectionViewDataSource{
    
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
