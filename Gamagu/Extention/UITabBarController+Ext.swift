//
//  UITabBarController+Ext.swift
//  Gamagu
//
//  Created by yona on 1/30/24.
//

import UIKit

extension UITabBarController {
    func setTabBar() {
        tabBar.backgroundColor = .primary100
        tabBar.tintColor = .font100
        tabBar.unselectedItemTintColor = .font25
        
        tabBar.items?.forEach {
            $0.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
            $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        }
        
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 100
        
        guard let items = tabBar.items else { return }
        let home = items[0]
        let setting = items[1]
        
        home.title = "홈"
        home.image = UIImage(named: "icon_home")
        
        setting.title = "설정"
        setting.image = UIImage(named: "icon_setting")
    }
}
