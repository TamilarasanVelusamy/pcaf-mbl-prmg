//
//  FWFileViewModel.swift
//  SalesProPlus
//
//  Created by ketan on 05/12/22.
//

import Foundation
import Combine

class PMAFileManager: ObservableObject {
    private var container: PMADIContainer.PeripheralFileData
    private var cancellables = Set<AnyCancellable>()
    
    init(container: PMADIContainer.PeripheralFileData) {
        self.container = container
    }
    
    func getFileData()  -> AnyPublisher<(Bool, PeripheralDataModel?), Never>  {
        let publisher = PassthroughSubject<(Bool, PeripheralDataModel?), Never>()
        self.container.getFwFileDataUseCase.getFileData()
            .sink(receiveValue: { (success, fileModel) in
                if success, let fwFileModel = fileModel {
                    PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Titles.fwFileData) \(String(describing: fwFileModel))")
                }
                publisher.send((success, fileModel))
            }).store(in: &cancellables)
        return publisher.eraseToAnyPublisher()
    }
}
