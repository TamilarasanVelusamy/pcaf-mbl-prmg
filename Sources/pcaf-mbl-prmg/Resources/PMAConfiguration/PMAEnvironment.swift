//
//  DMEnvironment.swift
//  SalesProPlus
//
//  Created by ketan on 05/12/22.
//

import Foundation

public enum PMAEnvironment {
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            // error(PMAConstants.ErrorMessage.plistNotFound, app: .peripheralManagment)
            return [:]
        }
        return dict
    }()
    static let baseUrl: String = {
        guard let rootURLstring = PMAEnvironment.infoDictionary["DM_BASE_URL"] as? String else {
            // error(PMAConstants.ErrorMessage.rootURLNotSet, app: .peripheralManagment)
            return ""
        }
        return rootURLstring
    }()
    static let selectedEnvironment: String? = {
        guard let environment = PMAEnvironment.infoDictionary["Environment"] as? String else {
            return nil
        }
        return environment
    }()

    static let locatorAPIPath: String? = {
        guard let locatorAPIPath = PMAEnvironment.infoDictionary["LOCATOR_SERVICE_PATH"] as? String else {
            return nil
        }
        return locatorAPIPath
    }()
}
