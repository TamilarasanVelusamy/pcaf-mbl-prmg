//
//  BrotherDIContainer.swift
//  DeviceManagerApp
//
//  Created by ketan on 20/10/22.
//

import Foundation

/// Common Container for use for all device like printer, scanner
struct PMADIContainer {
    
}

extension PMADIContainer {
    struct BrotherPrinterDetails {
        let printerConnectionUseCase: PrinterConnectionUseCaseProtocol
      
        static func container() -> PMADIContainer.BrotherPrinterDetails {
            let printerDeviceUseCase = configurePrinterDeviceUseCase()
            return BrotherPrinterDetails(printerConnectionUseCase: printerDeviceUseCase)
        }
    }
    
    static func configurePrinterDeviceUseCase() -> PrinterConnectionUseCaseProtocol {
        let configurePrinterDeviceReposity = ConfigurePrinterDeviceRepository()
        return PrinterConnectionUseCase(brotherPrinterRepositry: configurePrinterDeviceReposity)
    }
    
    static func ConfigurePrinterDeviceRepository() -> BRLMPrinterUtility {
        return  BRLMPrinterUtility.shared
    }
}

extension PMADIContainer {
    struct BrotherPrinterFWUpdate {
        let printerFWUpdateUseCase: PrinterUpdateUseCaseProtocol
      
        static func container() -> PMADIContainer.BrotherPrinterFWUpdate {
            let printerDeviceUseCase = configurePrinterFwUpdateUseCase()
            return BrotherPrinterFWUpdate(printerFWUpdateUseCase: printerDeviceUseCase)
        }
    }
    
    static func configurePrinterFwUpdateUseCase() -> PrinterUpdateUseCaseProtocol {
        let configurePrinterFWUpdateReposity = ConfigurePrinterDeviceRepository()
        let iosBatteryLevel = IosBatteryLevel()
        return PrinterUpdateUseCase(brotherPrinterRepository: configurePrinterFWUpdateReposity, iosBattery: iosBatteryLevel)
    }
}
