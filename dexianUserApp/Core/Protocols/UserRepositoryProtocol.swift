//
//  UserRepositoryProtocol.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUsers(page: Int, completion: @escaping (Result<[User], NetworkError>) -> Void)
    func createUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void)
    func updateUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void)
    func deleteUser(id: Int, completion: @escaping (Result<Void, NetworkError>) -> Void)
}

