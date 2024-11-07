//
//  FirmwareDetailView.swift
//  TestImageList
//
//  Created by amit.verma08 on 10/11/22.
//

import SwiftUI

struct FirmwareDetailView: View {
    @State var textFirst : String = PMAConstants.Titles.firmwareUptoDate
    @Binding var printerModel: PrinterModel
    @Binding var updatedFirmwareVersion : String
    @Binding var showWarningAlert: Bool
    @Binding var showFWUpdateAlert: Bool
    @Binding var firmwareDownloadProgress: Double
    @Binding var firmwareStateView: FirmwareState?
    @Binding var firmwareUpgradeProgress: Double
    @State var deviceIsConnected: Bool = false
    
    var body: some View {
        ZStack() {
            switch firmwareStateView {
                
            case .FirmwareIsUpToDate:
                FirmwareUpToDateView(firmwareVersion: printerModel.firmVersion ?? "")
                
            case .FirmwareUpdateAvailable:
                DeviceNewFirmwareAvailableView(firmwareVersion: printerModel.firmVersion ?? "", newFirmware: updatedFirmwareVersion)
                
            case .FirmwareFileDownload:
                DownloadFirmwareProgressView(firmwareDownloadProgress: $firmwareDownloadProgress, firmwareVersion: printerModel.firmVersion ?? "", newFirmware: updatedFirmwareVersion)
                
            case .FirmwareReadyToInstall:
                FirmwareReadyToInstallView(textFirst: PMAConstants.Messages.warning, deviceConnected: $printerModel.deviceConnected, showFWUpdateAlert: $showFWUpdateAlert, showWarningAlert: $showWarningAlert, firmwareVersion: printerModel.firmVersion ?? "", newFirmware: updatedFirmwareVersion, deviceType: PMAConstants.Titles.brother)
                
            case .FirmwareUpdateInstalled:
                FirmwareUpdatedSuccessfullyView(firmwareVersion: printerModel.firmVersion ?? "", newFirmware: updatedFirmwareVersion)
                
            case .FirmwareUpdateInstalling:
                FirmwareInstallingView(showWarningAlert: $showWarningAlert, deviceConnected: $printerModel.deviceConnected, firmwareUpgradeProgress: $firmwareUpgradeProgress, firmwareVersion: printerModel.firmVersion ?? "", newFirmware: updatedFirmwareVersion)
                
            case .FirmwareBootMode:
                Spacer()
                
            case .none:
                Spacer()
                
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .background(PMAColor.white)
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
    }
}

struct FirmvareDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareDetailView(printerModel: .constant(PrinterModel()), updatedFirmwareVersion: .constant("1.0.1"), showWarningAlert: .constant(false), showFWUpdateAlert: .constant(false), firmwareDownloadProgress: .constant(30.0), firmwareStateView: .constant(.FirmwareIsUpToDate), firmwareUpgradeProgress: .constant(20.0))
    }
}




