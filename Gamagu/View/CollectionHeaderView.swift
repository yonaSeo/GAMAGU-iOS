//
//  CollectionHeaderView.swift
//  Gamagu
//
//  Created by yona on 1/30/24.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .font50
        label.attributedText = .init(string: "헤더", attributes: [
            .font: UIFont(name: "BlackHanSans-Regular", size: 28) as Any,
            .foregroundColor: UIColor.white])
        return label
    }()
    
    func configure() {
        addSubview(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
