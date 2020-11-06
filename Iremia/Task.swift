//
//  Task.swift
//  iremiatestdb
//
//  Created by Jeffrey Lin on 11/5/20.
//  Copyright © 2020 Jeffrey Lin. All rights reserved.
//

import Foundation

class Task
{
    var userID: Int = 0
    var taskID: Int = 0
    var name: String = ""
    var description: String = ""
    var dueDate: String = ""
    var priority: Int = 1
    var completion: Int = 0
    
    
    
    init(userID: Int, taskID: Int, name: String, description: String, dueDate: String, priority: Int, completion: Int)
    {
        self.userID = userID
        self.taskID = taskID
        self.name = name
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.completion = completion
    }
}
