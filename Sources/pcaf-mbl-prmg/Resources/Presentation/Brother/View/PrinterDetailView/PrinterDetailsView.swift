//
//  PrinterDetailsViewV1.swift
//  SalesProPlus
//
//  Created by ketan on 16/11/22.
//

import SwiftUI

struct PrinterDetailsView: View {
    @State var printerModel: PrinterModel = PrinterModel()
    @ObservedObject var viewModel = PrinterDetailsViewModel(container: .container())
    @State var showWarningAlert: Bool = false
    @State var showFWUpdateAlert: Bool = false
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack {
            VStack {
                PMANavigationView(navigationBarTitle: PMAConstants.Titles.printerDetails, showLeftBarButton: true, showRightBarButton: false, backgroundColor: PMAColor.lightGray, isTabbar: false, leftBarButtonTitle: "", enableNavigation: .constant(true))
                ScrollView {
                    VStack() {
                        
                        VStack() {
                            Image(.brotherRJ42308)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .padding(.init(top: 32, leading: 0, bottom: 0 , trailing: 0))
                            
                            Text(printerModel.printerName ?? PMAConstants.ErrorMessage.notAvailable)
                                .font(Font.PMA.bold(size: .twentyFive))
                                .multilineTextAlignment(.center)
                                .frame(minHeight: 20)
                                .padding(.init(top: 12, leading: 0, bottom: 0 , trailing: 0))
                            
                            HStack{
                                Image(systemName: PMAConstants.ImageName.circle)
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(printerModel.deviceConnected == true ? PMAColor.green : PMAColor.gray)
                                Text(printerModel.deviceConnected ? PMAConstants.Titles.connected : PMAConstants.Titles.disconnected)
                                    .font(Font.PMA.regular(size: .seventeen))
                                    .foregroundColor(printerModel.deviceConnected == true ? PMAColor.green : PMAColor.gray)
                            }
                            .padding(.bottom, 10)
                        }
                        .frame(maxWidth: .infinity)
                        .background(PMAColor.white)
                        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                        HStack{
                            DeviceStatisticsView(batteryLevel: printerModel.batteryChargeLevel ?? "", version: printerModel.firmVersion ?? "")
                            Divider()
                                .frame(width: 1)
                                .background(PMAColor.lightGrayBackground)
                            DeviceSerialNoView(serialNumber: printerModel.serialNumber ?? "")
                        }
                        .background(PMAColor.white)
                        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
                        .frame(maxWidth: .infinity)
//                        .padding(15)
                       
                        FirmwareDetailView(printerModel: $printerModel, updatedFirmwareVersion: $viewModel.firmwareLatestVersion, showWarningAlert: $showWarningAlert, showFWUpdateAlert: $showFWUpdateAlert, firmwareDownloadProgress: $viewModel.firmwareDownloadProgress, firmwareStateView: $viewModel.firmwareState, firmwareUpgradeProgress: $viewModel.firmwareUpgradeProgress)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
            .background(PMAColor.appBackground)
            ZStack (alignment: .bottom){
                    if printerModel.deviceConnected {
                        DeviceUnpairView(header:PMAConstants.Titles.unpair,title: PMAConstants.Titles.unpairBrother,message: PMAConstants.Titles.brotherUnpairMsg)
                    } else {
                        DeviceUnpairView(header:PMAConstants.Titles.pair,title: PMAConstants.Titles.pairBrother,message: PMAConstants.Titles.printerTurnedOn)
                            
                    }
                }
            }
            .onAppear() {
                viewModel.printerInfo = printerModel
                viewModel.checkNewFirmwareVersion()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.printerConnectionStatusChanged)) { object in
                if let arrayModel = object.userInfo?[PMAConstants.Constants.printerModel] as? [PrinterModel] {
                    let model = arrayModel.filter({ $0.serialNumber == self.printerModel.serialNumber })
                    if model.count > 0 {
                        self.printerModel = model.first ?? PrinterModel()
                        viewModel.printerInfo = printerModel
                        viewModel.checkNewFirmwareVersion()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.downloadFirmwareFile)) { _ in
                viewModel.downloadFirmwareFile()
            }
           
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.installPrinterFirmware)) { _ in
                viewModel.callFWUpdateFromURL()
            }
            
            if showWarningAlert {
                PMACustomAlertView(title: PMAConstants.Titles.installationInformation, message: PMAConstants.Messages.installInfoMessagePrinter, firstButton: PMAConstants.Titles.okay, showSecondButton: false, titleBackgroundColor: PMAColor.white, titleForegroundColor: PMAColor.black, showAlert: $showWarningAlert)
            }
            if showFWUpdateAlert {
                
                if viewModel.batteryLevel < 50  {
                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessageBatteryiOS, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.okay, secondButtonType: PMAConstants.Constants.printerInstall, showSecondButton: false, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                    
                } else if printerModel.batteryChargeLevel?.toInt() ?? 0 < 50 {
                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessagePrinterBattery, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.okay, secondButtonType: PMAConstants.Constants.printerInstall, showSecondButton: false, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                    
                } else {
                    PMACustomAlertView(title: PMAConstants.Titles.warning, message: PMAConstants.Messages.warningMessagePrinter, firstButton: PMAConstants.Titles.cancel, secondButton: PMAConstants.Titles.install, secondButtonType: PMAConstants.Constants.printerInstall, showSecondButton: true, titleBackgroundColor: PMAColor.orderedStatusColor, titleForegroundColor: PMAColor.white, showAlert: $showFWUpdateAlert)
                }
            }
        }               
        .background(PMAColor.white)

    }
}

struct PrinterDetailsViewV1_Previews: PreviewProvider {
    static var previews: some View {
        PrinterDetailsView()
    }
}
