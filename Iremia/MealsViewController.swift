//
//  MealsViewController.swift
//  Iremia
//
//  Created by Benjamin Shiao on 11/12/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

//create Meals reminder class for database
class MealsReminder: Object {
    @objc dynamic var body: String = ""
    @objc dynamic var date: Date = Date()
}

class MealsViewController: UIViewController, UITextFieldDelegate {
    
    //Creates fields where users enter values for each field
    //@IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    //Completion function when page is done
    public var completion: ((String, Date) -> Void)?
    
    //initialize realm
    private let realm = try! Realm()
    //this array stores all past mealsReminders locally
    var mealsReminders = [MealsReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyField.delegate = self
        
        //intialize the body field text if no notifications have been saved yet
        bodyField.text = "Enter meals reminder description"
        
        //populate local mealsReminders array with reminders from the database
        mealsReminders = realm.objects(MealsReminder.self).map({ $0 })
        
        //if the user has already save a past meals reminder
        if(mealsReminders.count > 0){
            //set meals reminder page to show most recently saved body and date
            bodyField.text = mealsReminders[mealsReminders.count-1].body
            datePicker.date = mealsReminders[mealsReminders.count-1].date
        }
        
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        //return to previous page
        self.navigationController?.popToRootViewController(animated: true)
        
        //this saves the values users enter into corresponding variable
        if let bodyText = bodyField.text{
            let targetDate = datePicker.date
            
            //create an MealsReminder with user set values and save it onto the database
            realm.beginWrite()
            let newMealsReminder = MealsReminder()
            newMealsReminder.body = bodyText
            newMealsReminder.date = targetDate
            realm.add(newMealsReminder)
            try! realm.commitWrite()
            
            //Calls completion function with values
            completion?(bodyText,targetDate)
        }
    }
    
    //Function that minimizes keyboard is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
