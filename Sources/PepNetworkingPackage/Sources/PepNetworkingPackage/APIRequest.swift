//
//  APIRequest.swift
//  
//
//  Created by Kamal Singh Thakur on 28/04/22.
//

import Foundation
import os.log

// The Request Method
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

// Our Request Protocol
 public protocol APIRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

// Defaults and Helper Methods
extension APIRequest {
    // Defaults
    var method: HTTPMethod { return .get }
    var contentType: String { return "application/json" }
    var queryParams: [String: String]? { return nil }
    var body: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
    
    /// Serializes an HTTP dictionary to a JSON Data Object
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: Encoded JSON
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            os_log("Inavlid httpBody: %@", type: .info, "\(params)")
            return nil
        }
        return httpBody
    }
    
    /// Transforms an Request into a standard URL request
    /// - Parameter baseURL: API Base URL to be used
    /// - Returns: A ready to use URLRequest
    func asURLRequest(baseURL: String) -> URLRequest? {
      let urlPath = baseURL.appending(path)
      if urlPath.contains("%") {
        guard let url = URL(string: urlPath) else { return nil }
        os_log("Request URL: %@", type: .info, "\(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = .infinity
        return request

      } else {
        guard let urlString = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            os_log("Inavlid urlPath: %@", type: .info, "\(urlPath)")
            return nil
        }
        guard let url = URL(string: urlString) else { return nil }
        os_log("Request URL: %@", type: .info, "\(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = .infinity
        return request
      }
    }
}
