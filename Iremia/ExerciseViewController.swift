//
//  ExerciseViewController.swift
//  Iremia
//
//  Created by Benjamin Shiao on 11/12/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

//create exercise reminder class for database
class ExerciseReminder: Object {
    @objc dynamic var body: String = ""
    @objc dynamic var date: Date = Date()
}

class ExerciseViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var backgroundGradientView: UIView!
    
    //Creates fields where users enter values for each field
    //@IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    //Completion function when page is done
    public var completion: ((String, Date) -> Void)?
    
    //initialize realm
    private let realm = try! Realm()
    //this array stores all past exerciseReminders locally
    var exerciseReminders = [ExerciseReminder]()
    
    override func viewDidLoad() {
        //base page with default inputs/directions
        super.viewDidLoad()
        bodyField.delegate = self
        bodyField.attributedPlaceholder = NSAttributedString(string: "Enter exercise reminder description", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        
        //populate local exerciseReminders array with reminders from the database
        exerciseReminders = realm.objects(ExerciseReminder.self).map({ $0 })
        
        //if the user has already save a past exercise reminder
        if(exerciseReminders.count > 0){
            //set exercise reminder page to show most recently saved body and date
            bodyField.text = exerciseReminders[exerciseReminders.count-1].body
            datePicker.date = exerciseReminders[exerciseReminders.count-1].date
        }
        
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        
        //background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
       

        //adds the elements onto page
        self.view.addSubview(bodyField)
        self.view.addSubview(datePicker)
        self.view.addSubview(fieldLabel)
        self.view.addSubview(dateLabel)
    }
    
    @objc func didTapSave() {
        //Creates an alert to notify user that inputs have been saved.
        let saveAlert = UIAlertController(title: "Saved", message: "Your wellness notification has been saved.", preferredStyle: .alert)
        
        //Button to dismiss alert and calls the save function
        saveAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             self.save()
        }))
        self.present(saveAlert, animated: true, completion: nil)
    }
    
    //function to save wellness reminder in database and create notification
    func save() {
        //return to previous page
        self.navigationController?.popToRootViewController(animated: true)
        
        //this saves the values users enter into corresponding variable
        if let bodyText = bodyField.text{
            let targetDate = datePicker.date
            
            //create an ExerciseReminder with user set values and save it onto the database
            realm.beginWrite()
            let newExerciseReminder = ExerciseReminder()
            newExerciseReminder.body = bodyText
            newExerciseReminder.date = targetDate
            realm.add(newExerciseReminder)
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
