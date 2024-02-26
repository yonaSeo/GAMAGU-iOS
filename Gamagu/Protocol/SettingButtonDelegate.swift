//
//  SettingButtonDelegate.swift
//  Gamagu
//
//  Created by yona on 2/6/24.
//

import UIKit

protocol SettingButtonDelegate: AnyObject {
    func dateValueChanged(type: String, date: Date)
    func toggleValueChanged(isActive: Bool)
    func optionMenuValueChnaged(type: String, selectedOption: String)
    func categoryButtonTapped()
}
