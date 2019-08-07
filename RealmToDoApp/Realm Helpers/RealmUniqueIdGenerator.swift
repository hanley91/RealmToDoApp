//
//  RealmUniqueIdGenerator.swift
//  RealmToDoApp
//
//  Created by Spencer Hanley on 2019-08-04.
//  Copyright © 2019 Hanley Solid Solutions. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUniqueIdGenerator{
    func incrementToDoID() -> Int {
        let realm = try! Realm()
        return (realm.objects(ToDoItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
