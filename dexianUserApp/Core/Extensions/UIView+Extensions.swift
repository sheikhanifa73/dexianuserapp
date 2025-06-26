//
//  UIView+Extensions.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func makeRounded(cornerRadius: CGFloat = AppConstants.Dimensions.cornerRadius) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    func fadeIn(duration: TimeInterval = AppConstants.Animation.duration) {
        alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
    
    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
