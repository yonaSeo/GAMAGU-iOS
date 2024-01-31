//
//  Item.swift
//  Gamagu
//
//  Created by yona on 1/31/24.
//

import UIKit

struct Item {
    var title: String?
    var content: String?
    var cetegory: String?
    var date: Date?
    
    public var dateString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date else { return "" }
        return formatter.string(from: date)
    }
}
