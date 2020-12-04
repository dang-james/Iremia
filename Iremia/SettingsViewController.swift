//
//  FirstViewController.swift
//  Iremia
//
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        //sets phone nav bar color
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1081496552, green: 0.115949668, blue: 0.2311390638, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1081496552, green: 0.115949668, blue: 0.2311390638, alpha: 1)
        
        //background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        //formats the table
        table.separatorColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.backgroundColor = #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 0)
        self.view.addSubview(table)
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

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    //set up table view for settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Notification Settings"
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
}
