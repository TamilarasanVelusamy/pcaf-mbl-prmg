//
//  UnitechDeviceRepositry.swift
//  DeviceManagerApp
//
//  Created by hitendra.kumar on 13/10/22.
//

import Foundation
import FWUpdateSDK
import UIKit

final class UnitechDeviceRepository: NSObject {
    
    private var scannerDetails: UteReaderModel
    var getScannerDetails: ((UteReaderModel?) -> Void)?
    private var firmwareFile: String = ""
    var getUpdateProgress: ((Float) -> Void)?
    
    init(scannerDetails: UteReaderModel) {
        self.scannerDetails = scannerDetails
        super.init()

        // Define self as SDK delegates
        FWUpdater.sharedInstance().deviceManager?.delegate = self
        FWUpdater.sharedInstance().updateManager?.delegate = self
    }
    
    // MARK: - Custom Methods
    
    /// function called from view model to connect iOS device to scanner
    /// - Parameter none
    func openSession() {

        FWUpdater.sharedInstance().deviceManager?.connect()
    }
 
    /// function called from view model to close  iOS device session to scanner
    /// - Parameter none
    func closeSession() {

        FWUpdater.sharedInstance().deviceManager?.disconnect()
    }
    
    /// function called from from delegate when scanner has been plugged to iOS device
    /// - Parameter none
    private func pluggedState() {
        
        self.scannerDetails.deviceState = PMAConstants.Titles.plugged

        if ((FWUpdater.sharedInstance().deviceManager?.isConnected) != nil) {
            
            // Check if there's an upgrade in progress. If so scanner is in Bootloader mode and has reconnected. Now upgrade can start and proper view called
            if FWUpdater.sharedInstance().updateManager?.updateContinueStatus != UpdateContinue.UpdateContinueNone {
                
                NotificationCenter.default.post(name: NSNotification.firmwareInstalling, object: nil, userInfo: nil)
            }
            
            // tell SDK to proceed with firmware upgrade now that scanner has reconnected
            // this is always called upon scanner connection as per sample code from Unitech
            FWUpdater.sharedInstance().updateManager?.continueUpdate()
            self.connectedState()
        }
    }
    
    /// function called from from delegate when scanner has been unplugged from iOS device
    /// - Parameter none
    private func unpluggedState() {
        
        self.scannerDetails.deviceState = PMAConstants.Titles.unPlugged
        // send notification that the scanner is in an unplugged state
        NotificationCenter.default.post(name: NSNotification.scannerUnPlugged, object: nil, userInfo: nil)

    }
 
    /// function called from from delegate when scanner has reached a connected state
    /// - Parameter none
    private func connectedState() {
        
        guard let info  = FWUpdater.sharedInstance().deviceManager else {
            
            self.scannerDetails.deviceState = PMAConstants.Titles.unPlugged
            return
        }
        
        self.scannerDetails.deviceState = PMAConstants.Titles.connected
        
        // gather information from the scanner
        scannerDetails.scanerManufacturer = info.manufacturer as String
        scannerDetails.scanerModelNumber = info.modelNumber as String
        scannerDetails.scannerHardwareVersion = info.hardwareVersion as String
        scannerDetails.scanerSerialNumber = info.serialNumber as String
        scannerDetails.scannerFirmwareVersion = info.firmwareVersion as String
        
        // send notification that the scanner is in a connected state
        NotificationCenter.default.post(name: NSNotification.scannerConnected, object: nil, userInfo: nil)
    }
    
    /// function called from from view model to begin firmware upgrade
    /// - Parameters current scanner model, name if firmware file
    func installScannerFirmware(scannerInfo: UteReaderModel, fwFilePath: String) -> Void {
        
        let readerType: UpdateType = .asReader
        
        self.firmwareFile = fwFilePath
        
        
        PMLog.shared.logger?.log(.verbose, message: "UTE: performing update using file \(fwFilePath) as type \(readerType)")
        
        // Disallow device to go to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
        // start update will first enter Bootloader mode and cause scanner to reconnect
       // DispatchQueue.global().async {
            FWUpdater.sharedInstance().updateManager?.startUpdate(withHex: fwFilePath, updateType: readerType)
        //}
    }
    
}

