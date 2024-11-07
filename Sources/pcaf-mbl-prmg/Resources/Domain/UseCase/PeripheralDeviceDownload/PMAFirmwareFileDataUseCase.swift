//
//  FwFileDataUseCase.swift
//  SalesProPlus
//
//  Created by ketan on 05/12/22.
//

import Foundation
import Combine

/// Protocol for download Firmware file and firmware information
protocol PMAFirmwareFileDataUseCaseProtocol {
    func getFileData() -> AnyPublisher<(Bool, PeripheralDataModel?), Never>
}

final class PMAFirmwareFileDataUseCase {
    private var cancellables = Set<AnyCancellable>()
    private let fwFileRepository: PMADownloadRepositoryProtocol
    init(fwFileRepository: PMADownloadRepositoryProtocol) {
        self.fwFileRepository = fwFileRepository
    }
}

extension PMAFirmwareFileDataUseCase: PMAFirmwareFileDataUseCaseProtocol {
    /// func for download Firmware file and firmware information
    /// - Parameter forDevice: PeripheralFileType
    /// - Returns: PeripheralDataModel
    func getFileData() -> AnyPublisher<(Bool, PeripheralDataModel?), Never> {
        let publisher = PassthroughSubject<(Bool, PeripheralDataModel?), Never>()
        self.fwFileRepository.getPeripheralFileData()
            .sink(receiveValue: { (success, fileModel) in
                publisher.send((success, fileModel))
            }).store(in: &cancellables)
        return publisher.eraseToAnyPublisher()
    }
}
