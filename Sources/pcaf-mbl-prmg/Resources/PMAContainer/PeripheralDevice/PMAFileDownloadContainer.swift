//
//  FwFileDownloadContainer.swift
//  SalesProPlus
//
//  Created by ketan on 05/12/22.
//

import Foundation

extension PMADIContainer {
    struct PeripheralFileData {
        let getFwFileDataUseCase: PMAFirmwareFileDataUseCaseProtocol
        static func container() -> PMADIContainer.PeripheralFileData {
            let firmwareFileDataUseCase = configurePMAFirmwareFileDataUseCase()
            return PeripheralFileData(getFwFileDataUseCase: firmwareFileDataUseCase)
        }
    }
    
    static func configurePMAFirmwareFileDataUseCase() -> PMAFirmwareFileDataUseCaseProtocol {
        let configurePrinterDeviceReposity = configurePMAFirmwareFileDataRepository()
        return PMAFirmwareFileDataUseCase(fwFileRepository: configurePrinterDeviceReposity)
    }
    
    static func configurePMAFirmwareFileDataRepository() -> PMADownloadRepositoryProtocol {
        return PMADownloadRepository()
    }
}
