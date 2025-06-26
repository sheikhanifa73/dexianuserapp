//
//  NetworkError.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case networkUnavailable
    case timeout
    case unauthorized
    case unknown(String? = nil)
    case encodingError
    case rateLimitExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .networkUnavailable:
            return StringConstants.noInternet
        case .timeout:
            return "Request timeout"
        case .unauthorized:
            return "Unauthorized access"
        case .unknown(let message):
            return message ?? "Unknown error occurred"
        case .encodingError:
            return "Failed to encode request data"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        }
    }
}
