//
//  UIApplication+Ext.swift
//  Gamagu
//
//  Created by yona on 2/17/24.
//

import UIKit

extension UIApplication {
    class func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
        }
        return nil
    }
}
