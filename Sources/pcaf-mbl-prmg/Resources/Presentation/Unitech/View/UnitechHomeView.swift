//
//  UnitechHomeView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 1/27/23.
//

import Foundation
import SwiftUI

struct UnitechHomeView: View {
    
    @StateObject private var device = UnitechHomeViewModel(container: .container())
    @State var scannerConnected: Bool = false
    @State var showWarningAlert: Bool = false
    @State var showFWUpdateAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                PMANavigationView(navigationBarTitle: PMAConstants.Titles.scanner, showLeftBarButton: true, showRightBarButton: false, backgroundColor: PMAColor.lightGray, isTabbar: false, leftBarButtonTitle: "", enableNavigation: .constant(true))
                ScrollView {
                    VStack {
                        VStack() {
                            Image(.uteScanner)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .padding()
                            
                            Text(PMAConstants.Titles.twoDScanner)
                                .font(Font.PMA.bold(size: .twenty))
                            
                            HStack{
                                Image(systemName: PMAConstants.ImageName.circle)
                                    .resizable()
                                    .frame(width: PMAConstants.Constants.Size.eight.rawValue, height: PMAConstants.Constants.Size.eight.rawValue)
                                    .foregroundColor(device.scannerDetails.deviceState == PMAConstants.Titles.connected ? PMAColor.greenBackground: PMAColor.gray)
                                    .padding(.init(top: 0, leading: 5, bottom: 20 , trailing: 0))
                                
                                Text(!device.scannerDetails.deviceState.isEmpty ? device.scannerDetails.deviceState : PMAConstants.Titles.disconnected)
                                    .font(Font.PMA.regular(size: .seventeen))
                                    .foregroundColor(device.scannerDetails.deviceState == PMAConstants.Titles.connected ? PMAColor.greenBackground: PMAColor.gray)
                                    .padding(.bottom, 20)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(PMAColor.white)
                        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                        
//                        Spacer()
                        
                        if device.scannerDetails.deviceState == PMAConstants.Titles.connected {
                            ScannerDeviceStatisticsView(batteryLevel: device.scannerDetails.scannerBattery, version: device.scannerDetails.scannerHardwareVersion)
                            
                        }
//                        Spacer()
                        VStack() {
                        switch device.firmwareState {
                            
                        case .FirmwareIsUpToDate:
                            FirmwareUpToDateView(firmwareVersion: device.scannerDetails.scannerFirmwareVersion)
                            //                                Spacer()
                            
                        case .FirmwareUpdateAvailable:
                            DeviceNewFirmwareAvailableView(firmwareVersion: device.scannerDetails.scannerFirmwareVersion, newFirmware: device.newFirmwareVersion)
                            
                        case .FirmwareFileDownload:
                            DownloadFirmwareProgressView(firmwareDownloadProgress: $device.firmwareDownloadProgress, firmwareVersion: device.scannerDetails.scannerFirmwareVersion, newFirmware: device.newFirmwareVersion)
                            
                        case .FirmwareReadyToInstall:
                            FirmwareReadyToInstallView(deviceConnected: $scannerConnected, showFWUpdateAlert: $showFWUpdateAlert, showWarningAlert: $showWarningAlert, firmwareVersion: device.scannerDetails.scannerFirmwareVersion, newFirmware: device.newFirmwareVersion, deviceType: PMAConstants.Titles.unitech)
                            
                        case .FirmwareUpdateInstalling:
                            FirmwareInstallingView(showWarningAlert: $showWarningAlert, deviceConnected: $scannerConnected, firmwareUpgradeProgress: $device.firmwareUpgradeProgress, firmwareVersion: (UserDefaults.standard.string(forKey: PMAConstants.UserDefaultskey.oldFirmwareVersion) ?? ""), newFirmware: device.newFirmwareVersion)
                            
                            
                        case .FirmwareUpdateInstalled:
                            FirmwareUpdatedSuccessfullyView(firmwareVersion: (UserDefaults.standard.string(forKey: PMAConstants.UserDefaultskey.oldFirmwareVersion) ?? ""), newFirmware: device.newFirmwareVersion)
                            
                        case .FirmwareBootMode:
                            Spacer().frame(width: 0,height: 0)
                            
                        case .none:
                            // we need a valid command here which is why we have Spacer()
                            Spacer().frame(width: 0,height: 0)
                            
                        }
                    }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .background(PMAColor.white)
                        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        
                    }.padding(.init(top:0, leading: 0, bottom: 20, trailing: 0))
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                if !self.scannerConnected {
                    
                    ScannerConnectMsgView(message: PMAConstants.Titles.scannerEnsurePlugged).padding(.init(top: 0, leading: 0, bottom: 10 , trailing: 0))
                    //                    .background(Image(.appBackground))
                }
                if showWarningAlert {
                    
                    PMACustomAlertView(title: PMAConstants.Titles.installationInformation, message: PMAConstants.Messages.installInfoMessageScanner, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showWarningAlert)
                }
                
                if showFWUpdateAlert {
                    
                    if device.iOSbatteryLevel < 50  {
                        
                        PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageBatteryiOS, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.okay, secondButtonType: PMAConstants.Constants.scannerInstall, showSecondButton: false, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                        
                    } else if device.scannerDetails.scannerBattery < 50 {
                        
                        PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageScannerBattery, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.okay, secondButtonType: PMAConstants.Constants.scannerInstall, showSecondButton: false, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                        
                    } else {
                        
                        PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageScanner, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.install, secondButtonType: PMAConstants.Constants.scannerInstall, showSecondButton: true, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                    }
                }
                
                if(device.invalidFirmwareFileAlert == true){
                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageFirmwareFile, firstButton: PMAConstants.Titles.okay, secondButton: "", secondButtonType: "", showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $device.invalidFirmwareFileAlert)
                }
            }
            .background(PMAColor.appBackground)
        }
        .onAppear() {
            
            if device.scannerDetails.deviceState == PMAConstants.Titles.connected {
                self.scannerConnected = true
            }
        }
        .onDisappear() {
            
            device.closeSession()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.cancelDownloading)) { _ in
            device.firmwareAvalilable()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.downloadFirmwareFile)) { _ in
            device.downloadFirmwareFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.firmwareAvailable)) { _ in
            device.firmwareFileReadyToInstall()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.FirmwareInstallCompleted)) { _ in
            device.firmwareInstallSucessfull()
            device.deleteFirmwareFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.firmwareInstalling)) { _ in
            device.firmwareInstalling()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.installScannerFirmware)) { _ in
            device.installScannerFirmware()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.scannerConnected)) { _ in
            self.scannerConnected = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.scannerUnPlugged)) { _ in
            self.scannerConnected = false
            device.firmwareUpTodate()
        }
    }
}

struct UnitechHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UnitechHomeView()
    }
}



