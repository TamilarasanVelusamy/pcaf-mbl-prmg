//
//  NetworkDispatcher.swift
//  
//
//  Created by Kamal Singh Thakur on 28/04/22.
//

import Foundation
import Combine
import os.log

public class SessionDelegate: NSObject, URLSessionDelegate {
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.serverTrust == nil {
            completionHandler(.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }
    }
}

public struct NetworkDispatcher {
    
    let urlSession = URLSession(configuration: .default,
                                delegate: SessionDelegate(),
                                delegateQueue: OperationQueue.main)
    
    public init() { }
    
    /// Dispatches an URLRequest and returns a publisher
    /// - Parameter request: URLRequest
    /// - Returns: A publisher with the provided decoded data or an error
    public func dispatch<T: Codable>(request: URLRequest,
                                     model: T.Type) -> AnyPublisher<T, APIRequestError> {
        return urlSession
            .dataTaskPublisher(for: request)
            // Map on Request response
            .tryMap({ data, response in
                // If the response is invalid, throw an error
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    if let logs = String(data: data, encoding: .utf8) {
                        APILogs.logsText.append("\n\(logs)")
                    }
                    throw httpError(response.statusCode)
                }
                // Return Response data
                return data
            })
            // Decode data using our ReturnType
            .decode(type: T.self, decoder: JSONDecoder())
            // Handle any decoding errors
            .mapError { error in
                os_log("Error in API: %@ Error: %@", type: .error, "\(request.url ?? URL(string: "")!)", "\(error.localizedDescription)")
                return handleError(error)
            }
            // And finally, expose our publisher
            .eraseToAnyPublisher()
    }
    /// Dispatches an URLRequest and returns a publisher
    /// - Parameter request: URLRequest
    /// - Returns: A publisher with the provided binary data or an error
    public func dispatch(request: URLRequest) -> AnyPublisher<Data, APIRequestError> {
        return urlSession
            .dataTaskPublisher(for: request)
            // Map on Request response
            .tryMap({ data, response in
                if let response1 = response as? HTTPURLResponse {
                    let str = String(decoding: data, as: UTF8.self)
                    print("response.statusCode \(response1.statusCode), \(response1), data: \(str)")
                }

                // If the response is invalid, throw an error
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    if let logs = String(data: data, encoding: .utf8) {
                        APILogs.logsText.append("\n\(logs)")
                    }
                    throw httpError(response.statusCode)
                }
                print(String(data: data, encoding: .utf8))
                // Return Response data
                return data
            })
            // Handle any decoding errors
            .mapError { error in
                os_log("Error in API: %@ Error: %@", type: .error, "\(request.url ?? URL(string: "")!)", "\(error.localizedDescription)")
                return handleError(error)
            }
            // And finally, expose our publisher
            .eraseToAnyPublisher()
    }
    // To download files from server
    public func download(request: URLRequest,
                         filePathUrl: URL,
                         completionHandler: @escaping (Result<URL, APIRequestError>) -> Void) {
                
        let task = urlSession.downloadTask(with: request) { (url, response, error) in
            if let url = url, error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) {
                // Success
                os_log("Zip file successfully downloaded status code: %@", type: .info, "\(statusCode)")
                completionHandler(.success(url))
            } else {
                os_log("Error creating a file: %@ error: %@" , type: .error, "\(filePathUrl)", "\(String(describing: error?.localizedDescription))")
                if let error = error {
                    completionHandler(.failure( handleError(error)))
                } else {
                    completionHandler(.failure(.unknownError))
                }
                return
            }
        }
        task.resume()
    }
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    private func httpError(_ statusCode: Int) -> APIRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    private func handleError(_ error: Error) -> APIRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as APIRequestError:
            return error
        default:
            return .unknownError
        }
    }
}
