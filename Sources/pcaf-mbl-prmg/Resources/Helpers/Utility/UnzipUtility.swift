//
//  UnzipUtility.swift
//  DeviceManagerApp
//
//  Created by ketan on 30/09/22.
//

import Foundation
import Zip

struct UnzipUtility {
    
    //MARK: - function for un-zip File
    
    /// Unzip file from location
    /// - Parameter sourcePath: File Path
    /// - Returns: Unzipped file URL
    static func unzipFile(sourcePath: String, deviceType: String) -> URL {
        let sourceURL = URL(fileURLWithPath: sourcePath)
        let destPath = sourceURL.deletingLastPathComponent()
        do {
            if(deviceType == PMAConstants.Titles.unitech){
                try Zip.unzipFile(sourceURL, destination: destPath.deletingLastPathComponent(), overwrite: true, password: nil)
            }else{
                try Zip.unzipFile(sourceURL, destination: destPath, overwrite: true, password: nil)
            }
        } catch {
            PMLog.shared.logger?.log(.verbose, message: "Extraction of ZIP archive failed with error:\(error)")
        }
        return destPath
    }
}
