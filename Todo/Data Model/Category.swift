//
//  Category.swift
//  Todo
//
//  Created by Peter Emel on 1/25/20.
//  Copyright © 2020 Peter Emel. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
