//
//  Item.swift
//  Todo
//
//  Created by Peter Emel on 1/25/20.
//  Copyright © 2020 Peter Emel. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
