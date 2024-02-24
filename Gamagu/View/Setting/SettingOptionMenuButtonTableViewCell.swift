//
//  SettingOptionMenuButtonTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/6/24.
//

import UIKit

class SettingOptionMenuButtonTableViewCell: UITableViewCell {
    static let identifier = "SettingOptionMenuButtonTableViewCell"
    
    weak var delegate: SettingButtonDelegate?
    
    var data: (labelText: String, selectedOption: String, options: [String], isActive: Bool?)? {
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
    
    private let optionButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.filled()
            button.configuration?.imagePadding = 8
            button.configuration?.image = UIImage(systemName: "chevron.down")?.applyingSymbolConfiguration(.init(scale: .medium))
            button.configuration?.imagePlacement = .trailing
            // button.configuration?.baseForegroundColor = .font25
            button.configuration?.baseBackgroundColor = .primary60
        } else {
            button.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            // button.tintColor = .font25
            button.setBackgroundColor(.primary60, for: .normal)
        }
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupOptionButton(options: [String]) {
        let popUpButtonAction = { [weak self] (action: UIAction) in
            guard let self else { return }
            self.optionButton.setTitle(options.first { $0 == action.title }, for: .normal)
            self.optionButton.setTitleColor(.font75, for: .normal)
            self.delegate?.optionMenuValueChnaged(
                type: self.data?.labelText ?? "",
                selectedOption: action.title
            )
        }
        
        optionButton.showsMenuAsPrimaryAction = true
        optionButton.menu = UIMenu(
            title: "타입 선택",
            children: options.map { UIAction(title: $0, handler: popUpButtonAction) }
            
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
        containerView.addSubview(optionButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            optionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            optionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            optionButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
    }
    
    func setupData() {
        guard let data else { return }
        settingLabel.text = data.labelText
        setupOptionButton(options: data.options)
        optionButton.setTitle(data.selectedOption, for: .normal)
        
        if data.isActive != nil && data.labelText == "알림음 종류" {
            toggleButtonState(isActive: data.isActive!)
        }
    }

    func toggleButtonState(isActive: Bool) {
        isActive
        ? (settingLabel.textColor = .font75)
        : (settingLabel.textColor = .font25)
        optionButton.isEnabled = isActive
    }
}
