//
//  Item.swift
//  Todoey
//
//  Created by Rihab Al-yasiri on 11.03.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var createDate: Date?
    var parentCategory = LinkingObjects(fromType:Category.self , property: "items")
}
