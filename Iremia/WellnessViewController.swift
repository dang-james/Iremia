//
//  SecondViewController.swift
//  Iremia
//
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class WellnessViewController: UIViewController {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var exerciseButton:UIView!
    @IBOutlet weak var sleepButton:UIView!
    @IBOutlet weak var mealsButton:UIView!
    @IBOutlet weak var breaksButton:UIView!
    
    @IBOutlet weak var subDescription:UIView!
    
    //ViewDidLoad function contains code for frontend
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        exerciseButton.layer.cornerRadius = 20
        sleepButton.layer.cornerRadius = 20
        mealsButton.layer.cornerRadius = 20
        breaksButton.layer.cornerRadius = 20
        
        
        self.view.addSubview(exerciseButton)
        self.view.addSubview(sleepButton)
        self.view.addSubview(mealsButton)
        self.view.addSubview(breaksButton)
        self.view.addSubview(subDescription)
        
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
                
                //updates and adds actual notification
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
    
    @IBAction func didTapMeals(_ sender: UIButton){
        
        //Navigates to the meals page
        guard let vc = storyboard?.instantiateViewController(identifier: "MealsViewController") as? MealsViewController else {
            return
        }
        //Set title for Meals wellness page
        vc.title = "Meals"
        
        //When Meals repeat reminder is done and creates notification
        vc.completion = {body, date in
            DispatchQueue.main.async {
                // Creating notification
                let content = UNMutableNotificationContent()
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: true)
                
                let notif_id = "meals_id"
                //delete old notification repeater
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notif_id])
                
                //create new notifcation repeater
                let request = UNNotificationRequest(identifier: notif_id, content: content, trigger: trigger)
                
                //updates and adds actual notification
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
    
    @IBAction func didTapBreaks(_ sender: UIButton){
        
        //Navigates to the Breaks page
        guard let vc = storyboard?.instantiateViewController(identifier: "BreaksViewController") as? BreaksViewController else {
            return
        }
        //Set title for Breaks wellness page
        vc.title = "Breaks"
        
        //When Breaks repeat reminder is done and creates notification
        vc.completion = {body, date in
            DispatchQueue.main.async {
                // Creating notification
                let content = UNMutableNotificationContent()
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: true)
                
                let notif_id = "breaks_id"
                //delete old notification repeater
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notif_id])
                
                //create new notifcation repeater
                let request = UNNotificationRequest(identifier: notif_id, content: content, trigger: trigger)
                
                //updates and adds actual notification
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
    
    @IBAction func didTapSleep(_ sender: UIButton){
        
        //Navigates to the Sleep page
        guard let vc = storyboard?.instantiateViewController(identifier: "SleepViewController") as? SleepViewController else {
            return
        }
        //Set title for Sleep wellness page
        vc.title = "Sleep"
        
        //When Sleep repeat reminder is done and creates notification
        vc.completion = {body, date in
            DispatchQueue.main.async {
                // Creating notification
                let content = UNMutableNotificationContent()
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: true)
                
                let notif_id = "sleep_id"
                //delete old notification repeater
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notif_id])
                
                //create new notifcation repeater
                let request = UNNotificationRequest(identifier: notif_id, content: content, trigger: trigger)
                
                //updates and adds actual notification
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


