//
//  LanguageChoiceVC.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 31..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

enum Country: String {
    
    case England
    case China
    case Japan
    case Germany
    case Russia
    case Norway
    
    var name: String {
        switch self {
        case .England:
            return "English"
        case .China:
            return "中國語"
        case .Japan:
            return "日本語"
        case .Germany:
            return "das Deutsche"
        case .Russia:
            return "русский"
        case .Norway:
            return "norsk"
        }
    }
}

class LanguageChoiceVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let country: [Country] = [.England, .China, .Japan, .Germany, .Russia , .Norway]
    
    var chosenCell: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension LanguageChoiceVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return country.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LanguageCell
        cell.layer.borderWidth = indexPath.item == chosenCell ? 2 : 0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.languageLabel.text = country[indexPath.item].name
        return cell
    }
}

extension LanguageChoiceVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenCell = indexPath.item
    }
}


class LanguageCell: UICollectionViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
}

