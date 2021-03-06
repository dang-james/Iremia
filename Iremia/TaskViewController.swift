//
//  TaskViewController.swift
//  Iremia
//
//  Created by James Dang on 11/8/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

class TaskViewController: UIViewController {
    
    //Create Reminder object
    public var item: Task?
    public var deletionHandler: (() -> Void)?
    public var editHandler: (() -> Void)?
    
    //Create labels for title, body, and date fields
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    //initialize database
    private let realm = try! Realm()
    
    //Set format for displaying date
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM, dd, YYYY, hh:mm a"
        return dateFormatter
    }()

    //background gradient
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gets the values for each field from the item object
        titleLabel.text = item?.title
        bodyLabel.text = item?.body
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        navigationItem.rightBarButtonItems = [delete, edit]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bodyLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1081496552, green: 0.115949668, blue: 0.2311390638, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1081496552, green: 0.115949668, blue: 0.2311390638, alpha: 1)

        self.view.addSubview(titleLabel)
        self.view.addSubview(bodyLabel)
        self.view.addSubview(dateLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

    }
    
    //if delete task is pressed, create a popup to confirm
    @objc func didTapDelete() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the task?", preferredStyle: .alert)
        
        //create ok button, moves to delete()
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             self.delete()
        })
        //create cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    //remove task from database
    func delete() {
        guard let myItem = self.item else {
            return
        }
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()

        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    
    //if edit task is pressed we go to the edit view controller
    @objc func didTapEdit() {
        guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
            return
        }
        
        //get the current task
        guard let myItem = self.item else {
            return
        }
        
        //pass the current task id to the edit view controller
        vc.taskID = myItem.id
        
        vc.title = "Edit"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        //When edit task is done, creates notification with new inputted data
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                //Creating MyReminder object
                self.navigationController?.popToRootViewController(animated: true)
                
                // Creating notification
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                                          from: targetDate),
                                                                            repeats: false)

                                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                                    if error != nil {
                                        print("something went wrong")
                                    }
                                })
            }
            
        }
        editHandler?()
        navigationController?.pushViewController(vc, animated: true)
    }
}
