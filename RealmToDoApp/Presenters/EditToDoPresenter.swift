//
//  EditToDoPresenter.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-05.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol EditToDoViewDelegate: NSObjectProtocol {
    func dismissViewOnUpdate()
    func showValidationError(errorController: UIAlertController)
    func setDate(label:String)
    func set(title:String)
    func setPriority(index:Int)
}

class EditToDoPresenter{
    
    //MARK: Presenter Properties
    weak private var editDelegate:EditToDoViewDelegate?
    let realm = try! Realm()
    
    private var todo:ToDoItem!
    private var priority = "!"
    private var title:String!
    private var dueDate:Date!
    
    //MARK: Set View Delegate
    func setViewDelegate(editDelegate:EditToDoViewDelegate?){
        self.editDelegate = editDelegate
    }
    
    //MARK: Get Display Values
    func loadTitle(){
        editDelegate?.set(title: title)
    }
    
    func loadSelectedPriority(){
        var selected = 0
        
        switch priority {
        case "!":
            selected = 0
            break
        case "!!":
            selected = 1
            break
        case "!!!":
            selected = 2
            break
        default:
            selected = 0
            break
        }
        
        editDelegate?.setPriority(index: selected)
    }
    
    func loadDueDateString(){
        let hour = Calendar.current.component(.hour, from: dueDate)
        let minute = Calendar.current.component(.minute, from: dueDate)
        
        let day = Calendar.current.component(.day, from: dueDate)
        let month = Calendar.current.component(.month, from: dueDate)
        let year = Calendar.current.component(.year, from: dueDate)
        
        let todayString = "\(month)/\(day)/\(year) - \(hour):\(minute)"
        
        editDelegate?.setDate(label: todayString)
    }
    
    //MARK: Handle View Actions
    func changeDueDate(date:Date){
        dueDate = date
    }
    
    func changeTitle(newTitle:String){
        title = newTitle
    }
    
    func changePriority(selectedPriority:Int){
        switch selectedPriority {
        case 0:
            priority = "!"
            break
        case 1:
            priority = "!!"
            break
        case 2:
            priority = "!!!"
            break
        default:
            priority = "!"
            break
        }
    }
    
    func setTodoItem(existing:ToDoItem){
        todo = existing
        title = todo.title
        dueDate = todo.dueDate
        priority = todo.priority
    }
    
    func updateTodo(){
        validateNewToDo {
            try! realm.write {
                todo.title = title
                todo.priority = priority
                todo.dueDate = dueDate
                editDelegate?.dismissViewOnUpdate()
            }
        }
    }
    
    //MARK: Validation
    func validateNewToDo(completion:()->Void){
        var isValid = true
        
        if title == nil || title.isEmpty{
            isValid = false
        }
        
        if isValid{
            completion()
        }else{
            displayValidationError()
        }
    }
    
    func displayValidationError(){
        let errorAlert = UIAlertController(title: "Missing Title!", message: "Please make sure a title has been selected!", preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: {(action) in
            errorAlert.dismiss(animated: true, completion: nil)
        })
        
        errorAlert.addAction(dismiss)
        
        editDelegate?.showValidationError(errorController: errorAlert)
    }
}
