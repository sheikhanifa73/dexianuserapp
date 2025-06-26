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
        
        onLoadingStateChanged?(true)
        repository.createUser(user) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChanged?(false)
            
            switch result {
            case .success(let createdUser):
                self.onUserCreated?(createdUser)
            case .failure(let error):
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
            onValidationError?("Invalid user ID for update")
            return
        }
        
        onLoadingStateChanged?(true)
        do {
            let encodedData = try JSONEncoder().encode(user)
            repository.updateUser(user) { [weak self] result in
                guard let self = self else { return }
                self.onLoadingStateChanged?(false)
                
                switch result {
                case .success(let updatedUser):
                    self.onUserCreated?(updatedUser)
                case .failure(let error):
                    self.onError?(error)
                }
            }
        } catch {
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
