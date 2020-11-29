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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gets the values for each field from the item object
        titleLabel.text = item?.title
        bodyLabel.text = item?.body
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        navigationItem.rightBarButtonItems = [delete, edit]
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
        editHandler?()
        navigationController?.pushViewController(vc, animated: true)
    }
}
