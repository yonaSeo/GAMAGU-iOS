//
//  HomeViewController.swift
//  Gamagu
//
//  Created by yona on 1/25/24.
//

import UIKit

final class HomeViewController: UIViewController {
    private var dummyItems = [
        Item(category: "카테고리 1", title: "첫 번째 제목", content: "첫 번째 내용입니다."),
        Item(category: "카테고리 1", title: "두 번째 제목", content: "두 번째 내용입니다."),
        Item(category: "카테고리 1", title: "세 번째 제목", content: "세 번째 내용입니다."),
        Item(category: "카테고리 2", title: "첫 번째 제목", content: "첫 번째 내용입니다."),
        Item(category: "카테고리 2", title: "두 번째 제목", content: "두 번째 내용입니다."),
        Item(category: "카테고리 2", title: "세 번째 제목", content: "세 번째 내용입니다."),
        Item(category: "카테고리 2", title: "네 번째 제목", content: "네 번째 내용입니다."),
        Item(category: "카테고리 3", title: "첫 번째 제목", content: "첫 번째 내용입니다."),
        Item(category: "카테고리 3", title: "두 번째 제목", content: "두 번째 내용입니다."),
        Item(category: "카테고리 3", title: "세 번째 제목", content: "세 번째 내용입니다."),
    ]
    private lazy var categories: [(name: String, items: [Item])] = {
        var arr: [(name: String, items: [Item])] = []
        dummyItems.forEach { item in
            var idx = 0
            arr.enumerated().contains {
                idx = $0.offset;
                return $0.element.name.contains(item.category)
            }
            ? arr[idx].items.append(item)
            : arr.append((name: item.category, items: [item]))
        }
        return arr
    }()
    
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
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 40) // 카드 간 간격
            // group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .estimated(100) // 카드 크기: 내부 크기에 따라 늘어남 (아이템-그룹 같아야 함)
                ),
                subitem: item,
                count: 1
            )
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            // 내부 Cell의 CollectionBackgroundView 좌상단 경계로부터의 거리(Inset)
            // 다만 **bottom**은 CollectionBackgroundView 크기 자체에 영향을 준다! -> 바꾸기 주의 ⚠️
            // top-32 / bottom-80인 이유: top과 bottom을 0으로 잡으면 CollectionBackgroundView 크기는 164(= Header 48 + Cell 116(28+28+8+24+28))가 되는데, top을 32로 잡으면 196(+32)가 되고, 이때 backgroundView는 topAnchor는 Header 크기와 같은 48이므로 이미 맞게 적용된 상태이고 bottomAnchor만 남은 상태다. 그러므로 여기서 나머지 bottomAnchor인 48에 top과 같은 32를 더한 80을 bottom으로 잡으면 동일한 거리가 나온다. (헷갈리면 top bottom 0 -> top 32 -> bottom 80 순으로 뷰 계층 비교해볼 것)
            // => top을 정한 후(ex: 50), 이에 backgroundView의 bottomAnchor(48)을 더해(ex: 98) bottom으로 설정
            section.contentInsets = .init(top: 32, leading: 16, bottom: 80, trailing: 0)
            
            
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
                NSCollectionLayoutDecorationItem.background(elementKind: HomeCollectionBackgroundView.identifier)
            ]
           
            return section
        }
        layout.register(HomeCollectionBackgroundView.self, forDecorationViewOfKind: HomeCollectionBackgroundView.identifier)
        
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
        
        setupNavigationBar()
        setupCollectionView()
        setupTableView()
        setupUI()
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
            HomeCollectionViewCell.self, 
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier
        )
        collectionView.register(
            HomeCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionHeaderView.identifier
        )
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.register(HomeTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeTableHeaderView.identifier)
    }
    
    func setupUI() {
        view.backgroundColor = .primary60
        
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
        let vc = InputFormViewController()
        present(vc, animated: true)
    }
    
    @objc func didChangeValue(segment: UISegmentedControl) {
        // ???
        UIView.animate(withDuration: 1.0) { [weak self] in
            guard let self else { return }
            collectionContainerView.isHidden = segment.selectedSegmentIndex != 0
            tableContainerView.isHidden = !collectionContainerView.isHidden
        }
    }
}

// MARK: - 컬렉션뷰 datasource & delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionHeaderView.identifier, for: indexPath) as? HomeCollectionHeaderView else { fatalError() }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            header.text = categories[indexPath.section].name
        default: break
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath
        ) as? HomeCollectionViewCell else { fatalError() }
        
        cell.item = categories[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell else { fatalError() }
        
        cell.item?.category = categories[indexPath.section].name
        
        let vc = InputFormViewController()
        vc.item = cell.item
        
        present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTableHeaderView.identifier) as? HomeTableHeaderView else { fatalError() }
        header.text = categories[section].name
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { fatalError() }
        cell.item = categories[indexPath.section].items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HomeTableViewCell else { fatalError() }
        
        cell.item?.category = categories[indexPath.section].name
        
        let vc = InputFormViewController()
        vc.item = cell.item
        
        present(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(
                title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert
            )
            let yes = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                self?.categories[indexPath.section].items.remove(at: indexPath.row)
                tableView.reloadData()
                self?.collectionView.reloadData()
            })
            let no = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert, animated: true)
        }
    }
}
