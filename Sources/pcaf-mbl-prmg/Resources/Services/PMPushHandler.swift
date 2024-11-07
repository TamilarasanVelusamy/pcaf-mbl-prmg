//
//  PMPushHandler.swift
//  MySampleFW
//
//  Created by tamilarasan_v on 11/10/24.
//


import Foundation
import Combine
import PepNetworkingPackage

public class PMPushHandler: NSObject {

    private var cancellables = Set<AnyCancellable>()
    var updateCount : Int = 0
    var accessTokenPMA : String = "0"
    func getUpdatesCount() -> Int {
        var pheripheralUpdatesCount = 0
        getPeripheralFileData { fileModel in
            fileModel?.firmware.forEach { dataModel in
                let checkFirmware = CheckFirmwareValidation()
                let latestFirwareArray = checkFirmware.checkFirmwareValidation(dataModel: dataModel)
                pheripheralUpdatesCount = latestFirwareArray.count
                if latestFirwareArray.count > 0 {
                    let fileDownloader = FileDownloader(firmwarePackageModel: dataModel.firmwarePackage)
                    fileDownloader.fileDownloader(firmwarePackageModel: latestFirwareArray, vendor: dataModel.vendor)
                }
            }
        }
        self.updateCount = pheripheralUpdatesCount
        return pheripheralUpdatesCount
    }

    /// Peripheral File Downloader funtion  from push notification link
    /// - Returns: PeripheralDataModel
    func getPeripheralFileData(completionHandler: @escaping (PeripheralDataModel?) -> Void) {
        let apiClient = APIClient(baseURL: PMAEnvironment.baseUrl+PMAConstants.ApiEndPoint.getPeripheralData)
        let firmwareRequest = GetPeripheralFileRequest()
        apiClient.get(firmwareRequest)
            .receive(on: DispatchQueue.main)
            .decode(type: PeripheralDataModel.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    PMLog.shared.logger?.log(.verbose, message: "Error: Failed to get peripheral file data--\(error)")
                    completionHandler(nil)
                    break
                case .finished:
                    break
                }
            } receiveValue: { fwFileModel in
                completionHandler(fwFileModel)
            }
            .store(in: &cancellables)
    }
    
    /// func for parse  data
    /// - Parameter temp: Notification date parse
    /// - Returns: PeripheralDataModel in array
    func parseJsonStringToPMAModel(jsonString :String )-> PeripheralDataModel{
        do {
            let data = jsonString.data(using: .utf8) ?? Data()
            let fwModel = try JSONDecoder().decode(PeripheralDataModel.self, from: data)
            return fwModel
        } catch {
            PMLog.shared.logger?.log(.verbose, message: "\(error)")
            return PeripheralDataModel(firmware: [Firmware]())
        }
    }
}

