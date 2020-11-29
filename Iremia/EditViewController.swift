//
//  EditViewController.swift
//  Iremia
//
//  Created by Alvin Phan on 11/24/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
    //Creates fields where users enter values for each field
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //pass through taskID
    var taskID: String = ""
    
    //initalize realm database
    let realm = try! Realm()

    //Completion function when page is done
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        
        //query task item from realmdb
        let myItem = realm.objects(Task.self).filter("id == %@", taskID)
        
        //update existing inputs
        titleField.text = myItem[0].title
        bodyField.text = myItem[0].body
        datePicker.date = myItem[0].date
        
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        //As long as title text is not empty, this saves the values users enter into corresponding variable
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text{
         
            let targetDate = datePicker.date
            
            //query task item from realm database using passed through taskID
            let myItem = realm.objects(Task.self).filter("id == %@", taskID)
            
            //update task item on database
            try! realm.write {
                myItem[0].title = titleText
                myItem[0].body = bodyText
                myItem[0].date = targetDate
            }
        
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    //Function that minimizes keyboard is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
