//
//  UserListViewModel.swift
//  dexianUserApp
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

protocol UserListViewDelegate: BaseViewProtocol {
    func didLoadUsers()
    func didFailToLoadUsers(error: NetworkError)
}

class UserListViewModel: BaseViewModel {
    private let repository: UserRepositoryProtocol
    private(set) var users: [User] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    
    weak var delegate: UserListViewDelegate?
    
    init(view: UserListViewDelegate, repository: UserRepositoryProtocol = UserRepositoryImpl()) {
        self.repository = repository
        self.delegate = view
        super.init(view: view)
    }
    
    func loadUsers() {
        guard !isLoading else { return }
        
        isLoading = true
        if users.isEmpty {
            showLoading()
        }
        
        repository.getUsers(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.hideLoading()
                
                switch result {
                case .success(let users):
                    if self.currentPage == 1 {
                        self.users = users
                    } else {
                        self.users.append(contentsOf: users)
                    }
                    
                    self.totalPages = users.isEmpty ? self.currentPage : self.currentPage + 1
                    self.delegate?.didLoadUsers()
                    
                case .failure(let error):
                    self.delegate?.didFailToLoadUsers(error: error)
                }
            }
        }
    }
    
    func refreshUsers() {
        currentPage = 1
        users.removeAll()
        loadUsers()
    }
    
    func loadMoreUsers() {
        guard currentPage < totalPages, !isLoading else { return }
        currentPage += 1
        loadUsers()
    }
    
    
    func didSaveUser(_ user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            // Update existing user
            users[index] = user
        } else {
            // Add new user
            users.insert(user, at: 0)
        }
        DispatchQueue.main.async {
            self.delegate?.didLoadUsers()
        }
    }
}
