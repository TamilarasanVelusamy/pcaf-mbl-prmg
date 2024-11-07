//
//  PMLogConstant.swift
//  pcaf-mbl-prmg
//
//  Created by tamilarasan_v on 30/10/24.
//

import Foundation



struct PMAPIConstants {
    static let applicationJsonContentType = "application/json"
    static let authorization = "Authorization"
    static let bearer = "Bearer"
    static let contentType = "Content-Type"
    static let applicationJsonWithCharsetContentType = "application/json; charset=utf-8"
}

public struct PMConstant {
    static let accessToken = "UserAccessToken"
    static let isAppInstalledKey = "isAppPreviouslyInstalled"
    static let canadaLocaleID = "fr_CA"
    static let authPrefix = "user"
    static let logDirectory = FileManager.SearchPathDirectory.documentDirectory
}
