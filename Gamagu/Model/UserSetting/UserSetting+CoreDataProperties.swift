//
//  UserSetting+CoreDataProperties.swift
//  Gamagu
//
//  Created by yona on 2/12/24.
//
//

import Foundation
import CoreData


extension UserSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSetting> {
        return NSFetchRequest<UserSetting>(entityName: "UserSetting")
    }

    @NSManaged public var alarmContentType: String?
    @NSManaged public var alarmEndTime: Date?
    @NSManaged public var alarmSoundType: String?
    @NSManaged public var alarmStartTime: Date?
    @NSManaged public var isAlarmSoundActive: Bool
    @NSManaged public var isCardViewActive: Bool

}

extension UserSetting : Identifiable {

}
