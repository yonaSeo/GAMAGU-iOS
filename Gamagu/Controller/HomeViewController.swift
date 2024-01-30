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
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Card", "Table"])
        control.backgroundColor = .primary100
        control.selectedSegmentTintColor = .primary60
        control.setTitleTextAttributes([.foregroundColor: UIColor.font100], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.primary20], for: .normal)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let carouselContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        view.addSubview(segmentedControl)
        view.addSubview(carouselContainerView)
        view.addSubview(tableContainerView)
        
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 16),
            logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -16),
            
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 28),
            segmentedControl.widthAnchor.constraint(equalToConstant: 118),
            
            carouselContainerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            carouselContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carouselContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableContainerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
    
    @objc func didChangeValue(segment: UISegmentedControl) {
        carouselContainerView.isHidden = segment.selectedSegmentIndex != 0
        tableContainerView.isHidden = !carouselContainerView.isHidden
    }
}

