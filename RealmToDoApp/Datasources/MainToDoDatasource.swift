//
//  MainToDoDatasource.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MainToDoDatasource:NSObject,UITableViewDataSource{
    
    //MARK: DataSource Properties
    var searchResults = try! Realm().objects(ToDoItem.self)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoItemCell
        
        cell.todo = ToDoItemCellModel(todo: searchResults[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
