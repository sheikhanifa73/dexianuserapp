//
//  APIConstants.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://gorest.co.in"
    static let apiVersion = "/public/v2"
    static let timeout: TimeInterval = 30.0
    
    // MARK: - Authentication
    static let bearerToken = "32e1a21ea91d96b1f360e66c08ce15ba88f64e73ab96c3e7ed3e0e5cd9d88ea9" //90 Click Limnited 
    
    // MARK: - Endpoints
    struct Endpoints {
        static let users = "/users"
        static let posts = "/posts"
        static let comments = "/comments"
        static let todos = "/todos"
    }
    
    // MARK: - HTTP Headers
    struct Headers {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let applicationJSON = "application/json"
    }
    
    // MARK: - Response Keys
    struct ResponseKeys {
        static let data = "data"
        static let message = "message"
        static let error = "error"
    }
}

