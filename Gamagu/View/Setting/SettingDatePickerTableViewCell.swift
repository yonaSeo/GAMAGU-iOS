//
//  SettingTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/5/24.
//

import UIKit

class SettingDatePickerTableViewCell: UITableViewCell {
    static let identifier = "SettingDatePickerTableViewCell"
    
    weak var delegate: SettingButtonDelegate?
    
    var data: (labelText: String, date: Date)? {
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
    
    public lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.tintColor = .accent100
        dp.preferredDatePickerStyle = .compact
        dp.datePickerMode = .time
        dp.minuteInterval = 15
        dp.locale = Locale(identifier: "ko-KR")
        dp.timeZone = .autoupdatingCurrent
        dp.date = Date()
        dp.addAction(UIAction(handler: { [weak self] action in
            guard let self else { return }
            self.delegate?.dateValueChanged(type: self.data?.labelText ?? "", date: self.datePicker.date)
        }), for: .valueChanged)
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
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
        containerView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            datePicker.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
    }
    
    func setupData() {
        settingLabel.text = data?.labelText
        datePicker.date = data?.date ?? Date()
    }
}
