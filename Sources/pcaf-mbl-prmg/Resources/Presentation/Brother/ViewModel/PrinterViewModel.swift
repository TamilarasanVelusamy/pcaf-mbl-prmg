//
//  PrinterViewModel.swift
//  DeviceManagementApp
//
//  Created by ketan on 17/08/22.
//

import Foundation
import BRLMPrinterKit
import CoreBluetooth

class PrinterViewModel: ObservableObject {
    private var container: PMADIContainer.BrotherPrinterDetails
    @Published var pairedPrinter: [PrinterModel] = []
    @Published var nearbyPeripheralDevice: [CBPeripheral] = []
    @Published var isLoading: Bool = false
    
    init(container: PMADIContainer.BrotherPrinterDetails) {
        self.container = container
    }
    
    /// func for connect printer via bluetooth
    func connectPrinterWithBluetooth() {
        isLoading = true
        container.printerConnectionUseCase.connectWithBluetooth(completionHandler: {  [weak self] scannedDevices in
            DispatchQueue.main.async {
                self?.nearbyPeripheralDevice = scannedDevices ?? []
                self?.isLoading = false
            }
        })
    }
    
    func pairWithScannedPrinter(device: CBPeripheral) {
        isLoading = true
        container.printerConnectionUseCase.pairWithBluetoothDevice(device: device)
    }
    
    func stopBluetoothScanning() {
        container.printerConnectionUseCase.stopBluetoothScanning()
    }
    
    /// func for get printer model after successful connection
    func getPrinterConnectionStatus() {
        container.printerConnectionUseCase.printerConnectionSuccessful(completionHandler: { [weak self] modelPrinter in
            let disconnectedPrinters = self?.getListOfDisconnectedPrinters(modelPrinter: modelPrinter)
            DispatchQueue.main.async {
                self?.pairedPrinter = modelPrinter ?? []
                self?.pairedPrinter.append(contentsOf: disconnectedPrinters ?? [])
                NotificationCenter.default.post(name: NSNotification.printerConnectionStatusChanged, object: nil, userInfo: ["printerModel": self?.pairedPrinter ?? PrinterModel()])
                self?.isLoading = false
            }
        })
    }
    
    
    /// get Updated printer Model when printer auto connected to device.
    func loadAutoConnectedPrinter() {
        isLoading = true
        container.printerConnectionUseCase.getAutoConnectedPrinter { [weak self] modelPrinter in
            let disconnectedPrinters = self?.getListOfDisconnectedPrinters(modelPrinter: modelPrinter)
            DispatchQueue.main.async {
                self?.pairedPrinter = modelPrinter ?? []
                self?.pairedPrinter.append(contentsOf: disconnectedPrinters ?? [])
                self?.isLoading = false
            }
        }
    }
    
    
    /// function for getting Updated printer modle
    /// - Parameter modelPrinter: array of PrinterModel
    /// - Returns: array of PrinterModel
    private func getListOfDisconnectedPrinters(modelPrinter: [PrinterModel]?) -> [PrinterModel] {
        //Get saved paired printers from UserDefaults
        let userDefault = UserDefaults.standard
        var disconnectedPrinters = [PrinterModel]()
        do {
            var allPairedPrinters = try userDefault.getObject(forKey: PMAConstants.peripheralDisconnectedDevices, castTo: [PrinterModel].self)
            PMLog.shared.logger?.log(.verbose, message: "Paired Printers : \(allPairedPrinters)")
            if let model = modelPrinter, model.count > 0 {
                let pairedPrinters = allPairedPrinters.filter({ $0.serialNumber == model.first?.serialNumber })
                // If new printer is connected save in user defaults
                if  pairedPrinters.count == 0 {
                    allPairedPrinters.append(model.first!)
                    self.savePairedPrinterInUserDefaults(model: allPairedPrinters)
                } else {
                    // Get disconnected printer list from user defaults exclude
                    disconnectedPrinters = allPairedPrinters.filter({ $0.serialNumber != model.first?.serialNumber })
                    disconnectedPrinters = disconnectedPrinters.map {
                        var printer = $0
                        printer.deviceConnected = false
                        return printer
                    }
                }
            } else {
                disconnectedPrinters = allPairedPrinters.map {
                    var printer = $0
                    printer.deviceConnected = false
                    return printer
                }
            }
        } catch {
            PMLog.shared.logger?.log(.verbose, message: "No paired printer")
            if let model = modelPrinter {
                self.savePairedPrinterInUserDefaults(model: model)
            }
        }
        return disconnectedPrinters
    }
    
    
    /// function for save printer model to User default
    /// - Parameter model: PrinterModel
    private func savePairedPrinterInUserDefaults(model: [PrinterModel]) {
        let userDefault = UserDefaults.standard
        do {
            try userDefault.setObject(model, forKey: PMAConstants.peripheralDisconnectedDevices)
        } catch {
            PMLog.shared.logger?.log(.verbose, message: "unable to save paired printer details")
        }
    }
}
