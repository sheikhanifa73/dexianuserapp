//
//  NetworkServiceProtocol.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
