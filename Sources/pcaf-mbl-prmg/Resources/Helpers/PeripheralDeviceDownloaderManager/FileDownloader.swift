//
//  FileDownloader.swift
//  SalesProPlus
//
//  Created by amit.verma08 on 01/06/23.
//

import Foundation


class FileDownloader : ObservableObject{
    private let _firmwarePackageModel : [FirmwarePackage]
    
    init(firmwarePackageModel : [FirmwarePackage]){
        _firmwarePackageModel = firmwarePackageModel
    }
    
    /// func for download the firmware files.
    /// - Parameters:
    ///   - firmwarePackageModel: data in  [FirmwarePackage]
    ///   - vendor: firmware name
    
    func fileDownloader(firmwarePackageModel: [FirmwarePackage], vendor: String){
        firmwarePackageModel.forEach { FirmwarePackage in
            PMAFileDownloader().downloadFWFile(for: FirmwarePackage, deviceType: vendor, completionHandler: { result, progress, deviceType  in
                if let success = result {
                    if success == true {
                        PMAFileUtils.switchCase(deviceType: deviceType!, model: FirmwarePackage)
                    } else {
                        PMLog.shared.logger?.log(.verbose, message: "Failed to downloaded file")
                    }
                }
            })
        }
    }
}
