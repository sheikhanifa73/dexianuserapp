//
//  NetworkManager.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation
import Network

class NetworkManager: NetworkServiceProtocol {
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let baseURL: String
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // Set timeout to 30 seconds
        self.session = URLSession(configuration: configuration)
        self.baseURL = APIConstants.baseURL + "/public/v2"
    }
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let fullURL = baseURL + endpoint
        Logger.log("📡 Full URL: \(fullURL)")
        guard let url = URL(string: fullURL) else {
            Logger.log(" Invalid URL: \(fullURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        guard checkNetworkReachability() else {
            Logger.log(" Network unavailable")
            completion(.failure(.networkUnavailable))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(APIConstants.Headers.applicationJSON, forHTTPHeaderField: APIConstants.Headers.contentType)
        request.setValue(APIConstants.Headers.applicationJSON, forHTTPHeaderField: APIConstants.Headers.accept)
        request.setValue("Bearer \(APIConstants.bearerToken)", forHTTPHeaderField: APIConstants.Headers.authorization)
        
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            request.httpBody = body
            Logger.log(" Request Body: \(bodyString)")
        } else if let body = body {
            request.httpBody = body
            Logger.log(" Request Body: <Binary Data, \(body.count) bytes>")
        }
        
        Logger.log(" Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    Logger.log(" Network Error: \(error.localizedDescription)")
                    completion(.failure(.networkUnavailable))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    Logger.log(" Invalid response")
                    completion(.failure(.unknown("Invalid response")))
                    return
                }
                
                Logger.log("Response Status: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8), !responseString.isEmpty {
                    Logger.log("Response Data: \(responseString)")
                } else {
                    Logger.log(" Response Data: <Empty>")
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    guard responseType != Void.self else {
                        Logger.log(" Success: No content expected for response type Void")
                        completion(.success(() as! T))
                        return
                    }
                    
                    guard let data = data else {
                        Logger.log(" No data received for \(method.rawValue) request")
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase // Adjust if API uses snake_case
                        let decodedResponse = try decoder.decode(responseType, from: data)
                        Logger.log("Decoded Response: \(String(describing: decodedResponse))")
                        completion(.success(decodedResponse))
                    } catch {
                        Logger.log(" Decoding Error: \(error)")
                        completion(.failure(.decodingError))
                    }
                    
                case 204:
                    // Handle 204 No Content, skip decoding for EmptyResponse or Void with empty data
                    if responseType == Void.self || (NSStringFromClass(responseType as! AnyClass) == "EmptyResponse") {
                        if data == nil || (data?.isEmpty ?? true) {
                            Logger.log("Success: No content returned (204) for \(method.rawValue) request")
                            completion(.success(() as! T))
                        } else {
                            do {
                                let decoder = JSONDecoder()
                                let decodedResponse = try decoder.decode(responseType, from: data!)
                                Logger.log(" Decoded Response: \(String(describing: decodedResponse))")
                                completion(.success(decodedResponse))
                            } catch {
                                Logger.log(" Decoding Error: \(error)")
                                completion(.failure(.decodingError))
                            }
                        }
                    } else {
                        Logger.log(" Error: Expected data for response type \(responseType), but received 204 No Content")
                        completion(.failure(.noData))
                    }
                    
                case 401:
                    Logger.log(" Unauthorized: Check if API token is valid")
                    completion(.failure(.unauthorized))
                    
                case 429:
                    Logger.log(" Rate limit exceeded")
                    completion(.failure(.rateLimitExceeded))
                    
                case 400...499:
                    Logger.log(" Client Error: Status Code \(httpResponse.statusCode)")
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8), !errorMessage.isEmpty {
                        Logger.log(" Client Error Details: \(errorMessage)")
                    }
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    
                case 500...599:
                    Logger.log(" Server Error: Status Code \(httpResponse.statusCode)")
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8), !errorMessage.isEmpty {
                        Logger.log(" Server Error Details: \(errorMessage)")
                    }
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    
                default:
                    Logger.log(" Unexpected status code: \(httpResponse.statusCode)")
                    completion(.failure(.unknown("Unexpected status code: \(httpResponse.statusCode)")))
                }
            }
        }
        
        task.resume()
    }
    
    private func checkNetworkReachability() -> Bool {
        let monitor = NWPathMonitor()
        var isReachable = false
        let semaphore = DispatchSemaphore(value: 0)
        
        monitor.pathUpdateHandler = { path in
            isReachable = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        _ = semaphore.wait(timeout: .now() + 2)
        monitor.cancel()
        return isReachable
    }
}
