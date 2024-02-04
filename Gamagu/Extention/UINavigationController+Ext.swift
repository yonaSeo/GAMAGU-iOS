//
//  UINavigationController+Ext.swift
//  Gamagu
//
//  Created by yona on 1/29/24.
//

import UIKit

extension UINavigationController {
    func setNavigationBarAppearce() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .primary100
        appearance.titleTextAttributes =
        [
            .font: UIFont(name: "Slackey-Regular", size: 15.0) ?? .boldSystemFont(ofSize: 15.0),
            .foregroundColor: UIColor.white
        ]
        appearance.largeTitleTextAttributes =
        [
            .font: UIFont(name: "Slackey-Regular", size: 28.0) ?? UIFont.boldSystemFont(ofSize: 28.0),
            .foregroundColor: UIColor.white
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .red
        navigationBar.prefersLargeTitles = true
        
    }
}
