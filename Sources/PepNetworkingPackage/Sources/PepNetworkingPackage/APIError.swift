//
//  APIError.swift
//  
//
//  Created by Kamal Singh Thakur on 28/04/22.
//

import Foundation

public enum APIRequestError: Error, CustomStringConvertible, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
    
    public var description: String {
        switch self {
        case .invalidRequest:
            return "invalid request"
        case .badRequest:
            return "bad request"
        case .unauthorized:
            return "unauthorized"
        case .forbidden:
            return "forbidden"
        case .notFound:
            return "notFound"
        case .error4xx(let statusCode):
            return "error4xx \(statusCode)"
        case .serverError:
            return "serverError"
        case .error5xx(let statusCode):
            return "error4xx \(statusCode)"
        case .decodingError:
            return "decodingError"
        case .urlSessionFailed(let error):
            return "urlSession Failed \(error.localizedDescription)"
        case .unknownError:
            return "unknownError"
        }
    }
}

public enum DataError: Error, CustomStringConvertible {
    case dataCorrupted(String)
    case keyNotFound(CodingKey,String)
    case typeMismatch(Any.Type,String)
    case valueNotFound(Any.Type,String)
    case unknown(String)
    
    public var description: String {
        switch self {
        case .dataCorrupted(let data):
            return "data: \(data)"
        case .keyNotFound(let codingKey, let key):
            return "codingKey: \(codingKey) key: \(key)"
        case .typeMismatch(let type, let value):
            return "type: \(type) value: \(value)"
        case .valueNotFound(let key, let keyValue):
            return "key: \(key) keyValue: \(keyValue)"
        case .unknown(let error):
            return "unknown: \(error)"
        }
    }
}
