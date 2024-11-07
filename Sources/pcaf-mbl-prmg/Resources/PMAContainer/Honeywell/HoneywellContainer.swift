//
//  HoneywellContainer.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 20/02/23.
//

import Foundation
extension PMADIContainer {
    
    struct DexAdapter {
        let honeywellDeviceUseCase: HoneywellDeviceUseCaseProtocol
      
        static func container() -> PMADIContainer.DexAdapter {
            let dexDeviceUseCase = configureHoneywellDeviceUseCase()
            return DexAdapter(honeywellDeviceUseCase: dexDeviceUseCase)
        }
    }
}

extension PMADIContainer {
    static func configureHoneywellDeviceUseCase() -> HoneywellDeviceUseCaseProtocol {
        let configureHoneywellDeviceRepository = configureHoneywellDeviceRepository()
        let iosBatteryLevel = IosBatteryLevel()
        return HoneywellDeviceUseCase(dexDeviceRepository: configureHoneywellDeviceRepository, iosBattery: iosBatteryLevel)
    }
    
    static func configureHoneywellDeviceRepository() -> DexDeviceRepository {
        return  DexDeviceRepository.shared
    }
}
