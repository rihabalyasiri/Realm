//
//  Category.swift
//  Todoey
//
//  Created by Rihab Al-yasiri on 11.03.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorString: String = ""
    let items = List<Item>()
}
