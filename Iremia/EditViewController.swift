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
    public var item: Task?
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //initalize realm database
    let realm = try! Realm()

    //Completion function when page is done
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        titleField.text = Task().title
        bodyField.text = ""
        
        try! realm.write {
        }
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        //As long as title text is not empty, this saves the values users enter into corresponding variable
        try! realm.write {
        }
        
    
    }
    
    //Function that minimizes keyboard is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
