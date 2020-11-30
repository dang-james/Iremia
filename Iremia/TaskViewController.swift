//
//  TaskViewController.swift
//  Iremia
//
//  Created by James Dang on 11/8/20.
//  Copyright © 2020 Iremia. All rights reserved.
//

import RealmSwift
import UIKit

class TaskViewController: UIViewController {
    
    //Create Reminder object
    public var item: Task?
    public var deletionHandler: (() -> Void)?
    
    //Create labels for title, body, and date fields
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    //initialize database
    private let realm = try! Realm()
    
    //Set format for displaying date
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM, dd, YYYY, hh:mm a"
        return dateFormatter
    }()

    //background gradient
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gets the values for each field from the item object
        titleLabel.text = item?.title
        bodyLabel.text = item?.body
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.3338187337, green: 0.3300850391, blue: 0.5314263105, alpha: 1).cgColor, #colorLiteral(red: 0.6792625189, green: 0.8248208165, blue: 0.7395270467, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        self.view.addSubview(titleLabel)
        self.view.addSubview(bodyLabel)
        self.view.addSubview(dateLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    }
    
    //if delete task is pressed we remove the task from the database
    @objc func didTapDelete() {
        guard let myItem = self.item else {
            return
        }
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()

        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }
    
    

}
