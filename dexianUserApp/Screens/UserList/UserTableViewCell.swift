//
//  UserTableViewCell.swift
//  dexianUser
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
        view.layer.borderWidth = 1
        view.layer.borderColor = AppConstants.Colors.separatorColor.cgColor
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
        label.font = AppConstants.Fonts.subtitle
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.subtitle
        label.textColor = AppConstants.Colors.textColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.body
        label.textColor = AppConstants.Colors.textColor.withAlphaComponent(0.7)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.body
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.body
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
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubviews(avatarView, nameLabel, emailLabel, statusLabel, genderLabel)
        avatarView.addSubview(avatarLabel)
    }
    
    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 50),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -12),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -12),
            
            genderLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            genderLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            genderLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(equalToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        genderLabel.text = "👤 \(user.gender.displayName)"
        
        // Configure avatar
        let initials = String(user.name.prefix(2).uppercased())
        avatarLabel.text = initials
        
        // Configure status
        statusLabel.text = user.status.displayName
        switch user.status {
        case .active:
            statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = UIColor.systemGreen
        case .inactive:
            statusLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            statusLabel.textColor = UIColor.systemRed
        }
    }
}
