//
//  CreateUserViewModel.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

class CreateUserViewModel {
    var onUserCreated: ((User) -> Void)?
    var onError: ((NetworkError) -> Void)?
    var onValidationError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepositoryImpl()) {
        self.repository = repository
    }
    
    func createUser(_ user: User) {
        guard !user.name.isEmpty else {
            onValidationError?("Name cannot be empty")
            return
        }
        guard isValidEmail(user.email) else {
            onValidationError?("Invalid email format")
            return
        }
        
        Logger.log("Creating user: \(user.name)")
        onLoadingStateChanged?(true)
        repository.createUser(user) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChanged?(false)
            
            switch result {
            case .success(let createdUser):
                Logger.log("Created user: \(createdUser.name), ID: \(String(describing: createdUser.id))")
                self.onUserCreated?(createdUser)
            case .failure(let error):
                Logger.log(" Create user error: \(error.localizedDescription)")
                self.onError?(error)
            }
        }
    }
    
    func updateUser(_ user: User) {
        guard !user.name.isEmpty else {
            onValidationError?("Name cannot be empty")
            return
        }
        guard isValidEmail(user.email) else {
            onValidationError?("Invalid email format")
            return
        }
        guard let userId = user.id else {
            Logger.log("Invalid user ID for update: \(String(describing: user.id))")
            onValidationError?("Invalid user ID for update")
            return
        }
        
        Logger.log(" Updating user: \(user.name), ID: \(userId)")
        onLoadingStateChanged?(true)
        do {
            let encodedData = try JSONEncoder().encode(user)
            Logger.log(" Encoded request body: \(String(data: encodedData, encoding: .utf8) ?? "<Binary Data>")")
            repository.updateUser(user) { [weak self] result in
                guard let self = self else { return }
                self.onLoadingStateChanged?(false)
                
                switch result {
                case .success(let updatedUser):
                    Logger.log(" Updated user: \(updatedUser.name), ID: \(String(describing: updatedUser.id))")
                    self.onUserCreated?(updatedUser)
                case .failure(let error):
                    Logger.log(" Update user error: \(error.localizedDescription)")
                    self.onError?(error)
                }
            }
        } catch {
            Logger.log(" Encoding error: \(error.localizedDescription)")
            onLoadingStateChanged?(false)
            onError?(.decodingError)
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
