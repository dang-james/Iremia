//
//  FirstViewController.swift
//  Iremia
//
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
    }
    @IBAction func goSettings(_ sender: Any) {
        let url = URL(string:UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!){
            // can open succeeded.. opening the url
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Notification Settings"
        
        return cell
    }
}
