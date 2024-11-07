//
//  HoneywellDeviceUseCase.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 20/02/23.
//

import Foundation
import Combine

protocol HoneywellDeviceUseCaseProtocol {
    func connectDexAdapter()
    func disconnectDexAdapter()
    func connectedState()-> Bool
    func flashMode()-> Bool
    func getFirmwareVersion()-> String
    func setFlashMode(completion: @escaping (Bool, String) -> Void)
    func upgradeDexFirmware(firmwareFilename: URL, completion: @escaping (Bool, String) -> Void)
    func getBatteryLevel() -> Int
    func scannfcRead()
    func getDexBatteryLevel()-> Int?
    func getFirmwareProgress(completionHandler: @escaping (Int) -> Void)
}

struct HoneywellDeviceUseCase {
    
    var dexDeviceRepository : DexDeviceRepository
    var iosBattery : IosBatteryLevel
    
    init(dexDeviceRepository: DexDeviceRepository, iosBattery: IosBatteryLevel) {
        self.dexDeviceRepository = dexDeviceRepository
        self.iosBattery = iosBattery
    }
}

extension HoneywellDeviceUseCase: HoneywellDeviceUseCaseProtocol {
    
    func getDexBatteryLevel() -> Int? {
        return dexDeviceRepository.getDexBatteryInfo()
    }
    func scannfcRead() {
        return dexDeviceRepository.nfcRead()
    }
    func getFirmwareVersion()-> String {
        return dexDeviceRepository.getFirmwareVersion()
    }
    func connectDexAdapter() {
        dexDeviceRepository.connectDexAdapter()
    }
    
    func disconnectDexAdapter() {
        dexDeviceRepository.disconnectDexAdapter()
    }
    
    func connectedState()-> Bool {
        return dexDeviceRepository.connectedState()
    }
    
    func flashMode() -> Bool {
        return dexDeviceRepository.flashMode()
    }
    
    func setFlashMode(completion: @escaping (Bool, String) -> Void) {
        dexDeviceRepository.setFlashMode {  success, message in
            completion(success, message)
        }
    }
    
    func getFirmwareProgress(completionHandler: @escaping (Int) -> Void) {
        dexDeviceRepository.getUpdateProgress = { progress in
            completionHandler(progress)
        }
    }
    
    func upgradeDexFirmware(firmwareFilename: URL, completion: @escaping (Bool, String) -> Void) {
        dexDeviceRepository.upgradeDexFirmware(firmwareFilename: firmwareFilename) { success, message in
            completion(success, message)
        }
    }
    
    func getBatteryLevel() -> Int {
        return iosBattery.batteryLevel
    }
}
