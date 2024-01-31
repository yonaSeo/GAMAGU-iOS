//
//  HomeViewController.swift
//  Gamagu
//
//  Created by yona on 1/25/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - 헤더(네비게이션 바)
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
            button.newCustomButtonMaker(title: "추가", color: .accent100, imageName: "icon_plus")
        } else {
            button.oldCustomButtonMaker(title: "추가", color: .accent100, imageName: "icon_plus")
        }
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - 세그먼트 컨트롤
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
    
    // MARK: - 컬렉션뷰 관련
    private let collectionContainerView: UIView = {
        let view = UIView()
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100) // 카드 크기: 내부 크기에 따라 늘어남 (아이템-그룹 같아야 함)
                )
            )
            item.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20) // 카드 간 간격
            // group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .estimated(100) // 카드 크기: 내부 크기에 따라 늘어남 (아이템-그룹 같아야 함)
                ),
                subitem: item,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = .init(top: 32, leading: 20, bottom: 80, trailing: 0) // CollectionBackgroundView 크기 (안의 view가 아님) -> 바꾸기 주의 ⚠️
            
            
            // header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), // 헤더 크기 -> 바꾸기 주의 ⚠️
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            
            // background
            section.decorationItems = [
                NSCollectionLayoutDecorationItem.background(elementKind: CollectionBackgroundView.identifier)
            ]
           
            return section
        }
        layout.register(CollectionBackgroundView.self, forDecorationViewOfKind: CollectionBackgroundView.identifier)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - 테이블뷰 관련
    private let tableContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.separatorColor = .primary20
        tv.rowHeight = 48
        tv.sectionHeaderHeight = 48
        tv.sectionFooterHeight = 48
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary40
        
        setupNavigationBar()
        setupCollectionView()
        setupTableView()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - setup 함수
    func setupNavigationBar() {
        navigationController?.setNavigationBarAppearce()
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.addSubview(customButton)
        navigationController?.navigationBar.addSubview(logoImageView)
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CollectionViewCell.self, 
            forCellWithReuseIdentifier: CollectionViewCell.identifier
        )
        collectionView.register(
            CollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionHeaderView.identifier
        )
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)
    }
    
    func setupUI() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionContainerView)
        collectionContainerView.addSubview(collectionView)
        view.addSubview(tableContainerView)
        tableContainerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 16),
            logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -16),
            
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 28),
            segmentedControl.widthAnchor.constraint(equalToConstant: 118),
            
            collectionContainerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: collectionContainerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: collectionContainerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: collectionContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: collectionContainerView.trailingAnchor),
            
            tableContainerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
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
    
    // MARK: - @objc 함수
    @objc func addNewItem() {
        let vc = UIViewController()
        vc.view.backgroundColor = .primary80
        present(vc, animated: true)
    }
    
    @objc func didChangeValue(segment: UISegmentedControl) {
        collectionContainerView.isHidden = segment.selectedSegmentIndex != 0
        tableContainerView.isHidden = !collectionContainerView.isHidden
    }
}

// MARK: - 컬렉션뷰 datasource & delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as? CollectionHeaderView else { fatalError() }
            return header
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier, for: indexPath
        ) as? CollectionViewCell else { return UICollectionViewCell() }
        // if indexPath.section == 0 { }
        if indexPath.row % 2 == 0 {
            cell.item = Item(title: "제목", content: "짝수 내용입니다.")
        } else {
            cell.item = Item(title: "제목", content: "홀수 내용입니다홀수 내용입니다홀수 내용입니다홀수 내용입니다홀수 내용입니다홀수 내용입니다")
        }
        
        return cell
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { fatalError() }
        return cell
    }
}
