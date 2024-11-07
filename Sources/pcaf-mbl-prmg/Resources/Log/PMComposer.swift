import Foundation
import SwiftUI

public final class PMComposer {
    let logger: PMLoggerProtocol

    public init(logLevel: PMLogLevel, logFileMessages: @escaping ((PMLogLevel, String) -> Void)) {

        func composePMLogger() -> PMLoggerProtocol {
            PMLogger(logType: logLevel, log: logFileMessages)
        }
        self.logger = composePMLogger()
    }
    
    public func launchDeviceManagement() -> some View {
        PMLog.shared.logger = self.logger
        PMLog.shared.logger?.log(.verbose, message: "launch Device Management")
        return BannerView()
    }
    public func launchFirmwareUpdates() {
        let updates = PMPushHandler().getUpdatesCount()
        PMLog.shared.logger?.log(.verbose, message: "Push Notification Device Management")
    }
}
