//
//  ChecklistViewController.swift
//  Iremia
//
//  Created by James Dang on 11/7/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UserNotifications
import UIKit

//create task class for database
class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var id: String = ""
}

class ChecklistViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    //initialize realm
    private let realm = try! Realm()
    //this array stores all the tasks on the database
    var taskList = [Task]()
    //background gradient
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        //Ask for notifications permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        super.viewDidLoad()
        //populates taskList array with tasks from database
        taskList = realm.objects(Task.self).map({ $0 })
        table.delegate = self
        table.dataSource = self
        table.separatorColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        /*let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor, #colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)*/
        
    }
    
    //Function called when users tap the add button
    @IBAction func didTapAdd(){
        
        //Navigates to the add task page
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        //Set title for add task page
        vc.title = "New Task"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        //When add task is done, creates notification with inputted data
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                //Creating MyReminder object
                self.navigationController?.popToRootViewController(animated: true)
                
                //refreshes the local array and table with updated database tasks
                self.taskList = self.realm.objects(Task.self).map({ $0 })
                self.table.reloadData()
                
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
        
        // Pushes Add page on top
        navigationController?.pushViewController(vc, animated: true)
    }
    //refresh table and local taskList array
    func refresh() {
        self.taskList = self.realm.objects(Task.self).map({ $0 })
        self.table.reloadData()
    }
}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Sets up table on checklist page
        let item = taskList[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "task") as? TaskViewController else {
            return
        }
        
        vc.item = item
        //if item gets deleted table refeshes
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChecklistViewController: UITableViewDataSource {
    //More table set up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    // Function tells each table cell what to display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskList[indexPath.row].title
        let date = taskList[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY, hh:mm a"
        
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .delete
       }
       
       // Deletes task from array and table and updates table, will delete multiple tasks if they have the same title
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete{
            
            let filter = taskList[indexPath.row].id
            let myItem = realm.objects(Task.self).filter("id == %@", filter)
            
            realm.beginWrite()
            realm.delete(myItem)
            try! realm.commitWrite()
              
            self.refresh()
           }
       }
    
}
