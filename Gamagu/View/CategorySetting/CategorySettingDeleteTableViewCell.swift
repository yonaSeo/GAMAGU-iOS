//
//  CategorySettingDeleteTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

class CategorySettingDeleteTableViewCell: UITableViewCell {
    static let identifier = "CategorySettingDeleteTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "삭제"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .primary20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .primary20
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAccessibility()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAccessibility() {
        self.accessibilityLabel = "카테고리 삭제"
        self.accessibilityTraits = .button
    }
    
    func setupUI() {
        self.backgroundColor = .primary100
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(settingLabel)
        containerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
