//
//  FirstViewController.swift
//  Iremia
//
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
    }
    //Button that takes to settings
    @IBAction func goSettings(_ sender: Any) {
        let url = URL(string:UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!){
            // can open succeeded.. opening the url
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }



}
