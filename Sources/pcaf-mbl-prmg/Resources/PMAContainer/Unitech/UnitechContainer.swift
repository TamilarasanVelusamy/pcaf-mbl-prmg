//
//  UnitechContainer.swift
//  DeviceManagerApp
//
//  Created by ketan on 19/10/22.
//

import Foundation

extension PMADIContainer {
    
    struct UTDInformation {
        
        let unitechDeviceUseCase: UnitechDeviceUseCaseProtocol
      
        static func container() -> PMADIContainer.UTDInformation {
            
            let utDeviceUseCase = configureUnitechDeviceUseCase()
            return UTDInformation(unitechDeviceUseCase: utDeviceUseCase)
        }
    }
}

extension PMADIContainer {
    
    static func configureUnitechDeviceUseCase() -> UnitechDeviceUseCaseProtocol {
        
        let configureUnitechDeviceRepository = configureUnitechDeviceRepository()
        let iosBatteryLevel = IosBatteryLevel()
        return UnitechDeviceUseCase(unitechDeviceRepository: configureUnitechDeviceRepository, iosBattery: iosBatteryLevel)
    }
    
    static func configureUnitechDeviceRepository() -> UnitechDeviceRepository {
        return  UnitechDeviceRepository(scannerDetails: UteReaderModel())
    }
}


