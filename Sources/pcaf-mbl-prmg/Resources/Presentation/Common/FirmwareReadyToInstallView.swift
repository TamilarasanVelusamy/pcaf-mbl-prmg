//
//  FirmwareReadyToInstallView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/29/22.
//

import SwiftUI

struct FirmwareReadyToInstallView: View {
    
    @State var textFirst : String = PMAConstants.Titles.firmwareUptoDate
    @Binding var deviceConnected : Bool
    @Binding var showFWUpdateAlert : Bool
    @Binding var showWarningAlert : Bool
    var firmwareVersion : String
    var newFirmware : String
    var deviceType: String
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("\(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradeFirmware :  PMAConstants.Titles.updateFirmware) \(newFirmware) \(PMAConstants.Titles.fwisreadyToInstall)")
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary).padding(1)
                
                if deviceConnected {
                    HStack{
                        Text(PMAConstants.Messages.warning)
                            .font(Font.PMA.regular(size: .eleven))
                            .foregroundColor(PMAColor.orderedStatusColor)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 10)
                        Spacer()
                        Button(action: {
                            showWarningAlert.toggle()
                        }) {
                            Image(systemName: PMAConstants.ImageName.infoCircle)
                                .foregroundColor(PMAColor.blue)
                            
                        }.frame(width: 24,height: 24)
                        
                    }.multilineTextAlignment(.leading)
                    
                    InstallOnDeviceButtonView(showFWUpdateAlert: $showFWUpdateAlert)
                    
                } else {
                    if(deviceType == PMAConstants.Titles.unitech){
                        PMAActivityIndicatorView(message: PMAConstants.Titles.firmwareStarting)
                    }else{
                        ConnectForFirmwareView()
                    }
                }
            }
            .padding(15)
            .multilineTextAlignment(.leading)
        }
    }
}

struct FirmwareReadyToInstallView_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareReadyToInstallView(deviceConnected: .constant(true), showFWUpdateAlert: .constant(false), showWarningAlert: .constant(true), firmwareVersion: "1.2.3", newFirmware: "1.2.4", deviceType: "Unitech")
    }
}
