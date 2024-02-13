//
//  TableViewCell.swift
//  Gamagu
//
//  Created by yona on 1/31/24.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    var item: Item? {
        didSet { setupData() }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BlackHanSans-Regular", size: 20)
        label.textColor = UIColor.font100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .primary80
        self.selectionStyle = .none
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData() {
        titleLabel.text = item?.title
    }
    
    func setupUI() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
        ])
    }
}
