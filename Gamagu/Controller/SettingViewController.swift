//
//  SettingViewController.swift
//  Gamagu
//
//  Created by yona on 1/29/24.
//

import UIKit

final class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary40
        
        navigationController?.setNavigationBarAppearce()
        navigationItem.title = "SETTING"
        navigationItem.largeTitleDisplayMode = .never
    }
}
