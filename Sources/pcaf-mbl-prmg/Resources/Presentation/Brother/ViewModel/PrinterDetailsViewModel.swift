//
//  PrinterDetailsViewModel.swift
//  DeviceManagementApp
//
//  Created by ketan on 22/08/22.
//

import Foundation
import BRLMPrinterKit
import Combine

class PrinterDetailsViewModel: ObservableObject {
    
    var printerInfo: PrinterModel?
    var container: PMADIContainer.BrotherPrinterFWUpdate
    @Published var batteryLevel: Int = 0
    @Published var firmwareLatestVersion: String = ""
    @Published var firmwareDownloadProgress: Double = 0
    @Published var firmwareUpgradeProgress: Double = 0.0
    @Published var firmwareState: FirmwareState?
    var secondsRemaining: Double = 165.0
    private var timer: Timer?
    
    init(container: PMADIContainer.BrotherPrinterFWUpdate) {
        self.container = container
        self.batteryLevel = self.container.printerFWUpdateUseCase.getBatteryLevel()
    }
}

extension PrinterDetailsViewModel {
    /// Called from This will change once proper procedure to check for new firmware is established. Perhaps couchbase or URL meta data.
    /// - Parameters None
    func checkNewFirmwareVersion() {
        
        // this will check the service providing firmware information
       guard let firmwareModel = getBrotherFirmwareModel() else{
           firmwareState = .FirmwareIsUpToDate
           return
       }
        firmwareLatestVersion = firmwareModel.version
        if (printerInfo?.firmVersion ?? "") < firmwareLatestVersion {
            self.firmwareFileReadyToInstall()
        }else if(firmwareLatestVersion == ""){
            firmwareAvalilable()
        }
        else if((printerInfo?.firmVersion ?? "") > firmwareLatestVersion){
            if(firmwareModel.rollBack == "true"){
                self.firmwareFileReadyToInstall()
                return
            }
            firmwareUpTodate()
        }
        else {
            firmwareUpTodate()
        }
    }
}

extension PrinterDetailsViewModel {
    
    func getBrotherFirmwareModel()-> FirmwarePackage? {
        
        guard let firmwareModel = PMAFileDownloader().getPeripheralDataModel(forDevice: .brother, hardwareVersion: "")else {
            return nil
        }
        return firmwareModel
    }
}

extension PrinterDetailsViewModel {
    
    func downloadFirmwareFile(){
        
        if let fileModel = getBrotherFirmwareModel() {
            PMAFileDownloader().downloadFWFile(for: fileModel, deviceType: PMAConstants.Titles.brother) { result, progress, deviceType in
                self.firmwareDownloadProgress = progress
                if let success = result {
                    if success == true {
                        self.firmwareFileReadyToInstall()
                    } else {
                        self.firmwareAvalilable()
                    }
                }
            }
        }
    }
}

extension PrinterDetailsViewModel {
    
    func callFWUpdateFromURL() {
        
        if let model = self.printerInfo {
            let fileModel = getBrotherFirmwareModel()
            if let firmwareFile = PMAFileDownloader().getPeripheralFilePath(url: fileModel?.url ?? "", forDevice: .brother, unzipped: true) {
                firmwareFileInstalling()
                fireFirmwareUpgradeTimer()
                self.container.printerFWUpdateUseCase.updatePrinterFirmware(printerInfo: model, fwFilePath: firmwareFile) {[weak self] result, message in
                    self?.firmwareInstallSucessfull()
                    self?.deleteFirmwareFile()
                    self?.timer?.invalidate()
                }
            }
        }
    }
}

extension PrinterDetailsViewModel {
    //call timer function
    private func fireFirmwareUpgradeTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
                let percentageValue = Double((165.0 - self.secondsRemaining) / 165.0) * 100.0
                self.firmwareUpgradeProgress = percentageValue
            } else {
                self.timer?.invalidate()
            }
        }
    }
}

extension PrinterDetailsViewModel {
    func deleteFirmwareFile(){
        let firmwareModel = getBrotherFirmwareModel()
        PMAFileDownloader().deleteFileFromDocumentsDirectory(url: firmwareModel?.url ?? "", for: .brother)
    }
}

// All Firmware states
extension PrinterDetailsViewModel{
    
    func firmwareUpTodate(){
        firmwareState = .FirmwareIsUpToDate
    }
    
    func firmwareFileReadyToInstall() {
        self.firmwareState = .FirmwareReadyToInstall
    }
    
    func firmwareFileInstalling(){
        self.firmwareState = .FirmwareUpdateInstalling
    }
    
    func firmwareDownload(){
        self.firmwareState = .FirmwareFileDownload
    }
    
    func firmwareInstallSucessfull() {
        DispatchQueue.main.async {
            self.firmwareState = .FirmwareUpdateInstalled
        }
        timer?.invalidate()
    }
    
    func firmwareAvalilable() {
        self.firmwareState = .FirmwareUpdateAvailable
    }
}
