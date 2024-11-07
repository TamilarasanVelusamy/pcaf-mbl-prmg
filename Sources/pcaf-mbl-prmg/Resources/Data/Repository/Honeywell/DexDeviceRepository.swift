//
//  DexDeviceRepository.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 20/02/23.
//

import UIKit
import DEXUpgradeSDK

final class DexDeviceRepository: NSObject {
    let upgrade = DEXUpgrade()
    static let shared = DexDeviceRepository()
    var getUpdateProgress: ((Int) -> Void)?
    
    override init() {
        super.init()
        upgrade.delegate = self
    }
    
    func nfcRead() {
        var dex: String = ""
        var mac: String = ""
        var pin: String = ""
        var ver: String = ""
        PMLog.shared.logger?.log(.verbose, message: "NFC Read started...")
        DispatchQueue.global(qos: .userInitiated).async {
            self.upgrade.NFCRead() { (result) -> () in
                let components = result.components(separatedBy: ";")
                components.forEach({ (c) in
                    if c.contains("DEV$") {
                        dex = c.replacingOccurrences(of: "DEV$", with: "")
                    }
                    else if c.contains("BDA$") {
                        mac = c.replacingOccurrences(of: "BDA$", with: "")
                        // Format the MAC address properly (it is stored in network byte order)
                        mac = String(mac.reversed())
                        var chars = Array(mac)
                        for i in stride(from: 0, to: mac.count, by: 2) {
                            chars.swapAt(i, i+1)
                        }
                        mac = String(chars)
                    }
                    else if c.contains("PIN$") {
                        pin = c.replacingOccurrences(of: "PIN$", with: "")
                    }
                    else if c.contains("REV:") {
                        ver = c.replacingOccurrences(of: "REV:", with: "")
                    }
                })
                DispatchQueue.main.async {
                    if dex == "DEX" {

                        PMLog.shared.logger?.log(.verbose, message: "NFC Read was a DEX Adapter\n> MAC: " + mac + "\n> PIN: " + pin + "\n> Firmware Version: " + ver)
                        
                        NotificationCenter.default.post(name: NSNotification.nfcPin, object: nil, userInfo: ["Pin":pin])
                    }
                    else {
                        if dex == "" {
                            PMLog.shared.logger?.log(.error, message: "NFC Read FAILED!")
                        }
                        else {
                            PMLog.shared.logger?.log(.error, message: "NFC Read was not a DEX Adapter!")
                        }
                    }
                }
            }
        }
    }
    
    func connectDexAdapter() {
        if !upgrade.IsConnected() {
            PMLog.shared.logger?.log(.verbose, message: "DEX Adapter connecting...")
            upgrade.Connect(timeout: 10) { (result) -> () in
                if result {
                    PMLog.shared.logger?.log(.verbose, message: "DEX Adapter CONNECTED")
                    NotificationCenter.default.post(name: NSNotification.dexConnected, object: nil, userInfo: nil)
                    if self.upgrade.IsFlashMode() {
                        PMLog.shared.logger?.log(.verbose, message: "Flash Mode is ENABLED")
                    }
                }
                else{
                    PMLog.shared.logger?.log(.verbose, message: "DEX Adapter Connect FAILED!")
                }
            }
        }
    }
    
    func disconnectDexAdapter(){
        PMLog.shared.logger?.log(.verbose, message: "DEX Adapter disconnecting...")
        upgrade.Disconnect() { (result) -> () in
            if result {
                PMLog.shared.logger?.log(.verbose, message: "DEX Adapter Disconnect")
                NotificationCenter.default.post(name: NSNotification.dexUnPlugged, object: nil, userInfo: nil)
            }
        }
    }
    
    func getFirmwareVersion()-> String {
        var firmwareVersion = ""
        if upgrade.IsConnected() && !upgrade.IsFlashMode() {
            firmwareVersion =  upgrade.GetAdapterFirmwareVersion()
            UserDefaults.standard.set(firmwareVersion, forKey: PMAConstants.UserDefaultskey.oldFirmwareVersion)
        }
        return firmwareVersion
    }
    