// MARK: Device Manager and FW manager delegates are from SDK protocols

// MARK: - Device Manager Delegates

/// Required SDK protocol but not used during firmware upgrade
/// - Parameters None
extension UnitechDeviceRepository: DeviceManagerDelegate {
    
    func deviceManager(_ manager: DeviceManager!, completedReaderPower completedStatus: ReaderCompleted) {
        
        // Required protocol but not needed for FW Update.
        
    }
    
    /// SDK function called everytime there's a change in scanner plugged status wether manual or software restart.
    /// - Parameters None
    func deviceManager(_ manager: DeviceManager!, changedPluggedStatus pluggedStatus: Bool) {
        
        if (pluggedStatus)
        {
            self.pluggedState()
        }
        else
        {
            self.unpluggedState()
        }
        
        self.getScannerDetails?(scannerDetails)
    }
    
    /// SDK protocol provides scanner battery status
    /// - Parameters None
    func deviceManager(_ manager: DeviceManager!, receivedBattery battery: Int) {
        
        if scannerDetails.scannerBattery != battery {
            
            scannerDetails.scannerBattery = battery
            self.getScannerDetails?(scannerDetails)
        }
    }
}

extension UnitechDeviceRepository: FWUpdateManagerDelegate {
    
    // MARK: - FW Update Delegates
 
    /// SDK protocol provides firmware upgrade progress during upgrade.
    /// - Parameters None
    func fwUpdateManager(_ manager: FWUpdateManager!, updateProcessingStep progressStep: Float, currentStep: Int, endStep: Int) {

        PMLog.shared.logger?.log(.verbose, message: "UTE: -- currentStep  \(currentStep)  End : \(endStep)  \(progressStep)")
        
        self.getUpdateProgress?(progressStep)
    }
    
    /// SDK protocol but during testing never gets called
    /// - Parameters None
    func fwUpdateManager(_ manager: FWUpdateManager!, bootloaderInfo info: BootloaderInfo!) {
        PMLog.shared.logger?.log(.verbose, message: "UTE: Bootloader version: \(String(describing: info.versionNameText))")
        manager.closeBootloaderMode(withHEXFile: firmwareFile)
    }

    /// SDK protocol but during testing never gets called
    /// - Parameters None
    func fwUpdateManager(_ manager: FWUpdateManager!, moduleVersion version: String!) {
        
        PMLog.shared.logger?.log(.verbose, message: "UTE: The module version is \(version ?? "unknown")")
    }

    /// SDK protocol called when firmware update completes
    /// - Parameters None
    func fwUpdateManager(_ manager: FWUpdateManager!, updateFinish error: Error!) {
        
        PMLog.shared.logger?.log(.verbose, message: "UTE: Firmware update has completed")
        UIApplication.shared.isIdleTimerDisabled = false
        NotificationCenter.default.post(name: NSNotification.FirmwareInstallCompleted, object: nil, userInfo: nil)
    }

    /// SDK protocol called if an error has occured
    /// - Parameters None
    func fwUpdateManager(_ manager: FWUpdateManager!, occuredError error: Error!) {
        
        PMLog.shared.logger?.log(.verbose, message: error.debugDescription)
    }
 
    /// SDK protocol but during testing never gets called
    /// - Parameters None
    func fwUpdateManager(_ manager: FWUpdateManager!, rebootRequest error: Error!) {
        PMLog.shared.logger?.log(.verbose, message: "UTE: Reboot request was called")
    }
    
    /// SDK protocol but during testing never gets called
    /// - Parameters None
    func fwUpdateManagerSuspendUpdate(_ manager: FWUpdateManager!) {
                PMLog.shared.logger?.log(.verbose, message: "UTE: FWUpdateManager was called")
    }
}


