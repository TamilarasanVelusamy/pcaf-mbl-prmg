//
//  UnitechDeviceUseCase.swift
//  DeviceManagerApp
//
//  Created by hitendra.kumar on 12/10/22.
//

import Foundation
import Combine

protocol UnitechDeviceUseCaseProtocol {
    
    func getBatteryLevel() -> Int
    func getFirmwareProgress(completionHandler: @escaping (Float) -> Void)
    func getUTDeviceInformation(completionHandler: @escaping (UteReaderModel?) -> Void)
    func updateScannerFirmware(scannerInfo: UteReaderModel, fwFilePath: String) -> Void
    func closeSession() -> Void
    func openSession() -> Void
}

struct UnitechDeviceUseCase {
    
    var unitechDeviceRepository : UnitechDeviceRepository
    var iosBattery : IosBatteryLevel
    
    init(unitechDeviceRepository: UnitechDeviceRepository, iosBattery: IosBatteryLevel) {
        self.unitechDeviceRepository = unitechDeviceRepository
        self.iosBattery = iosBattery
    }
}

extension UnitechDeviceUseCase: UnitechDeviceUseCaseProtocol {
    
    func getBatteryLevel() -> Int {
        return iosBattery.batteryLevel
    }
    
    func openSession() {
        unitechDeviceRepository.openSession()
    }
    
    func closeSession() {
        unitechDeviceRepository.closeSession()
    }
    
    func getUTDeviceInformation(completionHandler: @escaping (UteReaderModel?) -> Void) {
        unitechDeviceRepository.getScannerDetails = { uteModel in
            completionHandler(uteModel)
        }
    }
    
    func updateScannerFirmware(scannerInfo: UteReaderModel, fwFilePath: String) -> Void {
        
        unitechDeviceRepository.installScannerFirmware(scannerInfo: scannerInfo, fwFilePath: fwFilePath)
    }
    
    func getFirmwareProgress(completionHandler: @escaping (Float) -> Void) {
        unitechDeviceRepository.getUpdateProgress = { progress in
            completionHandler(progress)
        }
    }
}
