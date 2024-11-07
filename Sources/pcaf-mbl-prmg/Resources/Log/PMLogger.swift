//
//  PMLogger.swift
//  pcaf-mbl-prmg
//
//  Created by Ketan Saini on 2024-10-30.
//

import Foundation

public protocol PMLoggerProtocol {
    func log(_ level: PMLogLevel, message: String)
}

/// - verbose: Log messages for any LogLevel
/// - warning: Log messages only with LogLevel  warning into log file
/// - error: Log messages only with LogLevel  error into log file

public enum PMLogLevel: CaseIterable {
    case verbose
    case warning
    case error
}

public class PMLogger: PMLoggerProtocol {
    /// Log level set by client
    let logLevel: PMLogLevel
    /// Callback function linked to platform
    let log: ((PMLogLevel, String) -> Void)

    init(logType: PMLogLevel,
         log: @escaping ((PMLogLevel, String) -> Void)) {
        self.logLevel = logType
        self.log = log
    }

    /// - level: Passed in LogLevel for message to be logged
    /// - message: Log message

    public func log(_ level: PMLogLevel, message: String) {
        if logLevel == .verbose {
            log(level, message)
        } else if logLevel == .error && level == .error {
            log(.error, message)
        } else if logLevel == .warning && level == .warning {
            log(.warning, message)
        }
    }
}

class PMLog {
    static let shared = PMLog()
    var logger: PMLoggerProtocol?
    private init() {}
}
