//
//  ExerciseViewController.swift
//  Iremia
//
//  Created by Benjamin Shiao on 11/12/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITextFieldDelegate {
    
    //Creates fields where users enter values for each field
    //@IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //Completion function when page is done
    public var completion: ((String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyField.delegate = self
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        //As long as title text is not empty, this saves the values users enter into corresponding variable
        if let bodyText = bodyField.text{
            
            let targetDate = datePicker.date
            
            //Calls completion function with values, which saves each value in a new object in array on ChecklistViewController
            completion?(bodyText,targetDate)
        }
    }
    
    //Function that minimizes keyboard is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
