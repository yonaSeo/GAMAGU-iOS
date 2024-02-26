//
//  CollectionViewCell.swift
//  Gamagu
//
//  Created by yona on 1/31/24.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    var item: Item? {
        didSet { setupData() }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BlackHanSans-Regular", size: 24)
        label.textColor = .font100
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .font75
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData() {
        titleLabel.text = item?.title
        contentLabel.text = item?.content
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = "제목: \(item?.title ?? "")"
        self.accessibilityValue = "내용: \(item?.content ?? "")"
    }
    
    override func accessibilityElementDidBecomeFocused() {
        guard let item else { return }
        let categoryIndex = CoreDataManager.shared.getCategoryIndex(category: item.category!) ?? 0
        let currentItemIndex = CoreDataManager.shared.getItemIndexOfCategory(item: item) ?? 0
        if let tabBarController = window?.rootViewController as? UITabBarController,
           let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
           let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.collectionView.scrollToItem(
                at: IndexPath(item: currentItemIndex, section: categoryIndex),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }
    
    func setupCell() {
        self.backgroundColor = .primary40
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),
        ])
    }
}
