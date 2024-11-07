//
//  FirmwareInstallingView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 1/3/23.
//

import SwiftUI

struct FirmwareInstallingView: View {
    
    @State var textFirst : String = PMAConstants.Titles.firmwareUptoDate
    @Binding var showWarningAlert : Bool
    @Binding var deviceConnected : Bool
    @Binding var firmwareUpgradeProgress: Double

    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                    Text("\(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradeFirmware :  PMAConstants.Titles.updateFirmware) \(newFirmware) \(PMAConstants.Titles.installing)")
                        .font(Font.PMA.bold(size: .fifteen))
                        .foregroundColor(.primary).padding(1)
                        .multilineTextAlignment(.leading)
                    Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary).padding(1)
                        .multilineTextAlignment(.leading)
                    
                    HStack{
                        Text(PMAConstants.Messages.warning)
                            .font(Font.PMA.regular(size: .eleven))
                            .foregroundColor(PMAColor.orderedStatusColor)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 5)
                        Spacer()
                        Button(action: {
                            showWarningAlert.toggle()
                        }) {
                            Image(systemName: PMAConstants.ImageName.infoCircle)
                                .foregroundColor(PMAColor.ctablue)
                            
                        }.frame(width: 24,height: 24)
                        
                    }.multilineTextAlignment(.leading)
        
                HStack{
                    Text(PMAConstants.Titles.installingOnDevice)
                        .font(Font.PMA.regular(size: .fifteen))
                        .frame(width: 140)
                        .foregroundColor(PMAColor.blackWithOpacityPointFive)
                        .multilineTextAlignment(.leading)
                    Image(systemName: PMAConstants.ImageName.circle)
                        .font(.system(size: 5))
                        .foregroundColor(PMAColor.blackWithOpacityPointFive)
                    Text(String(format: PMAConstants.Titles.zeroPercent, firmwareUpgradeProgress) + PMAConstants.Titles.percent)
                        .font(Font.PMA.regular(size: .fifteen))
                        .frame(width: 40)
                        .foregroundColor(PMAColor.blackWithOpacityPointFive)
                        .multilineTextAlignment(.leading)
                    
                    // Place holder for actual progress
                    ProgressView("", value: firmwareUpgradeProgress, total: 100).padding(.init(top: -15, leading: 2, bottom:0 , trailing: 0))

                    Button(action: {
                        
                    }) {
                        //Placeholder until the cancel button is finalized
                        //Image(systemName: PMAConstants.ImageName.xCircle).foregroundColor(.gray)
                    }
                }.multilineTextAlignment(.leading)
                
            }.padding(15)
                .multilineTextAlignment(.leading)
            
        }
    }
}

struct FirmwareInstallingView_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareInstallingView(showWarningAlert: .constant(false), deviceConnected: .constant(true), firmwareUpgradeProgress: .constant(50.2), firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
