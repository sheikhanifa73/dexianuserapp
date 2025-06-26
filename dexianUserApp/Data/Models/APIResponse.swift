//
//  APIResponse.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let data: T?
    let message: String?
    let error: String?
}

struct APIListResponse<T: Codable>: Codable {
    let data: [T]
    let pagination: Pagination?
}

struct Pagination: Codable {
    let total: Int
    let pages: Int
    let page: Int
    let limit: Int
}
