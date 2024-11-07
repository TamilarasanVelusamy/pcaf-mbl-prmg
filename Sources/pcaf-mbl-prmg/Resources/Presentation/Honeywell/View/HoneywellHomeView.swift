//
//  HoneywellHomeView.swift
//  DeviceManagerApp
//
//  Created by Anthony Hoepelman on 9/15/22.
//

import SwiftUI
import CoreBluetooth

struct HoneywellHomeView: View {
    @ObservedObject private var dexViewModel = DexAdapterViewModel(container: .container())
    @State var dexConnectedAlert: Bool = false
    @State var dexConnected: Bool = false
    @State private var showFlashWarningAlert: Bool = false
    @State var showUpgradeWarningAlert: Bool = false
    @State var showFwSuccessAlert: Bool = false
    @State var showFwSuccessfulAlertAfterpair: Bool = false
    @State var showFWUpdateAlert: Bool = false
    @State var showWarningAlert: Bool = false
    @State var showDexWarningAlert: Bool = false
    
    var body: some View{
     
        ZStack {
            VStack {
                PMANavigationView(navigationBarTitle: PMAConstants.Titles.dexCapital, showLeftBarButton: true, showRightBarButton: false, backgroundColor: PMAColor.lightGray, isTabbar: false, leftBarButtonTitle: "", enableNavigation: .constant(true))
                ScrollView {

                    VStack {
                        ZStack {
                            VStack {
                                Image(.dex)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .padding(.init(top: 32, leading: 0, bottom: 20 , trailing: 0))
                                Text(PMAConstants.Titles.dexCapital)
                                    .font(Font.PMA.bold(size: .twenty))
                                    .fontWeight(.bold)
                                HStack{
                                    Image(systemName: PMAConstants.ImageName.circle)
                                        .resizable()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(dexViewModel.connectedState() == true ? PMAColor.greenBackground: PMAColor.gray)
                                        .padding(.init(top: 0, leading: 5, bottom: 0 , trailing: 0))
                                    if dexViewModel.flashMode() {
                                        let successAlert =  UserDefaults.standard.object(forKey: PMAConstants.UserDefaultskey.successFirmwareAlert) as? Bool ?? false
                                        Text(dexViewModel.flashMode() == true ? (dexViewModel.newFirmwareVersion < dexViewModel.getFirmwareVersion() ? (successAlert == true ? PMAConstants.Titles.dexInFlashMode : PMAConstants.Titles.readyToDowngrde) : (successAlert == true ? PMAConstants.Titles.dexInFlashMode :PMAConstants.Titles.readyToUpdate)): PMAConstants.Titles.notPaired)
                                            .font(Font.PMA.regular(size: .seventeen))
                                            .foregroundColor(PMAColor.gray)
                                    }else{
                                        Text(dexViewModel.connectedState() == true ? PMAConstants.Titles.connected: PMAConstants.Titles.notPaired)
                                            .font(Font.PMA.regular(size: .seventeen))
                                            .foregroundColor(dexViewModel.connectedState() == true ? PMAColor.greenBackground: PMAColor.gray)
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        .frame( maxWidth: .infinity,  maxHeight: .infinity, alignment: .center)
                        .background(PMAColor.white)
                        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                        
                        Spacer(minLength: 20)
                        
                        if (dexViewModel.connectedState() && !dexViewModel.flashMode()) {
                            
                            DeviceStatisticsView(batteryLevel: "\(dexViewModel.getDexBatteryLevel() ?? 0)%", version: "")
                                .padding(.init(top: 0, leading: 15, bottom: 5 , trailing: 15))
                                .fixedSize(horizontal: false, vertical: true)
                                .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                        }
                        
                        VStack() {
                            switch dexViewModel.firmwareState {
                                
                            case .FirmwareIsUpToDate:
                                FirmwareUpToDateView(firmwareVersion: dexViewModel.getFirmwareVersion()).hidden(!dexViewModel.connectedState())
                                
                            case .FirmwareUpdateAvailable:
                                DeviceNewFirmwareAvailableView(firmwareVersion: dexViewModel.getFirmwareVersion(), newFirmware: dexViewModel.newFirmwareVersion)
                                
                            case .FirmwareFileDownload:
                                DownloadFirmwareProgressView(firmwareDownloadProgress: $dexViewModel.firmwareDownloadProgress, firmwareVersion: dexViewModel.getFirmwareVersion(), newFirmware: dexViewModel.newFirmwareVersion)
                                
                            case .FirmwareUpdateInstalling:
                                FirmwareInstallingView(showWarningAlert: $showDexWarningAlert, deviceConnected: $dexConnected, firmwareUpgradeProgress: $dexViewModel.firmwareUpgradeProgress, firmwareVersion:dexViewModel.getFirmwareVersion(), newFirmware: dexViewModel.newFirmwareVersion)
                                
                            case .FirmwareReadyToInstall:
                                FirmwareReadyToInstallView(deviceConnected: $dexConnected, showFWUpdateAlert: $showFWUpdateAlert, showWarningAlert: $showUpgradeWarningAlert, firmwareVersion: dexViewModel.getFirmwareVersion(), newFirmware: dexViewModel.newFirmwareVersion, deviceType: PMAConstants.Titles.honeywell)
                                
                            case .FirmwareBootMode:
                                if (dexViewModel.getDexBatteryLevel() ?? 0) < 50 {
                                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageDexBattery, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.okay, secondButtonType: PMAConstants.Constants.dexInstall, showSecondButton: false, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                                    
                                }else{
                                    DexFirmwareFlashModeView(firmwareVersion: dexViewModel.getFirmwareVersion(), newFirmware: dexViewModel.newFirmwareVersion)
                                }
                                
                            case .FirmwareUpdateInstalled:
                                DexFirmwareUpdatedSuccessfullyView(textWarningTitle: PMAConstants.Messages.DexSuccessfullyMessage, showWarningAlert: $showFwSuccessfulAlertAfterpair, deviceConnected: $dexConnected, firmwareVersion: dexViewModel.getFirmwareVersion(), newFirmware: dexViewModel.newFirmwareVersion)
                                
                            case .none:
                                // we need a valid command here which is why we have Spacer()
                                Spacer().frame(width: 0,height: 0)
                                
                            }
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .background(PMAColor.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                    }
//                    .padding(.init(top: 0, leading: 0, bottom: 25 , trailing: 0))

                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                Spacer()
                
                if (!dexViewModel.connectedState() && !dexViewModel.flashMode()) {
                    DexDevicePinView()
                }else  if dexViewModel.connectedState() {
                    DeviceUnpairView(header:PMAConstants.Titles.unpair,title: PMAConstants.Titles.unpairDex,message: PMAConstants.Titles.dexUnpairMsg).padding(.init(top: 10, leading: 0, bottom: 0 , trailing: 0))
                }else {
                    DexDevicePinView().hidden(dexViewModel.firmwareState == nil ? false : true)
                }
               
            } 
           // .background(Image(.appBackground))//

//            .background(PMAColor.viewBackground)
            
            if dexConnectedAlert {
                DexAdapterPairedSucessView(showAlert: $dexConnectedAlert)
            }
            if showDexWarningAlert {
                PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageDex, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showDexWarningAlert)
            }
            if showFlashWarningAlert {
                
                PMACustomAlertView(title: PMAConstants.Titles.installationInformation, message: PMAConstants.Messages.dexFlashModeInfomationMessage, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showFlashWarningAlert)
            }
            if showUpgradeWarningAlert {
                
                PMACustomAlertView(title: PMAConstants.Titles.installationInformation, message: PMAConstants.Messages.DexWarningMessage, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showUpgradeWarningAlert)
            }
            if showFWUpdateAlert {
                
                if dexViewModel.getIphoneBatteryLevel() < 50  {
                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageBatteryiOS, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.okay, secondButtonType: PMAConstants.Constants.dexInstall, showSecondButton: false, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                }
                else {
                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageDex, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.install, secondButtonType: PMAConstants.Constants.dexInstall, showSecondButton: true, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                }
            }
            
            if showFwSuccessAlert {
                PMACustomAlertView(title: (dexViewModel.newFirmwareVersion < dexViewModel.getFirmwareVersion() ? PMAConstants.Titles.downgradeSuccessfully : PMAConstants.Titles.updateSuccessfully), message: PMAConstants.Messages.DexUpgradeSuccessfullyMessage, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showFwSuccessAlert)
            }
            
            if showFwSuccessfulAlertAfterpair {
                PMACustomAlertView(title: (dexViewModel.newFirmwareVersion < dexViewModel.getFirmwareVersion() ? PMAConstants.Titles.downgradeSuccessfully : PMAConstants.Titles.updateSuccessfully), message: PMAConstants.Messages.DexSuccessfullyMessage, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showFwSuccessfulAlertAfterpair)
            }
        }
        .onAppear() {
            if(dexViewModel.connectedState() && dexViewModel.flashMode()) {
                dexConnected = dexViewModel.connectedState()
                dexViewModel.readyToInstall()
            }else if(dexViewModel.connectedState()) {
                dexConnected = dexViewModel.connectedState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dexViewModel.checkNewFirmwareVersion()
                }
            }else{
                dexViewModel.setFirmwareStateNone()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.cancelDownloading)) { _ in
            dexViewModel.firmwareAvalilable()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.dexConnected)) { _ in
            if (dexViewModel.connectedState() && dexViewModel.flashMode()) {
                dexViewModel.readyToInstall()
            }
            dexConnected = dexViewModel.connectedState()
            dexConnectedAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.dexConnectedAlert.toggle()
                dexViewModel.checkNewFirmwareVersion()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.downloadFirmwareFile)) { _ in
            dexViewModel.downloadFirmwareFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.enterDexFlashMode)) { _ in
            dexViewModel.setFlashMode()
            showFlashWarningAlert = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.firmwareInstalling)) { _ in
            dexViewModel.firmwareInstalling()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.installFirmware)) { _ in
            dexViewModel.upgradeDexFirmware()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.dexFirmwareInstalledNotification)) { _ in
            dexViewModel.setFirmwareStateNone()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.dexDeviceFWUpgradeSuccessAlert)) { _ in
            dexViewModel.firmwareUpTodate()
            showFwSuccessAlert.toggle()
            UserDefaults.standard.set( true, forKey: PMAConstants.UserDefaultskey.successFirmwareAlert)
            dexViewModel.deleteFirmwareFile()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if !dexViewModel.connectedState() {
                dexViewModel.setFirmwareStateNone()
            }
        }
        .background(PMAColor.appBackground)
    }
}

struct HoneywellHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HoneywellHomeView()
    }
}
