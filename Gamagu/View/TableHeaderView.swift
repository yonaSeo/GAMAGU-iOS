//
//  TableHeaderView.swift
//  Gamagu
//
//  Created by yona on 1/31/24.
//

import UIKit

final class TableHeaderView: UITableViewHeaderFooterView {
    static let identifier = "TableHeaderView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .font50
        label.attributedText = .init(string: "헤더", attributes: [
            .font: UIFont(name: "BlackHanSans-Regular", size: 28) as Any,
            .foregroundColor: UIColor.font75])
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
