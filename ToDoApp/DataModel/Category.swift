//
//  Category.swift
//  ToDoApp
//
//  Created by Pooja Pawar on 17/04/2018.
//  Copyright © 2018 Pushpanjali. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
   
   
}
