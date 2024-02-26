//
//  CollectionHeaderView.swift
//  Gamagu
//
//  Created by yona on 1/30/24.
//

import UIKit

final class HomeCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    var text: String? {
        didSet {
            label.text = text
            label.accessibilityLabel = "카테고리 이름: \(text ?? "")"
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BlackHanSans-Regular", size: 28)
        label.textColor = .font75
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
