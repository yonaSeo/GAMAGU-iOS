//
//  CollectionBackgroundView.swift
//  Gamagu
//
//  Created by yona on 1/31/24.
//

import UIKit

final class CollectionBackgroundView: UICollectionReusableView {
    static let identifier = "CollectionBackgroundView"
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary80
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 48), // 바꾸기 주의 ⚠️
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48), // 바꾸기 주의 ⚠️
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
