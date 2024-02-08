//
//  ItemCategory.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

struct ItemCategory {
    var name: String
    var alarmCycleDayCount: Int
    var alarmCount: Int
    var date: Date
    
    public var dateString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }

    public var alarmCycleString: String? {
        switch alarmCycleDayCount {
        case 1: return "하루"
        case 3: return "삼일"
        case 7: return "일주일"
        case 30: return "한 달"
        default: return ""
        }
    }
    
    init(name: String, alarmCycleDay: Int, alarmCount: Int) {
        self.name = name
        self.alarmCycleDayCount = alarmCycleDay
        self.alarmCount = alarmCount
        self.date = Date()
    }
}
