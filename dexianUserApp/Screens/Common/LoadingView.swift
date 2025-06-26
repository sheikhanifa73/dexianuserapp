//
//  LoadingView.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

class LoadingView: UIView {
    // MARK: - UI Components
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView.backgroundColor = AppConstants.Colors.background
        containerView.makeRounded()
        containerView.addShadow()
        
        activityIndicator.color = AppConstants.Colors.primary
        
        messageLabel.text = StringConstants.loading
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = AppConstants.Colors.textColor
        
        addSubview(containerView)
        containerView.addSubviews(activityIndicator, messageLabel)
        
        // Enable Auto Layout for views
        [self, containerView, activityIndicator, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 120),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    func show() {
        activityIndicator.startAnimating()
        fadeIn()
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}
