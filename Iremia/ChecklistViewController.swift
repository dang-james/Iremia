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
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAdd(){
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        
        vc.title = "New Task"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, body:body, identifier: "id\(title)")
                self.models.append(new)
                self.table.reloadData()
                
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
         

}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()            
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
}

struct MyReminder {
    let title: String
    let date: Date
    let body: String
    let identifier: String
    
}
