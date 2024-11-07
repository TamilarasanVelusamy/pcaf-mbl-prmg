//
//  CheckFirmwareValidation.swift
//  SalesProPlus
//
//  Created by amit.verma08 on 01/06/23.
//

import Foundation

class CheckFirmwareValidation: ObservableObject{
    
    /// func for check the validation and  check the firmware already downloaded.
    /// - Parameters:
    ///   - dataModel: data in  Firmware
    ///  - Return: filtered data in [FirmwarePackage] model
    
    func checkFirmwareValidation(dataModel: Firmware) -> [FirmwarePackage]{
        
        var latestFirmawarePackageArr = [FirmwarePackage]()
        let uniqueHardwareVersionArr = Array(Set(dataModel.firmwarePackage.map{$0.hardwareVersion}.sorted{$0 > $1}))
        uniqueHardwareVersionArr.forEach { hardwareVersion in
            
            let latestFirmware = dataModel.firmwarePackage.filter{$0.hardwareVersion == hardwareVersion}.sorted{$0.version > $1.version}
            if(latestFirmware.count>0){
                if(checkFirmwareAlreadyDownloaded(deviceType: dataModel.vendor, deviceHardwareversion: hardwareVersion, firmwarePackage: latestFirmware.first!) == false){
                    latestFirmawarePackageArr.append(latestFirmware.first!)
                }
            }else{
                if let latestFirmware = dataModel.firmwarePackage.filter({$0.hardwareVersion == hardwareVersion}).sorted(by: {$0.version > $1.version}).first,  (checkFirmwareAlreadyDownloaded(deviceType: dataModel.vendor, deviceHardwareversion: hardwareVersion, firmwarePackage: latestFirmware) == false){
                    latestFirmawarePackageArr.append(latestFirmware)
                }
            }
        }
        return latestFirmawarePackageArr
    }
    
    /// func for bypass the if firmware is alredy downloaded.
    /// - Parameters:
    ///   - deviceType: firmware decice name
    ///  - deviceHardwareversion: firmware device Hardware version
    ///  - firmwarePackage: filtered data in FirmwarePackage model
    
    private func checkFirmwareAlreadyDownloaded(deviceType: String, deviceHardwareversion:String, firmwarePackage: FirmwarePackage)-> Bool{
        let fileManager = FileManager.default
        let filePath = URL(string: firmwarePackage.url)?.deletingPathExtension()
        let fileName = filePath?.lastPathComponent ?? ""
        let tempFolderPath = PMAFileUtils.documentsDirectoryPath().appendingPathComponent(deviceType).path
        let zipFileName = fileName+".zip"
        switch deviceType{
        case PMAConstants.Titles.brother:
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                let binFilename = fileName+".blf"
                for filePath in filePaths {
                    if(zipFileName == filePath || binFilename == filePath){
                        return true
                    }
                }
            } catch {
                PMLog.shared.logger?.log(.error, message: "file not downloaded: \(error)")
            }
        case PMAConstants.Titles.unitech:
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                let binFilename = fileName+".hex"
                for filePath in filePaths {
                    if(zipFileName == filePath || binFilename == filePath){
                        return true
                    }
                }
            } catch {
                PMLog.shared.logger?.log(.error, message: "file not downloaded: \(error)")
            }
        case PMAConstants.Titles.honeywell:
            do {
                let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                let binFilename = fileName+".bin"
                for filePath in filePaths {
                    if(zipFileName == filePath || binFilename == filePath){
                        return true
                    }
                }
            } catch {
                PMLog.shared.logger?.log(.error, message: "file not downloaded: \(error)")
            }
        default:
            break
        }
        return false
    }
}
