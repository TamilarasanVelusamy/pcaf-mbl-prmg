//
//  FWDownloadRepository.swift
//  SalesProPlus
//
//  Created by ketan on 01/12/22.
//

import Foundation
import Combine
import PepNetworkingPackage

/// Protocol for download Firmware file and firmware information
protocol PMADownloadRepositoryProtocol: AnyObject {
    func getPeripheralFileData() -> AnyPublisher<(Bool, PeripheralDataModel?), Never>
}

final class PMADownloadRepository {
    private var cancellables = Set<AnyCancellable>()
}

extension PMADownloadRepository: PMADownloadRepositoryProtocol {
    /// Peripheral File Downloader funtion which comes form push notification or cloude.
    /// - Parameter firmwarefileFor: PeripheralFileType
    /// - Returns: PeripheralDataModel
    func getPeripheralFileData() -> AnyPublisher<(Bool, PeripheralDataModel?), Never> {
        let apiClient = APIClient(baseURL: PMAConstants.ApiEndPoint.baseUrl+PMAConstants.ApiEndPoint.getPeripheralData)
        let publisher = PassthroughSubject<(Bool, PeripheralDataModel?), Never>()
        let firmwareRequest = GetPeripheralFileRequest()
        apiClient.get(firmwareRequest)
            .receive(on: DispatchQueue.main)
            .decode(type: PeripheralDataModel.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    PMLog.shared.logger?.log(.error, message: "getPeripheralFileData error : \(error)")
                    publisher.send((false, nil))
                case .finished:
                    break
                }
            } receiveValue: { fwFileModel in
                publisher.send((true, fwFileModel))
            }
            .store(in: &cancellables)
        return publisher.eraseToAnyPublisher()
    }
}
