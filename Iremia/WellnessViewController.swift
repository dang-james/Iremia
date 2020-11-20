//
//  WellnessViewController.swift
//  Iremia
//
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class WellnessViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get current saved tasks
    }

    @IBAction func didTapAdd() {
        
    }

}

extension WellnessViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated : true)
    }
}

extension WellnessViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection ssection: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
}
