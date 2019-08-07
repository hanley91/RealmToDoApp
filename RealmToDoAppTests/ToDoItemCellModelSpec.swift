//
//  ToDoItemCellModelSpec.swift
//  RealmToDoAppTests
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Nimble
import Quick
@testable import RealmToDoApp

class ToDoItemCellModelSpec: QuickSpec {
    override func spec(){
        
        describe("ToDo cell view model, incomplete, not overdue"){
            var toDoItemCellModel:ToDoItemCellModel!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let someDateTime = formatter.date(from: "2019/08/10 07:00")
            
            let newToDo = ToDoItem()
            newToDo.title = "Test View Model Formatting"
            newToDo.dueDate = someDateTime!
            newToDo.id = 1
            newToDo.priority = "!"
            newToDo.isCompleted = false
            
            beforeEach {
                toDoItemCellModel = ToDoItemCellModel(todo: newToDo)
            }
            
            it("Formats date string properly"){
                expect(toDoItemCellModel.getFormattedDateString()).to(equal("08/10/2019 - 07:00"))
            }
            
            it("Returns the title"){
                expect(toDoItemCellModel.getTitle()).to(equal("Test View Model Formatting"))
            }
            
            it("Returns the priority"){
                expect(toDoItemCellModel.getPriority()).to(equal("!"))
            }
            
            it("Returns completion status"){
                expect(toDoItemCellModel.completionStatus()).to(equal(false))
            }
            
            it("Toggles from incomplete to complete"){
                toDoItemCellModel.toggleCompletedStatus()
                expect(toDoItemCellModel.completionStatus()).to(equal(true))
            }
        }
    }
    
}

