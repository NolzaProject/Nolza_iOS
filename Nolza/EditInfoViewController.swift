//
//  EditInfoViewController.swift
//  Nolza
//
//  Created by 전한경 on 2017. 8. 30..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    let titles = ["Language","Travle dates","Sign out"]
    
    let contents = ["English","01 - 31, February",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.width / 2
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popVC(animated: true)
    }
}
extension EditInfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension EditInfoViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("NO.\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let result = indexPath.row == 2 ? 100.0 : 60.0
        return CGFloat(result)
    }
}

extension EditInfoViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditInfoTableViewCell else{
            return UITableViewCell()
        }
        cell.title.text = titles[indexPath.row]
        cell.content.text = contents[indexPath.row]
        
        return cell
    }
    
}

class EditInfoTableViewCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
}
