//
//  Category.swift
//  ToDoList
//
//  Created by Connor Boyce on 9/3/19.
//  Copyright © 2019 Connor Boyce. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
