//
//  DeviceNewFirmwareAvailableView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/30/22.
//

import SwiftUI

struct DeviceNewFirmwareAvailableView: View {

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
    }
}

struct DeviceNewFirmwareAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceNewFirmwareAvailableView(firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
