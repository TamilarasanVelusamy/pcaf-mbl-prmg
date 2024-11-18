//
//  APIClient.swift
//  
//
//  Created by Kamal Singh Thakur on 28/04/22.
//

import Foundation
import Combine
import os.log

public struct APILogs {
  public static var logsText = ""
}

public struct APIClient {
    
    public var baseURL: String!
    public var networkRequest: NetworkDispatcher!

    public init(baseURL: String, networkRequest: NetworkDispatcher = NetworkDispatcher()) {
        self.baseURL = baseURL
        self.networkRequest = networkRequest
    }
    
    /// get a Request and returns a publisher
    /// - Parameter request: Request to Dispatch
    /// - Returns: A publisher containing decoded data or an error
    public func get<T: Codable>(_ request: APIRequest, model: T.Type) -> AnyPublisher<T, APIRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            os_log("Inavlid request URL path: %@", type: .info, "\(request.path)")
            return Fail(outputType: model.self, failure: APIRequestError.badRequest).eraseToAnyPublisher()
        }
        typealias RequestPublisher = AnyPublisher<T, APIRequestError>
        let requestPublisher: RequestPublisher = networkRequest.dispatch(request: urlRequest, model: T.self)
        return requestPublisher.eraseToAnyPublisher()
    }
    
    /// getData a Request and returns a publisher
    /// - Parameter request: Request to Dispatch
    /// - Returns: A publisher containing binary data or an error
    public func get(_ request: APIRequest) -> AnyPublisher<Data, APIRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            os_log("Inavlid request URL path: %@", type: .info, "\(request.path)")
            return Fail(outputType: Data.self, failure: APIRequestError.badRequest).eraseToAnyPublisher()
        }
        typealias RequestPublisher = AnyPublisher<Data, APIRequestError>
        let requestPublisher: RequestPublisher = networkRequest.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }

    public func download(_ request: APIRequest,
                         filePathUrl: URL,
                         completionHandler: @escaping (Result<URL, APIRequestError>) -> Void) {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            os_log("Inavlid request URL path: %@", type: .info, "\(request.path)")
            completionHandler(.failure(APIRequestError.badRequest))
            return
        }
        networkRequest.download(request: urlRequest, filePathUrl:filePathUrl) { result in
            switch result {
            case .success(let url):
                completionHandler(.success(url))
                return
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
}
