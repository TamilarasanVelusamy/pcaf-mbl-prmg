//
//  FirmwareState.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/30/22.
//

import Foundation

enum FirmwareState {
    
    case FirmwareBootMode
    case FirmwareIsUpToDate
    case FirmwareFileDownload
    case FirmwareReadyToInstall
    case FirmwareUpdateAvailable
    case FirmwareUpdateInstalled
    case FirmwareUpdateInstalling
}
