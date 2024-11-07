//
//  FWFileDownloader.swift
//  DeviceManagerApp
//
//  Created by ketan on 23/09/22.
//

import Foundation

//MARK: - Firmware file downloader

struct PMAFileDownloader {
    
    /// funtion for downlaod firmware file
    /// - Parameters:
    ///   - device: pass input param as a file path from document direactory.
    ///   - completionHandler: true if sucess.
    func downloadFWFile(for device: FirmwarePackage, deviceType: String, completionHandler: @escaping (Bool?, Double, String?) -> Void) {
        var directoryPath: String? = nil
        let url = URL(string: device.url)
        switch deviceType {
        case PMAConstants.Titles.brother:
            directoryPath = PeripheralFileType.brother.rawValue
        case PMAConstants.Titles.unitech:
            directoryPath = PeripheralFileType.unitech.rawValue
        case PMAConstants.Titles.honeywell:
            directoryPath = PeripheralFileType.honeywell.rawValue
        default:
            break
        }
        if let finalUrl = url {
            let fileName = finalUrl.lastPathComponent
            let request = URLRequest(url: finalUrl)
            
            PMADownloadManager.shared.showLocalNotificationOnBackgroundDownloadDone = false
            PMADownloadManager.shared.localNotificationText = PMAConstants.Titles.fwFileDownloded
            let _ = PMADownloadManager.shared.downloadFile(withRequest: request, inDirectory: directoryPath, withName: fileName, shouldDownloadInBackground: true, onProgress: { (progress) in
                let percentage = String(format: "\(PMAConstants.Titles.onePercent) %", (progress * 100))
                PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Titles.backgroundProcess) \(percentage)")
                completionHandler(nil, progress * 100, deviceType)
            }) { (error, url) in
                if let error = error {
                    PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.ErrorMessage.error) \(error as NSError)")
                    completionHandler(false, 0, deviceType)
                } else {
                    if let url = url {
                        PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Titles.downloadedFileUrl) \(url.path)")
                        let fileExtension = url.pathExtension
                        if fileExtension.lowercased() == PMAConstants.Titles.zip {
                            let unzipFilePath = UnzipUtility.unzipFile(sourcePath: url.path, deviceType: deviceType)
                            PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Titles.unzipFileIUrl) \(unzipFilePath)")
                        }
                        completionHandler(true, 100, deviceType)
                    }
                }
            }
        }
    }
    
    func cancelDownloading() {
        PMADownloadManager.shared.cancelAllDownloads()
    }
    

    func getPeripheralDataModel(forDevice: PeripheralFileType, hardwareVersion: String)-> FirmwarePackage? {
        do {
            let fileModel = try UserDefaults.standard.getObject(forKey: PMAConstants.peripheralFileDataModel + hardwareVersion + forDevice.rawValue, castTo: FirmwarePackage.self)
            return fileModel
        } catch {
            return nil
        }
    }
    
    func getPeripheralFilePath(url:String,forDevice: PeripheralFileType, unzipped: Bool = true) -> URL? {
        let filePath = URL(string: url)?.deletingPathExtension()
        let fileName = filePath?.lastPathComponent ?? ""
        var fwFilePath: URL?
        if unzipped {
            switch forDevice {
            case .brother:
                fwFilePath =  PMAFileUtils.documentsDirectoryPath().appendingPathComponent(forDevice.rawValue)
                    .appendingPathComponent(fileName + ".blf")
            case .unitech:
                fwFilePath =  PMAFileUtils.documentsDirectoryPath().appendingPathComponent(fileName + ".hex")  //.appendingPathComponent(forDevice.rawValue)
            case .honeywell:
                fwFilePath =  PMAFileUtils.documentsDirectoryPath().appendingPathComponent(forDevice.rawValue)
                    .appendingPathComponent(fileName + ".bin")
            }
            return fwFilePath
        } else {
            if(forDevice.rawValue == PMAConstants.Titles.unitech){
              let fwFilePath =  PMAFileUtils.documentsDirectoryPath().appendingPathComponent(fileName + ".zip") //.appendingPathComponent(forDevice.rawValue)
               return fwFilePath
            }
            let fwFilePath =  PMAFileUtils.documentsDirectoryPath().appendingPathComponent(forDevice.rawValue).appendingPathComponent(fileName + ".zip")
            return fwFilePath
        }
    }
    
    /// funtion for deleting firmware file  form document directory.
    /// - Parameter device: file path form document directory.
    func deleteFileFromDocumentsDirectory(url:String,for device: PeripheralFileType) {
        let fileManager = FileManager.default
        let filePath = URL(string: url)?.deletingPathExtension()
        let fileName = filePath?.lastPathComponent ?? ""
        var tempFolderPath = ""
        switch device {
        case .brother:
            tempFolderPath = PMAFileUtils.documentsDirectoryPath().appendingPathComponent(device.rawValue).path
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                let zipFileName = fileName+".zip"
                let binFilename = fileName+".blf"
                for filePath in filePaths {
                    if(zipFileName == filePath || binFilename == filePath){
                    }else{
                        try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
                    }
                }
            } catch {
                PMLog.shared.logger?.log(.error, message: "Could not clear temp folder: \(error)")
            }
        case .unitech:
            tempFolderPath = PMAFileUtils.documentsDirectoryPath().appendingPathComponent(device.rawValue).path
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                let zipFileName = fileName+".zip"
                let binFilename = fileName+".hex"
                for filePath in filePaths {
                    if(zipFileName == filePath || binFilename == filePath){
                    }else{
                        try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
                    }
                }
            } catch {
                PMLog.shared.logger?.log(.error, message: "Could not clear temp folder: \(error)")
            }
        case .honeywell:
            tempFolderPath = PMAFileUtils.documentsDirectoryPath().appendingPathComponent(device.rawValue).path
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                let zipFileName = fileName+".zip"
                let binFilename = fileName+".bin"
                for filePath in filePaths {
                    if(zipFileName == filePath || binFilename == filePath){
                    }else{
                        try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
                    }
                }
            } catch {
                PMLog.shared.logger?.log(.error, message: "Could not clear temp folder: \(error)")
            }
        }
    }
}

