//
//  Item.swift
//  Gamagu
//
//  Created by yona on 1/31/24.
//

import UIKit

struct Item {
    var category: String
    var title: String
    var content: String
    var date: Date
    
    public var dateString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    init(category: String, title: String, content: String) {
        self.category = category
        self.title = title
        self.content = content
        self.date = Date()
    }
}
