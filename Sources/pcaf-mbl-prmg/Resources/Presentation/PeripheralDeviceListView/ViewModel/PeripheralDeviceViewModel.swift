//
//  DeviceViewModel.swift
//  TestImageList
//
//  Created by anthony.hoepelman on 11/2/22.
//

import Foundation
import Combine
import SwiftUI

class PeripheralDeviceViewModel: ObservableObject {
    @Published var devices: [PeripheralDeviceModel] = [
        PeripheralDeviceModel(deviceType: "Printer", deviceName: "Brother", deviceConnected: false, deviceImage: Image(.brotherRJ42308)),
                              
        PeripheralDeviceModel(deviceType: "Scanner", deviceName: "Unitech", deviceConnected: false, deviceImage: Image(.uteScanner))
        
        // Uncomment to enable Dex Device Management
//        ,
//       PeripheralDeviceModel(deviceType: "DEX", deviceName: "DEX", deviceConnected: false, deviceImage: Image(.dex) )
//        
      ]
    public var updateCount : Int = 0
    private var cancellables = Set<AnyCancellable>()
    private let _checkFirmwareValidation : CheckFirmwareValidation
    private let _fileDownloader : FileDownloader
    private let peripheralFileManager = PMAFileManager(container: .container())
    
    init(fileDownloader: FileDownloader, checkFirmwareValidation: CheckFirmwareValidation){
        _fileDownloader = fileDownloader
        _checkFirmwareValidation = checkFirmwareValidation
    }
  
    func getPeripheralFileData() {
            peripheralFileManager.getFileData()
                .sink { (success, fileModel) in
                    if success {
                        fileModel?.firmware.forEach({ dataModel in
                            let latestFirwareArray = self._checkFirmwareValidation.checkFirmwareValidation(dataModel: dataModel)
                            self.updateCount = latestFirwareArray.count
                            self._fileDownloader.fileDownloader(firmwarePackageModel: latestFirwareArray, vendor: dataModel.vendor)
                        })
                    }
                }.store(in: &cancellables)

        }
    }
