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
    
    
    @IBAction func didTapExercise(){
        
        //Navigates to the add task page
        guard let vc = storyboard?.instantiateViewController(identifier: "ExerciseViewController") as? ExerciseViewController else {
            return
        }
        //Set title for add task page
        vc.title = "Exercise"
        
        //Create display to customize repeat
        
        
        // Pushes Add page on top
        navigationController?.pushViewController(vc, animated: true)
    }
    
         

}


