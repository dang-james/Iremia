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
    public var completion: ((String, String, Date) -> Void)?
    
    //background gradient
    @IBOutlet weak var backgroundGradientView: UIView!

    
    //Load existing task title, body, date
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
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        titleField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        bodyField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        titleField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bodyField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(titleField)
        self.view.addSubview(bodyField)
        self.view.addSubview(datePicker)
        
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    //Saves edited task
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
            //Calls completion function with values to create a new notification for edited task
            completion?(titleText,bodyText,targetDate)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    //Function that minimizes keyboard is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
