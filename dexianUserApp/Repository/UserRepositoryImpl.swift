//
//  UserRepositoryImpl .swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

class UserRepositoryImpl: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func getUsers(page: Int, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        apiService.fetchUsers(page: page, completion: completion)
    }
    
    func createUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        apiService.createUser(user, completion: completion)
    }
    
    func updateUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        apiService.updateUser(user, completion: completion)
    }
    
    func deleteUser(id: Int, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        apiService.deleteUser(id: id, completion: completion)
    }
}
