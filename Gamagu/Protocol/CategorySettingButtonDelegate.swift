//
//  CategorySettingButtonDelegate.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

protocol CategorySettingButtonDelegate: AnyObject {
    func categorySettingNameChanged()
    func categorySettingAlarmCountButtonTapped()
    func categorySettingAlarmCycleButtonTapped()
}
