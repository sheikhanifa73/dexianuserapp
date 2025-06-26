//
//  APIService.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

struct EmptyResponse: Codable {}

class APIService: APIServiceProtocol {
    private let networkManager = NetworkManager.shared
    
    func fetchUsers(page: Int = 1, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let endpoint = "\(APIEndpoints.Users.list)?page=\(page)&per_page=20"
        networkManager.request(endpoint: endpoint, responseType: [User].self, completion: completion)
    }
    
    func createUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        guard let userData = try? JSONEncoder().encode(user) else {
            completion(.failure(.encodingError))
            return
        }
        
        if let bodyString = String(data: userData, encoding: .utf8) {
        }
        
        networkManager.request(
            endpoint: APIEndpoints.Users.create,
            method: .POST,
            body: userData,
            responseType: User.self
        ) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        guard let id = user.id else {
            completion(.failure(.unknown("User ID is required for update")))
            return
        }
        
        guard let userData = try? JSONEncoder().encode(user) else {
            completion(.failure(.encodingError))
            return
        }
        
        if let bodyString = String(data: userData, encoding: .utf8) {
        }
        
        let endpoint = APIEndpoints.Users.update(id: id) // Supports PUT or PATCH
        networkManager.request(
            endpoint: endpoint,
            method: .PUT, // or .PATCH depending on API preference
            body: userData,
            responseType: User.self
        ) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteUser(id: Int, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        networkManager.request(
            endpoint: APIEndpoints.Users.delete(id: id),
            method: .DELETE,
            responseType: EmptyResponse.self // Use EmptyResponse to satisfy Codable
        ) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                // Refresh user list on failure
                self.fetchUsers(page: 1) { userResult in
                    switch userResult {
                    case .success(let users):
                        completion(.failure(error)) // Propagate the original error
                    case .failure(let fetchError):
                        completion(.failure(error)) // Propagate the original error
                    }
                }
            }
        }
    }
}

struct SingleResponse<T: Codable>: Codable {
    let data: T
}
