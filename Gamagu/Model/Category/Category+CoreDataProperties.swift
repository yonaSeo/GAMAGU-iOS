//
//  Category+CoreDataProperties.swift
//  Gamagu
//
//  Created by yona on 2/12/24.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var alarmCycleDayCount: Int64
    @NSManaged public var alarmPushCount: Int64
    @NSManaged public var createdDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var orderNumber: Int64
    @NSManaged public var isAlarmActive: Bool
    @NSManaged public var items: NSSet?

    
    public var alarmCycleString: String? {
        switch alarmCycleDayCount {
        case 1: return "하루"
        case 7: return "일주일"
        case 30: return "한 달"
        default: return ""
        }
    }
    
    static func makeAlarmCycleNumber(string: String) -> Int64 {
        switch string {
        case "하루": return 1
        case "일주일": return 7
        case "한 달": return 30
        default: return 0
        }
    }
}

// MARK: Generated accessors for items
extension Category {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Category : Identifiable {

}
