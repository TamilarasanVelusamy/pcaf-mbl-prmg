//
//  Navigation+Extension.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 28/12/22.
//

import Foundation
import SwiftUI

// View modifier for navigation bar hidden property
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

//MARK: NSNotification Extension

extension NSNotification {
    static let cancelDownloading = Notification.Name.init("CancelDownloading")
    static let dexConnected = Notification.Name.init("DexConnected")
    static let dexDeviceFWUpgradeSuccessAlert = Notification.Name.init("DexDeviceFirmwareSuccessAlert")
    static let dexFirmwareInstalledNotification = Notification.Name.init("DexFirmwareInstalledNotification")
    static let FirmwareInstallCompleted = Notification.Name.init("FirmwareInstallCompleted")
    static let dexUnPlugged = Notification.Name.init("DexUnPlugged")
    static let downloadFirmwareFile = Notification.Name.init("DownloadFirmwareFile")
    static let enterDexFlashMode = Notification.Name.init("EnterDexFlashMode")
    static let firmwareAvailable = Notification.Name.init("FirmwareAvailable")
    static let firmwareDownloadButtonPressed = Notification.Name.init("FirmwareDownloadButtonPressed")
    static let firmwareDownloadProgress = Notification.Name.init("FirmwareDownloadProgress")
    static let firmwareDownloaded = Notification.Name.init("FirmwareDownloaded")
    static let firmwareInstalling = Notification.Name.init("FirmwareInstalling")
    static let installFirmware = Notification.Name.init("InstallFirmware")
    static let installPrinterFirmware = Notification.Name.init("InstallPrinterFirmware")
    static let installScannerFirmware = Notification.Name.init("InstallScannerFirmware")
    static let nfcPin = Notification.Name.init("NfcPin")
    static let pinCopied =  Notification.Name.init("PinCopied")
    static let printerConnectionStatusChanged = Notification.Name.init("PrinterConnectionStatusChanged")
    static let scannerConnected = Notification.Name.init("ScannerConnected")
    static let scannerFirmwareInstallCompleted = Notification.Name.init("ScannerFirmwareInstallCompleted")
    static let scannerUnPlugged = Notification.Name.init("ScannerUnPlugged")
    static let uncheckStoreWalkPromo = Notification.Name.init("uncheckStoreWalkPromo")
    static let greenChkMarkSelected = Notification.Name.init("greenCheckDeselect")
}

