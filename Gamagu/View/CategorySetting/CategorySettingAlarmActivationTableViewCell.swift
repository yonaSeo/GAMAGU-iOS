//
//  CategorySettingAlarmActivationTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/12/24.
//

import UIKit

final class CategorySettingAlarmActivationTableViewCell: UITableViewCell {
    static let identifier = "CategorySettingAlarmActivationTableViewCell"
    
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
    
    private lazy var toggleSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .accent100
        sw.isOn = true
        sw.addAction(UIAction(handler: { [weak self] _ in
            self?.data?.category.isAlarmActive.toggle()
            CoreDataManager.shared.save()
            CoreDataManager.shared.fetchCategories()
            
            self?.delegate?.categorySettingActivationToggleValueChanged(
                section: self?.data?.section ?? 0,
                isActive: self?.toggleSwitch.isOn ?? true
            )
        }), for: .valueChanged)
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
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
        containerView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            toggleSwitch.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            toggleSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func setupData() {
        settingLabel.text = data?.labelText
        toggleSwitch.isOn = data?.category.isAlarmActive ?? true
    }
}
