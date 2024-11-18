//
//  GetFirmwareFileRequest.swift
//  SalesProPlus
//
//  Created by ketan on 02/12/22.
//

import Foundation

struct GetPeripheralFileRequest: APIRequest {
    var path: String
    var method: HTTPMethod = .get
    var contentType: String = "application/json"
    var body: Data?
    var headers: [String: String]?
    init() {
        self.path = ""
        //TODO: add PMAPIConstants 
        self.headers = [PMAPIConstants.contentType: PMAPIConstants.applicationJsonWithCharsetContentType]
    }
}
