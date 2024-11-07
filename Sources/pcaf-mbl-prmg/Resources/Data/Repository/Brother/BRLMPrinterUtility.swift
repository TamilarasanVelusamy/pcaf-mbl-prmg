//
//  BRLMPrinterUtility.swift
//  DeviceManagementApp
//
//  Created by Ketan on 09/08/22.
//

import Foundation
import BRLMPrinterKit
import CoreBluetooth

class BRLMPrinterUtility: NSObject {
    
    // MARK: - Properties
    
    static let shared = BRLMPrinterUtility()
    var printerDetailsLoaded: ((PrinterModel?) -> Void)?
    var nearbyBTDeviceDetected: (([CBPeripheral]?) -> Void)?
    var batteryInfo: BRPtouchBatteryInfo = BRPtouchBatteryInfo()
    var batteryInfoPointer: AutoreleasingUnsafeMutablePointer<BRPtouchBatteryInfo?>?
    private var centralManager: CBCentralManager?
    var nearbyPeripheral: [CBPeripheral] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.accessoryDidConnect), name: NSNotification.Name.BRDeviceDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.accessoryDidDisconnect), name: NSNotification.Name.BRDeviceDidDisconnect, object: nil)
        self.printerDetailsLoaded = {_ in}
        self.nearbyBTDeviceDetected = {_ in}

    }
    
    //MARK: - User defined funtion for connecting brother printer via bluetooth.
    
    func getPrinterObject(connectedPrinter: BRPtouchDeviceInfo) -> (BRPtouchPrinter?, ConnectionType?) {
        if let serialNo = connectedPrinter.strSerialNumber {
            let printerObj = BRPtouchPrinter.init(printerName: connectedPrinter.strModelName, interface: .BLUETOOTH)
            printerObj?.setupForBluetoothDevice(withSerialNumber: serialNo)
            return (printerObj, .bluetooth)
        } else {
            let printerObj = BRPtouchPrinter.init(printerName: connectedPrinter.strModelName, interface: .BLE)
            printerObj?.setBLEAdvertiseLocalName(connectedPrinter.strBLEAdvertiseLocalName)
            return (printerObj, .ble)
        }
    }
    
    func connectWithBluetooth() {
        startScanning()
    }
    
    /// Obeserver for Bloutooth accessory connect
    /// - Parameter notification: NSNotification
    @objc func accessoryDidConnect(notification: NSNotification) {
        PMLog.shared.logger?.log(.verbose, message: "accessoryDidConnect--\(String(describing: notification.userInfo) )")
        updateConnectedDevices()
    }
    
    /// Obeserver for Bloutooth accessory disconnect
    /// - Parameter notification: NSNotification
    @objc func accessoryDidDisconnect(notification: NSNotification) {
        PMLog.shared.logger?.log(.verbose, message: "accessoryDidDisconnect--\(String(describing: notification.userInfo))")
        updateConnectedDevices()
    }
    
    
    /// function for show bluetooth accessory popUp
    private func searchNearbyDevices() {
        BRPtouchBluetoothManager.shared().brShowBluetoothAccessoryPicker(withNameFilter: nil)
    }
    
    /// Clouser function for getting Updated printer model
    private func updateConnectedDevices() {
        self.getPrinterDetails { [weak self] printerModel in
            DispatchQueue.main.async {
                if let model = printerModel {
                    self?.printerDetailsLoaded!(model)
                } else {
                    self?.printerDetailsLoaded!(nil)
                }
            }
        }
    }
    
    /// Get Connectd Brother Printer Details
    /// - Parameter completion: PrinterModel
    func getPrinterDetails(completion: @escaping (PrinterModel?) -> Void) {
        DispatchQueue.global().async{ [self] in
            if let connectedDevices = BRPtouchBluetoothManager.shared().pairedDevices() as? [BRPtouchDeviceInfo], let device = connectedDevices.first {
                let selectedPrinter = self.getPrinterObject(connectedPrinter: device)
                if let printerObj = selectedPrinter.0, let connType = selectedPrinter.1 {
                    let status = printerObj.startCommunication()
                    if status {
                        self.batteryInfoPointer = AutoreleasingUnsafeMutablePointer<BRPtouchBatteryInfo?>(&self.batteryInfo)
                        _ = printerObj.getBatteryInfo(self.batteryInfoPointer)
                        // Populate the Printer Model
                        var printerModel = PrinterModel()
                        printerModel.iPAddress = device.strIPAddress
                        printerModel.location = device.strLocation
                        printerModel.modelName = device.strModelName
                        printerModel.serialNumber = device.strSerialNumber
                        printerModel.bleAdvertiseLocalName = device.strBLEAdvertiseLocalName
                        printerModel.nodeName = device.strNodeName
                        printerModel.printerName = device.strPrinterName
                        printerModel.iPhoneName = UIDevice().name
                        printerModel.iPhoneSystemName = UIDevice().systemName
                        printerModel.iPhoneSystemVersion = UIDevice().systemVersion
                        printerModel.iPhoneModel = UIDevice().model
                        printerModel.firmVersion = printerObj.getFirmVersion()
                        let autoConnect = printerObj.isAutoConnectBluetooth().boolValue == true ? PMAConstants.Titles.yes : PMAConstants.Titles.no
                        printerModel.isAutoConnectBluetooth = autoConnect
                        printerModel.connectionType = connType
                        printerModel.batteryChargeLevel = "\(self.batteryInfo.batteryChargeLevel)"
                        printerModel.batteryHealthStatus = getBatteryHealthStatus(status: self.batteryInfo.batteryHealthStatus)
                        printerModel.batteryHealthLevel = "\(self.batteryInfo.batteryHealthLevel)"
                        printerModel.deviceConnected = true
                        printerObj.endCommunication()
                        completion(printerModel)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    /// Get Brother Printer Battery status
    /// - Parameter status: BRPtouchBatteryInfoBatteryHealthStatus
    /// - Returns: Battery status
    func getBatteryHealthStatus(status: BRPtouchBatteryInfoBatteryHealthStatus) -> String {
        switch status {
        case .excellent:
            return BatteryHealthStatus.batteryHealthStatusExcellent.rawValue
        case .good:
            return BatteryHealthStatus.batteryHealthStatusGood.rawValue
        case .replaceSoon:
            return BatteryHealthStatus.batteryHealthStatusReplaceSoon.rawValue
        case .replaceBattery:
            return BatteryHealthStatus.batteryHealthStatusReplaceBattery.rawValue
        case .notInstalled:
            return BatteryHealthStatus.batteryHealthStatusNotInstalled.rawValue
        default:
            return BatteryHealthStatus.batteryHealthStatusNotInstalled.rawValue
        }
    }
}

extension BRLMPrinterUtility {
    
    /// function for Update funtion
    /// - Parameters:
    ///   - printerInfo: PrinterModel
    ///   - fwFilePath:  Brother Printer Firmware file path
    ///   - completion: true or false
    func updatePrinterFirmware(printerInfo: PrinterModel, fwFilePath: URL, completion: @escaping (Bool, String) -> Void) {
        UIApplication.shared.isIdleTimerDisabled = true
        DispatchQueue.global().async{ [self] in
            let model = BRPtouchDeviceInfo()
            model.strPrinterName = printerInfo.printerName
            model.strModelName = printerInfo.modelName
            model.strSerialNumber = printerInfo.serialNumber
            model.strBLEAdvertiseLocalName = printerInfo.bleAdvertiseLocalName
            let selectedPrinter = BRLMPrinterUtility.shared.getPrinterObject(connectedPrinter: model)
            if let printerObj = selectedPrinter.0 {
                let status = printerObj.startCommunication()
                if status {
                    PMLog.shared.logger?.log(.verbose, message: "\(PMAConstants.Constants.filePath) \(String(describing: fwFilePath))")
                    updatePrinterFW(printerObj: printerObj, filePath: fwFilePath, completion: { success, message in
                        completion(success, message)
                    })
                } else {
                    completion(false, PMAConstants.ErrorMessage.updateFailed)
                }
            } else {
                completion(false, PMAConstants.ErrorMessage.updateFailed)
            }
        }
    }
    
    /// Send file to printer device
    /// - Parameters:
    ///   - printerObj: BRPtouchPrinter
    ///   - filePath: FW file path
    private func updatePrinterFW(printerObj: BRPtouchPrinter, filePath: URL?, completion: @escaping (Bool, String) -> Void) {
        let firmwareFilePath = filePath?.path
        let pathExtension = filePath?.pathExtension.lowercased()
        if pathExtension == "pd3" || pathExtension == "blf" {
            let fwUpdateStatus = printerObj.sendFirmwareFile([firmwareFilePath ?? ""])
            if fwUpdateStatus == true {
                PMLog.shared.logger?.log(.verbose, message: "Printer firmware update status:- true")
                completion(true, PMAConstants.Titles.updateSuccessfully)
            } else {
                PMLog.shared.logger?.log(.verbose, message: "Printer firmware update status:- false")
                
                completion(false, PMAConstants.ErrorMessage.updateFailed)
            }
        } else {
            completion(false, PMAConstants.ErrorMessage.invalidFile)
        }
        printerObj.endCommunication()
        DispatchQueue.main.async{
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

extension BRLMPrinterUtility: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /// Bluetooth delegate funtion
    /// - Parameter central: CBCentralManager
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            PMLog.shared.logger?.log(.verbose, message: "Is Powered Off.")
            break
        case .poweredOn:
            PMLog.shared.logger?.log(.verbose, message: "Is Powered On.")
            break
        case .unsupported:
            PMLog.shared.logger?.log(.verbose, message: "Is Unsupported.")
            break
        case .unauthorized:
            PMLog.shared.logger?.log(.verbose, message: "Is Unauthorized.")
            break
        case .unknown:
            PMLog.shared.logger?.log(.verbose, message: "Unknown")
            break
        case .resetting:
            PMLog.shared.logger?.log(.verbose, message: "Resetting")
            break
        @unknown default:
            PMLog.shared.logger?.log(.verbose, message: "Error")
            break
        }
    }
    
    
    func startScanning() {
        // Start Scanning
        nearbyPeripheral.removeAll()
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    func connectWithScannedDevice(device: CBPeripheral) {
        stopBluetoothScanning()
        device.delegate = self
        self.centralManager?.connect(device, options: nil)
    }
    
    func stopBluetoothScanning() {
        self.centralManager?.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        PMLog.shared.logger?.log(.verbose, message: "Peripheral Discovered: \(peripheral)")
        let periDevice = peripheral
        if periDevice.name != nil {
            self.nearbyPeripheral.append(periDevice)
            nearbyBTDeviceDetected!(self.nearbyPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        PMLog.shared.logger?.log(.verbose, message: "Connected to your : \(peripheral)")
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        PMLog.shared.logger?.log(.verbose, message: "didDiscoverServices : \(peripheral)")
    }
}
