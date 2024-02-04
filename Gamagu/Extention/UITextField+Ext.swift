//
//  UITextField+Ext.swift
//  Gamagu
//
//  Created by yona on 2/2/24.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        leftViewMode = .always
    }
}
