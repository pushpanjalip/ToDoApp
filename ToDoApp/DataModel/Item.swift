//
//  Item.swift
//  ToDoApp
//
//  Created by Pooja Pawar on 17/04/2018.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import Foundation
import  RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
      var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
