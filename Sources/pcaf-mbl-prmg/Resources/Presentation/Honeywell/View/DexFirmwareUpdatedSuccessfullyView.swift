//
//  DexFirmwareUpdatedSuccessfullyView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 02/03/23.
//

import SwiftUI

struct DexFirmwareUpdatedSuccessfullyView: View {

    @State var textWarningTitle : String
    @Binding var showWarningAlert : Bool
    @Binding var deviceConnected : Bool
    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(PMAColor.white)
            VStack(alignment: .leading) {
                Text(PMAConstants.Titles.firmwareUptoDate)
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                    HStack{
                        Text(textWarningTitle)
                            .font(Font.PMA.regular(size: .eleven))
                            .foregroundColor(PMAColor.orderedStatusColor)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom,2)
                        Spacer()
                        Button(action: {
                            showWarningAlert.toggle()
                        }) {
                            Image(systemName: PMAConstants.ImageName.infoCircle)
                                .foregroundColor(PMAColor.blue)
                        }.frame(width: 24,height: 24)
                    }.multilineTextAlignment(.leading)
                DexFirmwareUpdatedSuccessfullyMsgView(firmwareVersion: firmwareVersion, newFirmware: newFirmware)
            }.padding(15)
                .multilineTextAlignment(.leading)
            
        }
            
    }
}

struct DexFirmwareUpdatedSuccessfullyView_Previews: PreviewProvider {
    static var previews: some View {
        DexFirmwareUpdatedSuccessfullyView(textWarningTitle: PMAConstants.Messages.warning, showWarningAlert: .constant(false), deviceConnected: .constant(true), firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
