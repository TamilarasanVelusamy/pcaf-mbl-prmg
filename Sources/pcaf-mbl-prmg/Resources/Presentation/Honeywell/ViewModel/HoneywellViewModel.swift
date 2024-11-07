//
//  HoneywellHome.swift
//  DeviceManagerApp
//
//  Created by Anthony Hoepelman on 9/15/22.
//

import Foundation
import Combine

class DexAdapterViewModel: ObservableObject {
    
    var container: PMADIContainer.DexAdapter
    private var cancellable : AnyCancellable?
    @Published var firmwareState: FirmwareState?
    @Published var firmwareDownloadProgress: Double = 0.0
    @Published var firmwareUpgradeProgress: Double = 0.0
    private var newFirmwareFile: String = ""
    @Published var newFirmwareVersion: String = ""
    @Published var pin: String = ""
    @Published var FwInstallationComplete: Bool = false
    
    init(container: PMADIContainer.DexAdapter) {
        self.container = container
        cancellable = NotificationCenter.default.publisher(for: NSNotification.nfcPin)
            .receive(on: RunLoop.main)
            .sink { notification in
                let dict = notification.userInfo
                self.pin = dict?["Pin"] as? String ?? ""
            }
    }
}

extension DexAdapterViewModel {
    /// Called from self loadUnitechDevice(). This will change once proper procedure to check for new firmware is established. Perhaps couchbase or URL meta data.
    /// - Parameters None
    func checkNewFirmwareVersion() {
        
        guard let firmwareModel = getDexFirmwareModel() else{
            self.firmwareUpTodate()
            return
        }
        self.newFirmwareVersion = firmwareModel.version
        if(flashMode()) {
            readyToInstall()
            return
        }
        if getFirmwareVersion() < newFirmwareVersion {
            self.firmwareBootMode()
            UserDefaults.standard.set( false, forKey: PMAConstants.UserDefaultskey.successFirmwareAlert)
        }else if(newFirmwareVersion == ""){
            self.firmwareAvalilable()
        }
        else if(getFirmwareVersion() > newFirmwareVersion){
            
            if(firmwareModel.rollBack == "true"){
                self.firmwareBootMode()
                UserDefaults.standard.set( false, forKey: PMAConstants.UserDefaultskey.successFirmwareAlert)
                return
            }
            self.firmwareUpTodate()
        }
        else {
            self.firmwareUpTodate()
        }
    }
}

extension DexAdapterViewModel {
    /// Called from view when it receives notification to download firmware file
    /// - Parameters None
    func downloadFirmwareFile() {
        
        self.firmwareDownload()
        if let firmwareModel = getDexFirmwareModel(){
            PMAFileDownloader().downloadFWFile(for: firmwareModel, deviceType: PMAConstants.Titles.honeywell) { result, progress, deviceType in
                self.firmwareDownloadProgress = progress
                if let success = result {
                    if success == true {
                        self.firmwareBootMode()
                    } else {
                        self.firmwareAvalilable()
                    }
                }
            }
        }
    }
}

extension DexAdapterViewModel {
    /// func for set firmware state
    func readyToInstall() {
        // this will be determined once device is in actual flash mode. Place holder for now
        // ready to install for now will display prepare for install (flash mode)
        
        if(flashMode()) {
            let successAlert =  UserDefaults.standard.object(forKey: PMAConstants.UserDefaultskey.successFirmwareAlert) as? Bool ?? false
            if successAlert {
                self.firmwareInstallSucessfull()
                return
            }else{
                self.firmwareFileReadyToInstall()
                return
            }
        }
    }
}

extension DexAdapterViewModel {
    /// func for calling to enter flash mode.
    func setFlashMode() {
        container.honeywellDeviceUseCase.setFlashMode { value, message in
            if value {
                self.setFirmwareStateNone()
            }
        }
    }
}

extension DexAdapterViewModel {
    /// Called from view when it receives notification from repository that firmware installation has begun after going into flash mode
    /// - Parameters None
    func firmwareInstalling() {
        self.firmwareFileInstalling()
        container.honeywellDeviceUseCase.getFirmwareProgress { progress in
            self.firmwareUpgradeProgress = Double(progress)
        }
    }
    
}

extension DexAdapterViewModel {
    /// perform firmware upgrade
    func upgradeDexFirmware() {
        self.firmwareFileInstalling()
        let firmwareModel = getDexFirmwareModel()
        // Place holder for when actual firmware file is downloaded
        if let firmwareFile = PMAFileDownloader().getPeripheralFilePath(url: firmwareModel?.url ?? "", forDevice: .honeywell, unzipped: true) {
            container.honeywellDeviceUseCase.upgradeDexFirmware(firmwareFilename: firmwareFile) { success, message in
                if success {
                    self.firmwareInstallSucessfull()
                }
            }
        }
    }
}

extension DexAdapterViewModel{
    func getDexFirmwareModel()-> FirmwarePackage? {
        
        guard let firmwareModel = PMAFileDownloader().getPeripheralDataModel(forDevice: .honeywell, hardwareVersion: "")else {
            return nil
        }
        return firmwareModel
    }
}

extension DexAdapterViewModel{
    /// func for getting firmware version
    /// - Returns: Firmware version
    func getFirmwareVersion()-> String {
        let firmwareVersion = container.honeywellDeviceUseCase.getFirmwareVersion()
        return firmwareVersion == "" ? (UserDefaults.standard.string(forKey: PMAConstants.UserDefaultskey.oldFirmwareVersion) ?? "") : firmwareVersion
    }
}

extension DexAdapterViewModel {
    func deleteFirmwareFile(){
        let firmwareModel = getDexFirmwareModel()
        PMAFileDownloader().deleteFileFromDocumentsDirectory(url: firmwareModel?.url ?? "", for: .honeywell)
    }
}

extension DexAdapterViewModel {
    // MARK: - Usecase function
    
    /// func for connect NFC for getting pin
    func connectNFC() {
        container.honeywellDeviceUseCase.scannfcRead()
    }
    
    /// func for dex adapter connected state
    /// - Returns: true or false
    func connectedState()-> Bool {
        return container.honeywellDeviceUseCase.connectedState()
    }
    
    /// func for Connect Dex Adapter
    func connectDexAdapter() {
        container.honeywellDeviceUseCase.connectDexAdapter()
    }
    
    ///func for disconnect  dex Adapert
    func disconnectDexAdapter() {
        container.honeywellDeviceUseCase.disconnectDexAdapter()
    }
    
    /// func for getting status of device status
    /// - Returns: true or false
    func flashMode()-> Bool {
        return container.honeywellDeviceUseCase.flashMode()
    }
    
    /// func for getting Honeywell battery level
    /// - Returns: interger value
    func getDexBatteryLevel()-> Int? {
        return container.honeywellDeviceUseCase.getDexBatteryLevel()
    }
    
    /// func for getting Iphone Battery pecentage
    /// - Returns: battery percentage
    func getIphoneBatteryLevel()-> Int {
        container.honeywellDeviceUseCase.getBatteryLevel()
    }
}

// All Firmware states
extension DexAdapterViewModel{
    
    /// func for set firmware state when device is off
    func setFirmwareStateNone() {
        firmwareState = .none
    }
    
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
        self.FwInstallationComplete = true
        self.firmwareState = .FirmwareUpdateInstalled
    }
    
    func firmwareAvalilable() {
        self.firmwareState = .FirmwareUpdateAvailable
    }
    func firmwareBootMode(){
        self.firmwareState = .FirmwareBootMode
    }
}
