//
//  DeviceModel.swift
//  TestImageList
//
//  Created by anthony.hoepelman on 11/2/22.
//

import Foundation
import SwiftUI

struct PeripheralDeviceModel: Identifiable {
    internal let id = UUID()
    var deviceType: String = ""
    var deviceName: String = ""
    var deviceConnected: Bool = false
    var deviceImage: Image 
}
