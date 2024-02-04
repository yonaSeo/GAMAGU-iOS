//
//  UIButton+Ext.swift
//  Gamagu
//
//  Created by yona on 1/29/24.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    @available(iOS 15.0, *)
    func newCustomButtonMaker(title: String, color: UIColor, imageName: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        configuration.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        configuration.imagePlacement = .top
        configuration.baseForegroundColor = color
        
        self.configuration = configuration
    }
    
    func oldCustomButtonMaker(title: String, color: UIColor, imageName: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 12, weight: .heavy)
        self.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.imageView?.tintColor = color
        self.alignTextBelow(spacing: 2)
    }
    
    func alignTextBelow(spacing: CGFloat = 4.0) {
        guard let image = self.imageView?.image else { return }
        guard let titleLabel = self.titleLabel, let titleText = titleLabel.text else { return }
        
        let titleSize =
            titleText.size(withAttributes: [NSAttributedString.Key.font: titleLabel.font as Any])
        
        titleEdgeInsets =
            UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets =
            UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}
