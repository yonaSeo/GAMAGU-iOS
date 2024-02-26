//
//  SettingCategoryTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/6/24.
//

import UIKit

final class SettingCategoryTableViewCell: UITableViewCell {
    static let identifier = "SettingCategoryTableViewCell"
    
    weak var delegate: SettingButtonDelegate?
    
    var labelText: String? {
        didSet { setupData() }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .font100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selected ? delegate?.categoryButtonTapped() : .none
    }
    
    func setupAccessibility() {
        self.accessibilityLabel = "카테고리 관리"
        self.accessibilityTraits = .button
    }
    
    func setupUI() {
        self.backgroundColor = .primary80
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(settingLabel)
        containerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func setupData() {
        settingLabel.text = labelText
    }
}
