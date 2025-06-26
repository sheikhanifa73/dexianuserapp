//
//  StringConstants.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

struct StringConstants {
    // MARK: - General
    static let ok = "OK"
    static let cancel = "Cancel"
    static let error = "Error"
    static let success = "Success"
    static let loading = "Loading..."
    static let retry = "Retry"
    static let defaultConfiguration = "Default Configuration"
    
    
    // MARK: - User Management
    static let users = "Users"
    static let createUser = "Create User"
    static let editUser = "Edit User"
    static let updateUser = "Update User"
    static let userCreated = "User created successfully"
    static let userCreationFailed = "Failed to create user"
    static let loadingUsers = "Loading users..."
    static let noUsers = "No users found"
    static let delete = "Delete User"
    
    // MARK: - Form Fields
    static let name = "Name"
    static let email = "Email"
    static let gender = "Gender"
    static let status = "Status"
    static let namePlaceholder = "Enter full name"
    static let emailPlaceholder = "Enter email address"
    
    // MARK: - Validation
    static let nameRequired = "Name is required"
    static let emailRequired = "Email is required"
    static let invalidEmail = "Please enter a valid email"
    
    // MARK: - Network
    static let networkError = "Network error occurred"
    static let serverError = "Server error occurred"
    static let noInternet = "No internet connection"
    
    // MARK: - Validation Constants
    struct Validation {
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let nameMinLength = 2
        static let nameMaxLength = 50
    }
}
