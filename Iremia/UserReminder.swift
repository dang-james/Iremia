//
//  UserReminder.swift
//  iremiatestdb
//
//  Created by Jeffrey Lin on 11/5/20.
//  Copyright © 2020 Jeffrey Lin. All rights reserved.
//

import Foundation

class UserReminder
{
    var userID: Int = 0
    var remindID: Int = 0
    var name: String = ""
    var time: Date = Date()
    var message: String = ""
    
    init(userID: Int, remindID: Int, name: String, time: Date, message: String)
    {
        self.userID = userID
        self.remindID = remindID
        self.name = name
        self.time = time
        self.message = message
    }
}
