//
//  HomeViewController.swift
//  Gamagu
//
//  Created by yona on 1/25/24.
//

import UIKit

class HomeViewController: UIViewController {
    private let logoImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_gamagu"), for: .normal)
        button.setTitle("GAMAGU", for: .normal)
        button.setTitleColor(.font100, for: .normal)
        button.contentVerticalAlignment = .bottom
        button.titleLabel?.font = UIFont(name: "Slackey-Regular", size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var customButton: UIButton = {
        var button = UIButton()
        if #available(iOS 15.0, *) {
            button.newCustomButtonMaker(title: "추가", color: .orange, imageName: "icon_plus")
        } else {
            button.oldCustomButtonMaker(title: "추가", color: .orange, imageName: "icon_plus")
        }
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary40
        
        setNavigationBar()
        setUI()
    }
    
    func setNavigationBar() {
        navigationController?.setNavigationBarAppearce()
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.addSubview(customButton)
        navigationController?.navigationBar.addSubview(logoImageView)
    }
    
    func setUI() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 16),
            logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -16),
        ])
        
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                customButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -8),
                customButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                customButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -8),
                customButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8),
            ])
        }
    }
    
    @objc func addNewItem() {
        let vc = UIViewController()
        vc.view.backgroundColor = .primary80
        present(vc, animated: true)
    }
}

