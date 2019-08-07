//
//  MainToDoPresenter.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol MainToDoViewDelegate:NSObjectProtocol{
    func showValidationError(errorController:UIAlertController)
    func updateDateButton(title:String)
    func resetToDoForm()
}

class MainToDoPresenter{
    
    //MARK: Presenter Properties
    weak private var mainToDoDelegate:MainToDoViewDelegate?
    let realm = try! Realm()
    private var priority = "!"
    private var title:String!
    private var dueDate:Date!
    
    //MARK: Set View Delegate
    func setViewDelegate(mainToDoDelegate:MainToDoViewDelegate?){
        self.mainToDoDelegate = mainToDoDelegate
    }
    
    //MARK: Handle Main View Actions
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
    
    func changeTitle(newTitle:String){
        title = newTitle
    }
    
    func changeDueDate(newDate:Date){
        dueDate = newDate
        setNewDateButtonTitle()
    }
    
    func addNewToDoItem(){
        validateNewToDo {
            let newToDo = ToDoItem()
            newToDo.id = RealmUniqueIdGenerator().incrementToDoID()
            newToDo.dueDate = dueDate
            newToDo.title = title
            newToDo.priority = priority
            newToDo.isCompleted = false
            
            try! realm.write {
                realm.add(newToDo)
                mainToDoDelegate?.resetToDoForm()
            }
        }
        
    }
    
    func delete(todo:ToDoItem){
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    func setDateButtonTitleToToday(){
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        
        let day = Calendar.current.component(.day, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        
        let todayString = "\(month)/\(day)/\(year) - \(hour):\(minute)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy - HH:mm"
        let today = formatter.date(from: todayString)
        
        dueDate = today!
        
        mainToDoDelegate?.updateDateButton(title: todayString)
    }
    
    func setNewDateButtonTitle(){
        let hour = Calendar.current.component(.hour, from: dueDate)
        let minute = Calendar.current.component(.minute, from: dueDate)
        
        let day = Calendar.current.component(.day, from: dueDate)
        let month = Calendar.current.component(.month, from: dueDate)
        let year = Calendar.current.component(.year, from: dueDate)
        
        let todayString = "\(month)/\(day)/\(year) - \(hour):\(minute)"
        
        mainToDoDelegate?.updateDateButton(title: todayString)
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
        
        mainToDoDelegate?.showValidationError(errorController: errorAlert)
    }
}
