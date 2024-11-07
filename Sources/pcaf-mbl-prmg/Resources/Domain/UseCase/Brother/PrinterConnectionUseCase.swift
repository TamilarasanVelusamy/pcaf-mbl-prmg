//
//  BrotherPrinterUseCase.swift
//  DeviceManagerApp
//
//  Created by ketan on 20/10/22.
//

import Foundation
import CoreBluetooth

/// Protocol for get brother printer information form device
protocol PrinterConnectionUseCaseProtocol {
    func connectWithBluetooth(completionHandler: @escaping ([CBPeripheral]?) -> Void)
    func pairWithBluetoothDevice(device: CBPeripheral)
    func stopBluetoothScanning()
    func getAutoConnectedPrinter(completionHandler: @escaping ([PrinterModel]?) -> Void)
    func printerConnectionSuccessful(completionHandler: @escaping ([PrinterModel]?) -> Void)
}

struct PrinterConnectionUseCase {
    var brotherPrinterRepositry : BRLMPrinterUtility
    
    init(brotherPrinterRepositry: BRLMPrinterUtility) {
        self.brotherPrinterRepositry = brotherPrinterRepositry
    }
}

extension PrinterConnectionUseCase: PrinterConnectionUseCaseProtocol {
    
    /// func for stop bluetooth scanning
    func stopBluetoothScanning() {
        brotherPrinterRepositry.stopBluetoothScanning()
    }
    
    /// func for pair printer via bluethooth
    /// - Parameter device: CBPeripheral bluetooth
    func pairWithBluetoothDevice(device: CBPeripheral) {
        brotherPrinterRepositry.connectWithScannedDevice(device: device)
    }
    
    
    /// func for connect printer via bluetooth
    /// - Parameter completionHandler: CBPeripheral
    func connectWithBluetooth(completionHandler: @escaping ([CBPeripheral]?) -> Void) {
        brotherPrinterRepositry.connectWithBluetooth()
        brotherPrinterRepositry.nearbyBTDeviceDetected = { peripheralDevice in
            completionHandler(peripheralDevice)
        }
    }
    
    
    /// func for get printer model data after sucessful cnnection
    /// - Parameter completionHandler: PrinterModel
    func printerConnectionSuccessful(completionHandler: @escaping ([PrinterModel]?) -> Void) {
        brotherPrinterRepositry.printerDetailsLoaded = { model in
            if let printerModel = model {
                completionHandler([printerModel])
            } else {
                completionHandler(nil)
            }
        }
    }
    
    /// func for get printer model data after sucessful cnnection, when bluetooth is auto connected
    /// - Parameter completionHandler: PrinterModel
    func getAutoConnectedPrinter(completionHandler: @escaping ([PrinterModel]?) -> Void) {
        brotherPrinterRepositry.getPrinterDetails(completion: { model in
            if let printerModel = model {
                completionHandler([printerModel])
            } else {
                completionHandler(nil)
            }
        })
    }
}
