//
//  BreaksViewController.swift
//  Iremia
//
//  Created by Benjamin Shiao on 11/12/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

//create breaks reminder class for database
class BreaksReminder: Object {
    @objc dynamic var body: String = ""
    @objc dynamic var date: Date = Date()
}

class BreaksViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    //Creates fields where users enter values for each field
    //@IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    //@IBOutlet var fieldLabel: UILabel!
    //@IBOutlet var dateLabel: UILabel!
    //fieldLabel
    //dateLabel
    
    //Completion function when page is done
    public var completion: ((String, Date) -> Void)?
    
    //initialize realm
    private let realm = try! Realm()
    //this array stores all past breaksReminders locally
    var breaksReminders = [BreaksReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyField.delegate = self
        bodyField.attributedPlaceholder = NSAttributedString(string: "Enter break reminder description", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        
        //populate local breaksReminders array with reminders from the database
        breaksReminders = realm.objects(BreaksReminder.self).map({ $0 })
        
        //if the user has already save a past breaks reminder
        if(breaksReminders.count > 0){
            //set breaks reminder page to show most recently saved body and date
            bodyField.text = breaksReminders[breaksReminders.count-1].body
            datePicker.date = breaksReminders[breaksReminders.count-1].date
        }
        
        //Creates save button on top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        
        //background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        //bodyField.textFieldInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
        bodyField.layer.cornerRadius = 20

        self.view.addSubview(bodyField)
        self.view.addSubview(datePicker)
        self.view.addSubview(fieldLabel)
        self.view.addSubview(dateLabel)
    }
    
    @objc func didTapSave() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to save?", preferredStyle: .alert)
        
        //create ok button, moves to delete()
        let ok = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
             self.save()
        })
        //create cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func save() {
        //return to previous page
        self.navigationController?.popToRootViewController(animated: true)
        
        //this saves the values users enter into corresponding variable
        if let bodyText = bodyField.text{
            let targetDate = datePicker.date
            
            //create an BreaksReminder with user set values and save it onto the database
            realm.beginWrite()
            let newBreaksReminder = BreaksReminder()
            newBreaksReminder.body = bodyText
            newBreaksReminder.date = targetDate
            realm.add(newBreaksReminder)
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
