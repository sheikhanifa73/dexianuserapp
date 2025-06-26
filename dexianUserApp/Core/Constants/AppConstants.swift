//
//  AppConstants.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

struct AppConstants {
    // MARK: - App Info
    static let appName = "DexianUser"
    static let version = "1.0.0"
    
    // MARK: - Colors
    struct Colors {
        static let primary = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        static let secondary = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        static let success = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)
        static let error = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        static let background = UIColor.systemBackground
        static let separatorColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)
        static let textColor = UIColor.label
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let title = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let subtitle = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let body = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    // MARK: - Dimensions
    struct Dimensions {
        static let cornerRadius: CGFloat = 8.0
        static let padding: CGFloat = 16.0
        static let buttonHeight: CGFloat = 50.0
        static let cellHeight: CGFloat = 80.0
    }
    
    // MARK: - Animation
    struct Animation {
        static let duration: TimeInterval = 0.3
        static let splashDelay: TimeInterval = 2.0
    }
}
