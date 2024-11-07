//
//  UnitechHome.swift
//  DeviceManagerApp
//
//  Created by Anthony Hoepelman on 9/15/22.
//

import Foundation
import Combine

class UnitechHomeViewModel: ObservableObject {
    
    var container: PMADIContainer.UTDInformation
    @Published var iOSbatteryLevel: Int = 0
    @Published var firmwareState: FirmwareState?
    @Published var firmwareUpgradeProgress: Double = 0.0
    @Published var firmwareDownloadProgress: Double = 0
    @Published var newFirmwareVersion: String = ""
    @Published var scannerDetails = UteReaderModel()
    @Published var invalidFirmwareFileAlert: Bool = false
    
    init(container: PMADIContainer.UTDInformation) {
        self.container = container
        self.iOSbatteryLevel = self.container.unitechDeviceUseCase.getBatteryLevel()
        self.loadUnitechDevice()
    }
}

extension UnitechHomeViewModel {
    /// Called from view when view is going to close. This will close (power down) scanner session
    /// - Parameters None
    func closeSession() {
        container.unitechDeviceUseCase.closeSession()
    }
}

extension UnitechHomeViewModel {
    /// Called from view when first appears. Opens a session causing scanner to connect (power on) if connected to iOS device
    /// - Parameters None
    func loadUnitechDevice() {
        
        // Opening a session will cause the delegates to fire again
        container.unitechDeviceUseCase.openSession()
        container.unitechDeviceUseCase.getUTDeviceInformation { [weak self] uteModel in
            self?.scannerDetails = uteModel ?? UteReaderModel()
            self?.checkForNewFirmware()
        }
    }
}

extension UnitechHomeViewModel {
    /// Called from view when it receives notification from PMACustomAlertView that firmware install button was pressed
    /// - Parameters None
    func installScannerFirmware() {
        // for now we'll assume we have reconnected after bootloader
        guard let firmwareModel = getUnitechFirmwareModel() else{
            return
        }
        self.newFirmwareVersion = firmwareModel.version
        UserDefaults.standard.set(scannerDetails.scannerFirmwareVersion, forKey: PMAConstants.UserDefaultskey.oldFirmwareVersion)
        // Place holder for when actual firmware file is downloaded
        if(self.scannerDetails.scannerHardwareVersion == firmwareModel.hardwareVersion){
            if let firmwareFileURL = PMAFileDownloader().getPeripheralFilePath(url: firmwareModel.url, forDevice: .unitech, unzipped: true)?.lastPathComponent {
                container.unitechDeviceUseCase.updateScannerFirmware(scannerInfo: scannerDetails, fwFilePath: firmwareFileURL)
                firmwareInstalling()
            }
        }else{
            self.invalidFirmwareFileAlert = true
        }
    }
}

extension UnitechHomeViewModel {
    /// Called from view when it receives notification from repository that firmware installation has begun after going into bootloader mode
    /// - Parameters None
    func firmwareInstalling() {
        container.unitechDeviceUseCase.getFirmwareProgress { progress in
            self.firmwareFileInstalling()
            self.firmwareUpgradeProgress = Double(progress)
        }
    }
}

extension UnitechHomeViewModel {
    /// Called from view when it receives notification to download firmware file
    /// - Parameters None
    func downloadFirmwareFile() {
        
        firmwareDownload()
        // place holder for when file download is activated
        if let firmwareModel = getUnitechFirmwareModel(){
            PMAFileDownloader().downloadFWFile(for: firmwareModel, deviceType: PMAConstants.Titles.unitech) { [self] result, progress, deviceType in
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

extension UnitechHomeViewModel {
    /// Called from self loadUnitechDevice(). This will change once proper procedure to check for new firmware is established. Perhaps couchbase or URL meta data.
    /// - Parameters None
    func checkForNewFirmware() {
        
        // this will check the service providing firmware information
        guard let firmwareModel = getUnitechFirmwareModel() else{
            firmwareUpTodate()
            return
        }
        self.newFirmwareVersion = firmwareModel.version
        if scannerDetails.scannerFirmwareVersion < newFirmwareVersion {
            self.firmwareFileReadyToInstall()
        }else if (newFirmwareVersion == ""){
            self.firmwareAvalilable()
        }
        else if(scannerDetails.scannerFirmwareVersion > newFirmwareVersion){
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

extension UnitechHomeViewModel {
    func getUnitechFirmwareModel()-> FirmwarePackage? {
        
        guard let firmwareModel = PMAFileDownloader().getPeripheralDataModel(forDevice: .unitech, hardwareVersion:  self.scannerDetails.scannerHardwareVersion)else {
            return nil
        }
        return firmwareModel
    }
}

extension UnitechHomeViewModel {
    func deleteFirmwareFile(){
        let firmwareModel = getUnitechFirmwareModel()
        PMAFileDownloader().deleteFileFromDocumentsDirectory(url: firmwareModel?.url ?? "", for: .unitech)
    }
}

// All Firmware states
extension UnitechHomeViewModel{
    
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
        self.firmwareState = .FirmwareUpdateInstalled
    }
    
    func firmwareAvalilable() {
        self.firmwareState = .FirmwareUpdateAvailable
    }
}
