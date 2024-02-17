//
//  CategorySettingAlarmCountTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

class CategorySettingAlarmCountTableViewCell: UITableViewCell {
    static let identifier = "CategorySettingAlarmCountTableViewCell"
    
    weak var delegate: CategorySettingButtonDelegate?
    
    var data: (labelText: String, category: Category)? {
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
    
    private let alarmCycleButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.filled()
            button.configuration?.imagePadding = 8
            button.configuration?.image = UIImage(systemName: "chevron.down")?.applyingSymbolConfiguration(.init(scale: .medium))
            button.configuration?.imagePlacement = .trailing
            button.configuration?.baseForegroundColor = .font100
            button.configuration?.baseBackgroundColor = .primary60
        } else {
            button.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            button.tintColor = .font100
            button.setBackgroundColor(.primary60, for: .normal)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupAlarmCycleButton() {
        let popUpButtonAction = { [weak self] (action: UIAction) in
            self?.alarmCycleButton.setTitle(action.title, for: .normal)
            
            guard let category = self?.data?.category else { return }
            PushNotificationManager.shared.removePushNotificationsOfCategory(category: category)
            
            category.alarmCycleDayCount = Category.makeAlarmCycleNumber(string: action.title)
            CoreDataManager.shared.save()
            CoreDataManager.shared.fetchCategories()
            
            PushNotificationManager.shared.setPushNotificationsOfCategory(category: category)
        }
        
        alarmCycleButton.showsMenuAsPrimaryAction = true
        alarmCycleButton.menu = UIMenu(
            title: "주기",
            children: CategoryAlarmCycle.allCases.map {
                UIAction(title: $0.rawValue, handler: popUpButtonAction)
            }
        )
    }
    
    private let alarmCountButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.filled()
            button.configuration?.imagePadding = 8
            button.configuration?.image = UIImage(systemName: "chevron.down")?.applyingSymbolConfiguration(.init(scale: .medium))
            button.configuration?.imagePlacement = .trailing
            button.configuration?.baseForegroundColor = .font100
            button.configuration?.baseBackgroundColor = .primary60
        } else {
            button.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            button.tintColor = .font100
            button.setBackgroundColor(.primary60, for: .normal)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupAlarmCountButton() {
        let popUpButtonAction = { [weak self] (action: UIAction) in
            self?.alarmCountButton.setTitle(action.title, for: .normal)
            
            guard let category = self?.data?.category else { return }
            PushNotificationManager.shared.removePushNotificationsOfCategory(category: category)
            
            self?.data?.category.alarmPushCount = Int64(action.title) ?? 1
            CoreDataManager.shared.save()
            CoreDataManager.shared.fetchCategories()
            
            PushNotificationManager.shared.setPushNotificationsOfCategory(category: category)
        }
        
        alarmCountButton.showsMenuAsPrimaryAction = true
        alarmCountButton.menu = UIMenu(
            title: "횟수 (타 설정 변경 시 약간 오차 발생)",
            children: Array(1...7)
                .filter { $0 % 2 == 1 }
                .map { UIAction(title: $0.description, handler: popUpButtonAction) }
        )
    }
    
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
        containerView.addSubview(alarmCountButton)
        containerView.addSubview(alarmCycleButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            alarmCountButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            alarmCountButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            alarmCountButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            alarmCycleButton.trailingAnchor.constraint(equalTo: alarmCountButton.leadingAnchor, constant: -8),
            alarmCycleButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            alarmCycleButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
    }
    
    func setupData() {
        guard let data else { return }
        settingLabel.text = data.labelText
        alarmCountButton.setTitle(data.category.alarmPushCount.description, for: .normal)
        alarmCycleButton.setTitle(data.category.alarmCycleString, for: .normal)
        setupAlarmCountButton()
        setupAlarmCycleButton()
        
        toggleButtonState(isActive: data.category.isAlarmActive)
    }
    
    func toggleButtonState(isActive: Bool) {
        isActive
        ? (settingLabel.textColor = .font75)
        : (settingLabel.textColor = .font25)
        alarmCycleButton.isEnabled = isActive
        alarmCountButton.isEnabled = isActive
    }
}