    func getDexBatteryInfo()-> Int? {
        var firmwareBatteryInfo = 0
        if upgrade.IsConnected() && !upgrade.IsFlashMode() {
            firmwareBatteryInfo =  Int(upgrade.GetBatteryLevel())
        }
        return firmwareBatteryInfo
    }
    
    func setFlashMode(completion: @escaping (Bool, String) -> Void){
        if upgrade.IsConnected() && !upgrade.IsFlashMode() {
            PMLog.shared.logger?.log(.verbose, message: "Setting Flash Mode On...")
            upgrade.SetFlashMode() { (result) -> () in
                if result {

                    PMLog.shared.logger?.log(.verbose, message: "Setting Flash Mode SUCCESSFUL")
                    PMLog.shared.logger?.log(.verbose, message: "> Go to Settings -> Bluetooth and\n> forget the DEXAdapter device,")
                    PMLog.shared.logger?.log(.verbose, message: "> then Connect to the DEX Adapter again.")
                    completion(true, PMAConstants.Titles.flashMode)
                }
                else{
                    PMLog.shared.logger?.log(.verbose, message: "Setting Flash Mode FAILED!")
                    completion(false, PMAConstants.ErrorMessage.flashModeError)
                }
            }
        }
    }
    
    func upgradeDexFirmware(firmwareFilename: URL, completion: @escaping (Bool, String) -> Void){
        UIApplication.shared.isIdleTimerDisabled = true
        if upgrade.IsConnected() && upgrade.IsFlashMode() {
            PMLog.shared.logger?.log(.verbose, message: "Firmware Upgrade started\n( \(firmwareFilename))...")
            NotificationCenter.default.post(name: NSNotification.firmwareInstalling, object: nil, userInfo: nil)
            var upgradeResult: Bool = false
            DispatchQueue.global(qos: .userInitiated).async {
                self.upgrade.UpgradeFirmware(fileURL: firmwareFilename, callback: {(result) -> () in
                    upgradeResult = result
                })
                DispatchQueue.main.async {
                    if upgradeResult {
                        PMLog.shared.logger?.log(.verbose, message: "Firmware Upgrade SUCCESSFUL")
                        PMLog.shared.logger?.log(.verbose, message: "> Connect to the DEX Adapater and\n> enter pairing PIN.")
                        PMLog.shared.logger?.log(.verbose, message: "> Then go to Settings -> Bluetooth and\n> forget the DEXAdapter device,")
                        PMLog.shared.logger?.log(.verbose, message: "> then Connect to the DEX Adapter again.")
                        completion(true, PMAConstants.Titles.updateSuccessfully)
                    }
                    else{
                        PMLog.shared.logger?.log(.verbose, message: "Firmware Upgrade FAILED!")
                        completion(false, PMAConstants.ErrorMessage.updateFailed)
                    }
                }
            }
        }
    }
}

extension DexDeviceRepository: DEXUpgradeDelegate {
    
    func connectedState()-> Bool{
        return upgrade.IsConnected()
    }
    
    func flashMode()-> Bool{
        return upgrade.IsFlashMode()
    }
    
    func DidConnect() {
        
        PMLog.shared.logger?.log(.verbose, message: "DEX Adapter did connect called")
    }
    
    func DidDisconnect() {
        DispatchQueue.main.async {
            PMLog.shared.logger?.log(.verbose, message: "DEX Adapter DISCONNECTED")
        }
    }
    
    func UpgradeProgress(progress: Int){
        DispatchQueue.main.async {
            if(progress == 100){
                UIApplication.shared.isIdleTimerDisabled = false
            }
            PMLog.shared.logger?.log(.verbose, message: "Upgrade Progress: " + String(progress) + "%")
            
            self.getUpdateProgress?(progress)
        }
    }
}
