//
//  CategorySettingPositionTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/10/24.
//

import UIKit

class CategorySettingPositionTableViewCell: UITableViewCell {
    static let identifier = "CategorySettingPositionTableViewCell"
    
    weak var delegate: CategorySettingButtonDelegate?
    
    var data: (labelText: String, category: Category, section: Int)? {
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
    
    private lazy var positionUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.up.fill"), for: .normal)
        button.tintColor = .font100
        button.setBackgroundColor(.primary100, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let data = self?.data else { return }
            self?.delegate?.categorySettingPositionUpButtonTapped(section: self?.data?.section ?? 0)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var positionDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.down.fill"), for: .normal)
        button.tintColor = .font100
        button.setBackgroundColor(.primary100, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let data = self?.data else { return }
            self?.delegate?.categorySettingPositionDownButtonTapped(section: self?.data?.section ?? 0)
        }), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .primary80
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(settingLabel)
        containerView.addSubview(positionUpButton)
        containerView.addSubview(positionDownButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            positionDownButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            positionDownButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            positionDownButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            positionUpButton.trailingAnchor.constraint(equalTo: positionDownButton.leadingAnchor, constant: -8),
            positionUpButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            positionUpButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
    }
    
    func setupData() {
        guard let data else { return }
        settingLabel.text = data.labelText
        positionUpButton.isEnabled =
            data.category.orderNumber != CoreDataManager.shared.getMinOrderNumberCategory() ? true : false
        positionDownButton.isEnabled =
            data.category.orderNumber != CoreDataManager.shared.getMaxOrderNumberCategory() ? true : false
    }

}
