//
//  AddViewController.swift
//  Iremia
//
//  Created by James Dang on 11/7/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    //Creates fields where users enter values for each field
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //initalize realm database
    private let realm = try! Realm()
    
    //Completion function when page is done
    public var completion: ((String, String, Date) -> Void)?
    
    //background gradient
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        self.view.addSubview(titleField)
        self.view.addSubview(bodyField)
        self.view.addSubview(datePicker)
        
    }
    
    @objc func didTapSave() {
        //As long as title text is not empty, this saves the values users enter into corresponding variable
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text{
            
            let targetDate = datePicker.date
            let uuidString = UUID().uuidString
            //insert task with input data onto database
            realm.beginWrite()
            let newItem = Task()
            newItem.title = titleText
            newItem.body = bodyText
            newItem.date = targetDate
            newItem.id = uuidString
            realm.add(newItem)
            try! realm.commitWrite()

            //Calls completion function with values, which saves each value in a new object in array on ChecklistViewController
            completion?(titleText,bodyText,targetDate)
        }
    }
    
    //Function that minimizes keyboard is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
