//
//  ToDoItemCellModel.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ToDoItemCellModel:NSObject{
    
    //MARK: View Model Properties
    var todo:ToDoItem!
    var DEFAULT_DUE_DATE_TINT = UIColor(red: (69.0/255.0), green: (69.0/255.0), blue: (69.0/255.0), alpha: 1.0)
    
    init(todo:ToDoItem){
        self.todo = todo
    }
    
    func getFormattedDateString()->String{
        var formattedDate = ""
        
        let date = todo.dueDate
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy - HH:mm"
        formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    func dueDateTintColor()->UIColor{
        
        if todo.isOverdue(){
            return UIColor.red
        }
        
        return DEFAULT_DUE_DATE_TINT
    }
    
    func getTitle()->String{
        return todo.title
    }
    
    func getPriority()->String{
        return todo.priority
    }
    
    func completionStatus()->Bool{
        return todo.isCompleted
    }
    
    func toggleCompletedStatus(){
        let realm = try! Realm()
        try! realm.write {
            todo.isCompleted = !todo.isCompleted
        }
    }
}
