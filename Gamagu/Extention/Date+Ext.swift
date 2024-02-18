//
//  Date+Ext.swift
//  Gamagu
//
//  Created by yona on 2/16/24.
//

import Foundation

extension Date {
    var convertedDate:Date {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)

        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        dateFormatter.dateFormat = dateFormat
        let sourceDate = dateFormatter.date(from: formattedDate)

        return sourceDate!
    }
}
