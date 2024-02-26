//
//  Item+CoreDataProperties.swift
//  Gamagu
//
//  Created by yona on 2/12/24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var category: Category?

}

extension Item : Identifiable {

}
