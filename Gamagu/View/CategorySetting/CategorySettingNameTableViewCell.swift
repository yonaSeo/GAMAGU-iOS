//
//  CategorySettingTableViewCell.swift
//  Gamagu
//
//  Created by yona on 2/7/24.
//

import UIKit

class CategorySettingNameTableViewCell: UITableViewCell {
    static let identifier = "CategorySettingNameTableViewCell"
    
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
    
    private let editButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.filled()
            button.configuration?.imagePadding = 8
            button.configuration?.image = UIImage(systemName: "pencil")?.applyingSymbolConfiguration(.init(scale: .medium))
            button.configuration?.imagePlacement = .trailing
            button.configuration?.baseForegroundColor = .font100
            button.configuration?.baseBackgroundColor = .primary60
        } else {
            button.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
            button.setImage(UIImage(systemName: "pencil"), for: .normal)
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
        containerView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            settingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            settingLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            editButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            editButton.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
    }
    
    func setupData() {
        guard let labelText = data?.labelText else { return }
        guard let categoryName = data?.category.name else { return }
        settingLabel.text = labelText
        editButton.setTitle(categoryName, for: .normal)
        
        editButton.addAction(UIAction(handler: { [weak self] _ in
            let alert = UIAlertController(title: "카테고리 수정", message: "변경할 카테고리 이름을 입력하세요", preferredStyle: .alert)
            let yes = UIAlertAction(title: "확인", style: .default, handler: { [weak alert, self] _ in
                guard let text = alert?.textFields?[0].text else { return }
                self?.editButton.setTitle(text, for: .normal)
                
                self?.data?.category.name = text
                CoreDataManager.shared.save()
                CoreDataManager.shared.fetchCategories()
            })
            let no = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addTextField { [weak self] tf in
                tf.placeholder = "ex) D-Day3, 영단어"
                tf.delegate = self
            }
            alert.addAction(yes)
            alert.addAction(no)
            
            guard let vc = self?.delegate as? CategorySettingViewController else { return }
            vc.present(alert, animated: true)
        }), for: .touchUpInside)
    }
}

extension CategorySettingNameTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return (text.count + string.count - range.length) <= 10
    }
}
