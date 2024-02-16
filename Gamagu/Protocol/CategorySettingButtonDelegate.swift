//
//  CategorySettingButtonDelegate.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

protocol CategorySettingButtonDelegate: AnyObject {
    func categorySettingNameChanged()
    func categorySettingActivationToggleValueChanged(section: Int, isActive: Bool)
    func categorySettingAlarmCycleCountButtonTapped()
    func categorySettingPositionUpButtonTapped(section: Int)
    func categorySettingPositionDownButtonTapped(section: Int)
}
