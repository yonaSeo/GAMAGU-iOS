//
//  CategorySettingButtonDelegate.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

protocol CategorySettingButtonDelegate: AnyObject {
    func categorySettingActivationToggleValueChanged(section: Int, isActive: Bool)
    func categorySettingPositionUpButtonTapped(section: Int)
    func categorySettingPositionDownButtonTapped(section: Int)
}
