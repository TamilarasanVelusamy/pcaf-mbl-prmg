//
//  PrinterFWUpdateUseCase.swift
//  DeviceManagerApp
//
//  Created by ketan on 25/10/22.
//

import Foundation

/// Protocol for get brother printer firmware details
protocol PrinterUpdateUseCaseProtocol {
    func updatePrinterFirmware(printerInfo: PrinterModel, fwFilePath: URL, completion: @escaping (Bool, String) -> Void)
    func getBatteryLevel() -> Int
}

struct PrinterUpdateUseCase {
    var brotherPrinterRepository : BRLMPrinterUtility
    var iosBattery : IosBatteryLevel
    
    init(brotherPrinterRepository: BRLMPrinterUtility, iosBattery: IosBatteryLevel) {
        self.brotherPrinterRepository = brotherPrinterRepository
        self.iosBattery = iosBattery
    }
}

extension PrinterUpdateUseCase: PrinterUpdateUseCaseProtocol {
    
    /// Func for get printer firmware information
    /// - Parameters:
    ///   - printerInfo: PrinterModel
    ///   - fwFilePath: firmware file path
    ///   - completion: true of false
    func updatePrinterFirmware(printerInfo: PrinterModel, fwFilePath: URL, completion: @escaping (Bool, String) -> Void) {
        brotherPrinterRepository.updatePrinterFirmware(printerInfo: printerInfo, fwFilePath: fwFilePath) { success, message in
            completion(success, message)
        }
    }
    
    func getBatteryLevel() -> Int {
        return iosBattery.batteryLevel
    }
}
