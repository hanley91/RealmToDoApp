//
//  ToDoItem.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem:Object{
    @objc dynamic var id = 0
    @objc dynamic var priority = "!"
    @objc dynamic var dueDate = Date.init()
    @objc dynamic var title = "New Todo"
    @objc dynamic var isCompleted = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func isOverdue()->Bool{
        return dueDate > Date.init()
    }
}
