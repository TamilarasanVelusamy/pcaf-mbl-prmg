//
//  PrinterModel.swift
//  DeviceManagementApp
//
//  Created by ketan on 17/08/22.
//

import Foundation

struct PrinterModel: Identifiable, Codable  {
    var id = UUID()
    var iPAddress: String?
    var location: String?
    var modelName: String?
    var serialNumber: String?
    var nodeName: String?
    var printerName: String?
    var firmVersion: String?
    var isAutoConnectBluetooth: String?
    var batteryHealthLevel: String?
    var batteryChargeLevel: String?
    var batteryHealthStatus: String?
    var iPhoneName: String?
    var iPhoneSystemName: String?
    var iPhoneSystemVersion: String?
    var iPhoneModel: String?
    var bleAdvertiseLocalName: String?
    var connectionType: ConnectionType?
    var deviceImage: String = PMAConstants.ImageName.printer
    var deviceConnected: Bool = false
}

enum BatteryHealthStatus: String, CodingKey {
    case batteryHealthStatusExcellent = "Excellent"
    case batteryHealthStatusGood = "Good"
    case batteryHealthStatusReplaceSoon = "Replace Soon"
    case batteryHealthStatusReplaceBattery = "Replace Battery"
    case batteryHealthStatusNotInstalled = "Not Installed"
}

enum ConnectionType: String, CodingKey, Codable {
    case wLAN = "WLAN"
    case bluetooth = "Bluetooth"
    case ble = "BLE"
}
