//
//  FWFileUtils.swift
//  FWDownloadManager
//

import UIKit

class PMAFileUtils: NSObject {
    
    // MARK: - Helpers functions.
 
    /// Move file to documents directory
    /// - Parameters:
    ///   - url: URL
    ///   - directory: String
    ///   - name: File name
    /// - Returns: Result, Error and URL
    static func moveFile(fromUrl url:URL,
                         toDirectory directory:String? ,
                         withName name:String) -> (Bool, Error?, URL?) {
        var newUrl:URL
        if let directory = directory {
            let directoryCreationResult = self.createDirectoryIfNotExists(withName: directory)
            guard directoryCreationResult.0 else {
                return (false, directoryCreationResult.1, nil)
            }
            newUrl = self.documentsDirectoryPath().appendingPathComponent(directory).appendingPathComponent(name)
        } else {
            newUrl = self.documentsDirectoryPath().appendingPathComponent(name)
        }
        do {
            try FileManager.default.moveItem(at: url, to: newUrl)
            return (true, nil, newUrl)
        } catch {
            return (false, error, nil)
        }
    }
    
    
    /// Get current documents directory path
    /// - Returns: URL
    static func documentsDirectoryPath() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsPath)
    }
    
    /// Create directory in documents folder if not exists
    /// - Parameter name: path name
    /// - Returns: Result, Error
    static func createDirectoryIfNotExists(withName name:String) -> (Bool, Error?)  {
        let directoryUrl = self.documentsDirectoryPath().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: directoryUrl.path) {
            return (true, nil)
        }
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            return (true, nil)
        } catch  {
            return (false, error)
        }
    }
    
}

extension PMAFileUtils {
    
    /// func for iterate swiftch case
    /// - Parameters:
    ///   - deviceType: clouser retrun device type
    ///   - model: json dictonary
    static  func switchCase(deviceType: String, model: FirmwarePackage){
        switch deviceType{
        case PMAConstants.Titles.brother:
            saveFirmwareFile(fwFileModel: model, forDevice: .brother)
            PMLog.shared.logger?.log(.verbose, message: "Brother file downloaded successfully")
        case PMAConstants.Titles.unitech:
            saveFirmwareFile(fwFileModel: model, forDevice: .unitech)
            PMLog.shared.logger?.log(.verbose, message: "Unitech file downloaded successfully")
        case PMAConstants.Titles.honeywell:
            saveFirmwareFile(fwFileModel: model, forDevice: .honeywell)
            PMLog.shared.logger?.log(.verbose, message: "Dex file downloaded successfully")
        default:
            break
        }
    }
}

extension PMAFileUtils {
    /// Saving the downloaded firmware file
    /// - Parameters:
    ///   - fwFileModel: model class of 'PeripheralDataModel'
    ///   - forDevice: PeripheralFileType have three device types 'Brother' 'Unitech' 'Dex'
    static func saveFirmwareFile(fwFileModel: FirmwarePackage, forDevice: PeripheralFileType){
        PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Titles.fwFileData) \(String(describing: fwFileModel))")
        do {
            try UserDefaults.standard.setObject(fwFileModel, forKey: PMAConstants.peripheralFileDataModel + fwFileModel.hardwareVersion + forDevice.rawValue)
        } catch {
            PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Titles.unableSaveFirmwareFile)")
        }
    }
}


