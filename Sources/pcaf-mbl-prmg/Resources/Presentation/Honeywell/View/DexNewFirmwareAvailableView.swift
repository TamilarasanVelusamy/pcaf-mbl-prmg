//
//  DexNewFirmwareAvailableView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 09/03/23.
//

import SwiftUI

struct DexNewFirmwareAvailableView: View {

    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View{
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("\(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradeFirmware :  PMAConstants.Titles.updateFirmware) \(newFirmware) \(PMAConstants.Titles.isAvailble)")
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary).padding(.bottom,10)
                DownloadUpdateButtonView()
            }.padding(15)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .background(PMAColor.white)
        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
        .fixedSize(horizontal: false, vertical: true)
    }
}
struct DexNewFirmwareAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        DexNewFirmwareAvailableView(firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
