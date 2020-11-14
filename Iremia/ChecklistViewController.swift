//
//  ChecklistViewController.swift
//  Iremia
//
//  Created by James Dang on 11/7/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import UserNotifications
import UIKit

class ChecklistViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        //Ask for notifications permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
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
        
        //When add task is done, creates a new MyReminder object with entered values, and creates notification
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                //return to previous page
                self.navigationController?.popToRootViewController(animated: true)
                
                //Creating MyReminder object
                let new = MyReminder(title: title, date: date, body:body, identifier: "id\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                // Creating notification
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: targetDate), repeats: false)

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
    
         

}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Sets up table on checklist page
        
        let item = models[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "task") as? TaskViewController else {
            return
        }
        
        vc.item = item
               
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
        return models.count
    }
    
    // Function tells each table cell what to display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY, hh:mm a"
        
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
    
    //used for deletion, may need to change when db implemented
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Deletes task from array and table and updates table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()            
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
}

// Struct for reminders
struct MyReminder {
    let title: String
    let date: Date
    let body: String
    let identifier: String
    
}
