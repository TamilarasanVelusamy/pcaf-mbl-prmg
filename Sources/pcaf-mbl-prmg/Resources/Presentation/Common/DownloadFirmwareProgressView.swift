//
//  DownloadFirmwareProgressView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 1/4/23.
//

import SwiftUI

struct DownloadFirmwareProgressView: View {
    
    // firmwareDownloadProgress will come from the delegates when the downloading is implemented. For now we will simulate it
    @Binding var firmwareDownloadProgress: Double
    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("\(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradingFirmware :  PMAConstants.Titles.downloadingFirmware) \(newFirmware)")
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary).padding(1)
                HStack{
                    Image(systemName: PMAConstants.ImageName.cloudArrow).foregroundColor(.gray)
                    Text(String(format: PMAConstants.Titles.zeroPercent, firmwareDownloadProgress) + PMAConstants.Titles.percent)
                        .frame(width: 55).foregroundColor(PMAColor.blackWithOpacityPointTwo)
                        .multilineTextAlignment(.leading)
                        .font(Font.PMA.regular(size: .fifteen))
                    ProgressView("", value: firmwareDownloadProgress, total: 100).padding(.init(top: -15, leading: 2, bottom:0 , trailing: 0))
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.cancelDownloading, object: nil, userInfo: nil)
                    }) {
                        Image(systemName: PMAConstants.ImageName.xCircle).foregroundColor(.gray)
                    }
                }.padding(1)
            }.padding(15)
                .multilineTextAlignment(.leading)
        }

    }
}

struct DownloadFirmwareProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadFirmwareProgressView(firmwareDownloadProgress: .constant(100), firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
