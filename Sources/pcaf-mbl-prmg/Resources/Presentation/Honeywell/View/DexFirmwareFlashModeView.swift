//
//  FirmwareFlashModeView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 28/02/23.
//

import SwiftUI

struct DexFirmwareFlashModeView: View {
    
    @State var textFirst : String = PMAConstants.Titles.firmwareUptoDate
    @ObservedObject private var dexViewModel = DexAdapterViewModel(container: .container())
    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("\(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradeFirmware :  PMAConstants.Titles.updateFirmware) \(newFirmware) \(PMAConstants.Titles.fwisreadyToInstall)")
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary).padding(1)
                if dexViewModel.connectedState() {
                    FlashModeButtonView()
                } else {
                    ConnectForFirmwareView()
                }
            }.padding(10)
             .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
          
    }
}

struct FirmwareFlashModeView_Previews: PreviewProvider {
    static var previews: some View {
        DexFirmwareFlashModeView(firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
