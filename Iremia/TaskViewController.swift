//
//  TaskViewController.swift
//  Iremia
//
//  Created by James Dang on 11/8/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    public var item: MyReminder?    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = item?.title
        bodyLabel.text = item?.body
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
       
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
