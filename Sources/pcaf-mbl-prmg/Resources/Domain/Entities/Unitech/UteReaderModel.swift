//
//  UteReaderModel.swift
//  DeviceManagerApp
//
//  Created by Anthony Hoepelman on 9/15/22.
//

import Foundation

class UteReaderModel: ObservableObject {

    // AH - model for information we wish to get or show
    var scannerName: String  = ""
    var scanerManufacturer: String  = ""
    var scanerModelNumber: String  = ""
    var scannerHardwareVersion: String  = ""
    var scannerFirmwareVersion: String = ""
    var scanerSerialNumber: String  = ""
    var deviceState: String  = ""
    var scannerBattery: Int = 0
}
