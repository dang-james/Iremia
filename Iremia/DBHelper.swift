//
//  DBHelper.swift
//  iremiatestdb
//
//  Created by Jeffrey Lin on 11/5/20.
//  Copyright © 2020 Jeffrey Lin. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTasksTable()
        createRemindersTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTasksTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS tasks(userID INTEGER, taskID INTEGER PRIMARY KEY, name TEXT, description TEXT, dueDate TEXT, priority INTEGER, completion TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("task table created.")
            } else {
                print("task table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createRemindersTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS reminders(userID INTEGER, reminderID INTEGER PRIMARY KEY,name TEXT,time INTEGER, message TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("reminders table created.")
            } else {
                print("reminders table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertTask(userID: Int, taskID: Int, name: String, description: String, dueDate: String, priority: Int, completion: Int)
    {
        let insertStatementString = "INSERT INTO task (userID, taskID, name, description, dueDate, priority, completion) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(userID))
            sqlite3_bind_int(insertStatement, 2, Int32(taskID))
            sqlite3_bind_text(insertStatement, 3, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (dueDate as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32(priority))
            sqlite3_bind_int(insertStatement, 7, Int32(completion))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readTask() -> [Task] {
        let queryStatementString = "SELECT * FROM task;"
        var queryStatement: OpaquePointer? = nil
        var tasks : [Task] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let userID = sqlite3_column_int(queryStatement, 0)
                let taskID = sqlite3_column_int(queryStatement, 1)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let dueDate = sqlite3_column_int(queryStatement, 4)
                let priority = sqlite3_column_int(queryStatement, 5)
                let completion = sqlite3_column_int(queryStatement, 6)
                tasks.append(Task(userID: Int(), taskID: Int(), name: String(), description: String(), dueDate: String(), priority: Int(), completion: Int()))
                print("Query Result:")
                print("\(userID) | \(taskID) | \(name) | \(description) | \(dueDate) | \(priority) | \(completion)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return tasks
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM task WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
