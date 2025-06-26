//
//  UserTableViewCell.swift
//  dexianUserApp
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Colors.background
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Colors.primary
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppConstants.Colors.textColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = AppConstants.Colors.textColor.withAlphaComponent(0.7)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = AppConstants.Colors.textColor.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        emailLabel.text = nil
        genderLabel.text = nil
        avatarLabel.text = nil
        statusLabel.text = nil
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Ensure proper content view setup
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubviews(avatarView, nameLabel, emailLabel, statusLabel, genderLabel)
        avatarView.addSubview(avatarLabel)
    }
    
    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            // Container view with proper margins to prevent merging
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Avatar view
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 50),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            
            // Avatar label centered in avatar view
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Name label with proper spacing
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -12),
            
            // Email label
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -12),
            
            // Gender label
            genderLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            genderLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            genderLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            // Status label positioned on the right
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(equalToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Ensure minimum container height
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        genderLabel.text = "👤 \(user.gender.displayName)"
        
        // Configure avatar with proper initials handling
        let nameComponents = user.name.components(separatedBy: " ")
        let initials: String
        if nameComponents.count >= 2 {
            initials = String(nameComponents[0].prefix(1).uppercased() + nameComponents[1].prefix(1).uppercased())
        } else {
            initials = String(user.name.prefix(2).uppercased())
        }
        avatarLabel.text = initials
        
        // Configure status with proper styling
        statusLabel.text = user.status.displayName
        switch user.status {
        case .active:
            statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = UIColor.systemGreen
        case .inactive:
            statusLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            statusLabel.textColor = UIColor.systemRed
        }
        
        // Force layout update
        setNeedsLayout()
        layoutIfNeeded()
    }
}
