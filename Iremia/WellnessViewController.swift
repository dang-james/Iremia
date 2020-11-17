//
//  SecondViewController.swift
//  Iremia
//
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class WellnessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapExercise(_ sender: UIButton){
        
        //Navigates to the exercise page
        guard let vc = storyboard?.instantiateViewController(identifier: "ExerciseViewController") as? ExerciseViewController else {
            return
        }
        //Set title for exercise wellness page
        vc.title = "Exercise"
        
        //When exercise repeat reminder is done and creates notification
        vc.completion = {body, date in
            DispatchQueue.main.async {
                // Creating notification
                let content = UNMutableNotificationContent()
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: true)
                
                let notif_id = "exercise_id"
                //delete old notification repeater
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notif_id])
                
                //create new notifcation repeater
                let request = UNNotificationRequest(identifier: notif_id, content: content, trigger: trigger)
                
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


